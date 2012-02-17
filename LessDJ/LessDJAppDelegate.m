//
//  LessDJAppDelegate.m
//  LessDJ
//
//  Created by xu xhan on 9/29/11.
//  Copyright 2011 xu han. All rights reserved.
//

#import "LessDJAppDelegate.h"
#import "LessDJAppDelegate+Stream.h"

#import "DBFM.h"
#import "DBList.h"
#import "NSImageLoader.h"
#import "NSImageView+RemoteImage.h"

#import "AudioStreamer.h"
#import "Settings.h"

#import "WindowController.h"

@implementation LessDJAppDelegate

@synthesize labelPosition;
@synthesize labelTitle;
@synthesize labelArtist;
@synthesize viewArtwork;
@synthesize viewChannels;
@synthesize labelAlbum;
@synthesize btnPlayState;
@synthesize progressSlider;

@synthesize window, fm, curItem;


#pragma mark - App Life Cycle

- (void)killApp
{
    /* Note: application terminate
     callback on applicationWillTerminate and then sleep thread not works (seems like it will be killed by app)
     */
    [NSApp replyToApplicationShouldTerminate:YES];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    //注意：这里系统runroop变成modal panel了，需要设置timer的runloop 否者无法生效
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.xhan.LessDJ.willTerminate"
                                                                   object:@"com.xhan.LessDJ"
                                                                 userInfo:nil
                                                       deliverImmediately:YES];
    [self performSelector:@selector(killApp) withObject:nil afterDelay:0.3 inModes:[NSArray arrayWithObject:NSModalPanelRunLoopMode]];
    return NSTerminateLater;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [AppSetting() synchronize];
}

- (void)dealloc
{
    [self updateProgressTimerState:NO];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    isAVPlayer = NSClassFromString(@"AVPlayer") != nil; 
//    isAVPlayer = NO;
    self.fm = [[[DBFM alloc] init] autorelease];
    fm.delegate = self;
    delayOperation = OperationNext;
    [fm reloadList];
    volume = 1;
    isStatePlaying = YES;
    
    [self addAVPlayerNotifyCallBack];
    [self updateProgressTimerState:YES];

    windowc = [[WindowController alloc] init];
    [windowc.window center];
    [windowc showWindow:nil];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [window orderFront:nil];
    return YES;
}


- (void)awakeFromNib
{
    CGSize windowSize = [window frame].size;
    [viewChannels setAutoresizingMask:NSViewMinXMargin|NSViewMinYMargin];
    [viewChannels setFrameOrigin:CGPointMake(windowSize.width - 80, windowSize.height - 20)];
    [[[window contentView] superview] addSubview:viewChannels];
}
#pragma mark - methods

- (void)updateProgressTimerState:(BOOL)isOn
{
    if (isOn) {
        [self updateProgressTimerState:NO];
        progressUpdateTimer =
        [NSTimer
         scheduledTimerWithTimeInterval:0.1
                                 target:self
                               selector:@selector(updateProgress:)
                               userInfo:nil
                                repeats:YES];
    }else{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;        
    }
}

- (void)addAVPlayerNotifyCallBack
{
    if (!isAVPlayer) return;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(avplayerItemDidEnded:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(avplayerItemDidEnded:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:nil];    
}

- (void)avplayerItemDidEnded:(NSNotification*)notify
{
    [self playNext:nil];
}



- (IBAction)playNext:(id)sender {
    if (isAVPlayer) {
        [avplayer pause];
        PLSafeRelease(avplayer);
    }

    
    [progressSlider setDoubleValue:0];
    
    DBItem* item = [fm.list nextItem];
    if (!item) {
        NSLog(@"no play item founded");
        delayOperation = OperationNext;
        return;
    }
    delayOperation = OperationNone;
    self.curItem = item;
    
    // update player button
    isStatePlaying = YES;
    [btnPlayState setImage:[NSImage imageNamed:!isStatePlaying?@"play":@"pause"]];
    
    [labelTitle setStringValue:item.title];
    [labelArtist setStringValue:item.artist];
    [labelAlbum  setStringValue:[NSString stringWithFormat:@"< %@ > %@",item.album,item.publicTime]];
    
    
    [viewArtwork loadImage:item.albumArtworkLargeURL
               placeholder:@"default_cover"];
    
    [window setTitle:[NSString stringWithFormat:@"%@ - %@",item.title,@"LessDJ"]];
    
    if (isAVPlayer) {
        avplayer = [[AVPlayer alloc] initWithURL:item.songURL];
        avplayer.volume = volume;
        [avplayer play];
    }else{
        [self createStreamer:item.songURL];
        [streamer start];
        [streamer setVolume:volume];
    }


    
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.xhan.LessDJ.songchanged"
                                                                   object:@"com.xhan.LessDJ"
                                                                 userInfo:nil
                                                       deliverImmediately:YES];

    [windowc songChanged:item];
}

