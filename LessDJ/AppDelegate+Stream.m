//
//  LessDJAppDelegate+Stream.m
//  LessDJ
//
//  Created by xu xhan on 2/9/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import "AppDelegate+Stream.h"
#import "AudioStreamer.h"

@implementation AppDelegate (Stream)
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
            
        [streamer stop];        
        usleep(1000);
        [streamer stop];
        
		[streamer release];
		streamer = nil;
	}
}

- (void)createStreamer:(NSURL*)url;
{
	if (streamer)
	{
        [self destroyStreamer];
	}
	

	streamer = [[AudioStreamer alloc] initWithURL:url];

	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
//		[self setButtonImage:[NSImage imageNamed:@"loadingbutton"]];
	}
	else if ([streamer isPlaying])
	{
//		[self setButtonImage:[NSImage imageNamed:@"stopbutton"]];
	}
	else if ([streamer isIdle])
	{
//		[self destroyStreamer];
//		[self setButtonImage:[NSImage imageNamed:@"playbutton"]];
        [self playNext:nil];
	}
}

@end
