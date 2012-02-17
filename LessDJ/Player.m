//
//  Player.m
//  LessDJ
//
//  Created by xu xhan on 2/17/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import "Player.h"
#import "AppleJam.h"
#import "AppDelegate.h"

#import "DBList.h"
#import "JSONKit.h"
#import "JSON.h"

@implementation Player

static Player *_gPlayer;
+(Player*)s
{
    return _gPlayer;
}

- (id)initWithJam:(AppleJam *)jam
{
//   ensure just create one instance 
    if (!_gPlayer) {
        self = [super initWithJam:jam];
        _gPlayer = self;
    }else{
        [_gPlayer retain];
    }
    return _gPlayer;
}

- (void)dealloc
{
    _gPlayer = nil;
    [timer invalidate];
    [super dealloc];
}


- (void)nextTrack
{
    [[AppDelegate s] playNext:nil];
}
- (void)togglePlay
{
    [[AppDelegate s] onTogglePlay:nil];
}

- (void)changeVolume:(NSNumber*)volume
{
    [[AppDelegate s] onChangeVolume:[volume floatValue]];
}
- (void)changeChannel:(NSNumber*)channel
{
    [[AppDelegate s] onChangeChannel:[channel intValue]];
}
- (void)changeProgress:(NSNumber*)progress
{
    [[AppDelegate s] onChangeProgress:[progress floatValue]];
}
- (void)closeWindow
{
    
}
- (void)minimizeWindow
{
    
}

#pragma mark - 

- (void)appSongChanged:(DBItem*)item
{
    NSString* json = [item.dict JSONRepresentation];
    NSString* script = [NSString stringWithFormat:@"app_song_changed(%@)",json];
    [self runScript:script];
}
- (void)appArtworkChanged:(NSURL*)url
{
    NSString* src = [url absoluteString];
    NSString* script = [NSString stringWithFormat:@"app_artwork_changed('%@')",src];
    [self runScript:script];
}
- (void)appStateChanged:(BOOL)isPlaying
{
    NSString* script =[NSString stringWithFormat:@"app_player_state_change(%d,null)",isPlaying];
    [self runScript:script];
}
- (void)appBuffingChanged:(BOOL)isBuffing
{
    NSString* script =[NSString stringWithFormat:@"app_player_state_change(null,%d)",isBuffing];
    [self runScript:script];
}


- (void)appChannelLoaded:(NSDictionary*)channels
{
    
}

#pragma mark -

- (void)_onTick
{
    float location = [AppDelegate s].songLocation;
    NSString* script =[NSString stringWithFormat:@"app_player_location_changed(%f)",location];
    [self runScript:script];
}

- (void)startTick
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(_onTick)
                                           userInfo:nil
                                            repeats:YES];
}

@end