- (IBAction)onTogglePlay:(id)sender
{
    isStatePlaying = !isStatePlaying;
    [btnPlayState setImage:[NSImage imageNamed:!isStatePlaying?@"play":@"pause"]];
    if (isStatePlaying) {
        if(isAVPlayer) [avplayer play];
        else  [streamer start];
    }else{
        if(isAVPlayer) [avplayer pause];
        else  [streamer pause];
    }
    [windowc play:isStatePlaying];
}



- (IBAction)onVolumeChanged:(NSSlider*)sender {
    volume = [sender doubleValue];
    if(isAVPlayer) [avplayer setVolume:volume];
    else [streamer setVolume:volume];          
}

- (IBAction)onPopUpChanged:(NSPopUpButton*)sender {
    delayOperation = OperationNext;
    AppSetting().channelIndex =  (int)[sender indexOfSelectedItem];
    [fm setChannelAtIndex:AppSetting().channelIndex];
}

- (IBAction)onProgressChanged:(id)sender
{
    float desireSeconds = [progressSlider doubleValue]*self.curItem.length/100;
    if (isAVPlayer) {
        CMTime ctime_ = avplayer.currentTime;
        [avplayer seekToTime:CMTimeMakeWithSeconds(desireSeconds, ctime_.timescale)];
    }else{
        [streamer seekToTime:desireSeconds];
    }

}

- (IBAction)onGetLL:(id)sender {
//#ifdef Appstore    
    [[NSWorkspace sharedWorkspace] openURL:URL(@"http://ixhan.com/lesslyrics")];
}

- (IBAction)onOrderFront:(id)sender
{
    [window orderFront:nil];
}

- (void)updateProgress:(NSTimer *)updatedTimer
{
    if (isAVPlayer) {
        if (avplayer.status == AVPlayerStatusReadyToPlay) {
            CMTime ctime_ = avplayer.currentTime;
            double duration = self.curItem.length;
            if (CMTIME_IS_VALID(ctime_)) {
                Float64 t = CMTimeGetSeconds(ctime_);
                
                [progressSlider setDoubleValue:100 * t / duration];            
                
                int playerLocation = (int)[self songLocation];
                int min = playerLocation / 60;
                int sec = playerLocation % 60;
                [labelPosition setStringValue:[NSString stringWithFormat:@"%d:%02d",min,sec]];
            }else{
                [labelPosition setStringValue:@"loading..."];
            }
            
        }else{
            [labelPosition setStringValue:@"loading..."];
        }
    }else{
        if ([streamer isPlaying]) {
            double t = streamer.progress;
            double duration = self.curItem.length;
            t = MIN(duration, t);
            [progressSlider setDoubleValue:100 * t / duration];            
            
            int playerLocation = (int)t;
            int min = playerLocation / 60;
            int sec = playerLocation % 60;
            [labelPosition setStringValue:[NSString stringWithFormat:@"%d:%02d",min,sec]];
        }else{
            [labelPosition setStringValue:@"loading..."];
        }
    }


}


- (CGFloat) songLocation
{
    if (isAVPlayer) {
        CGFloat location = 0;
        CMTime ctime_ = avplayer.currentTime;
        if (CMTIME_IS_VALID(ctime_)) {
            location = CMTimeGetSeconds(ctime_);
        }
        return MAX(0, location);
    }else{
        return streamer.progress;
    }

}


#pragma mark - FM Service Delegate

- (void)dbfmResponseReceived:(DBResponseType)type state:(BOOL)isSuccess
{
    switch (type) {
        case DBResponseTypeChannel:{
            static int listRetryCount = 0;
            if (isSuccess) {
                listRetryCount = 0;
                delayOperation = OperationNext;
                long v = [fm setChannelAtIndex:AppSetting().channelIndex];   
                [self.viewChannels selectItemAtIndex:v];
                
            }else{
                listRetryCount += 1;
                if (listRetryCount > 3) {
                    PLOGERROR(@"fetch List failed ,try it later");
                }else{
                    [fm reloadList];
                }                
            }
        }break;
        case DBResponseTypeSongList:{
            if (isSuccess && (delayOperation != OperationNone)) {
                delayOperation = OperationNone;
                [self playNext:nil];
            }
            if (isSuccess) {
                // precache images
                
                int size = (int)MIN([fm.list.items count], 5);
                for (int i = 0; i < size; i++) {
                    DBItem* item = [fm.list.items objectAtIndex:i];
                    [NSImageLoader fetch:item.albumArtworkLargeURL view:nil];
                }
            }
        }break;
    }
}


+ (LessDJAppDelegate*)s
{
    return (LessDJAppDelegate*)([NSApplication sharedApplication].delegate);
}
@end
