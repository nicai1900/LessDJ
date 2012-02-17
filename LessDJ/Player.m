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

@implementation Player

static Player *_gPlayer;
+(Player*)s
{
    if (!_gPlayer) {
        return nil;
    }
    return _gPlayer;
}

- (id)initWithJam:(AppleJam *)jam
{
    if (!_gPlayer) {
        self = [super initWithJam:jam];
        _gPlayer = self;
    }
    return _gPlayer;
}


- (void)nextTrack
{
    
}
- (void)togglePlay
{
    
}
- (void)changeVolume:(NSNumber*)volume
{
    
}
- (void)changeChannel:(NSNumber*)channel
{
    
}
- (void)changeProgress:(NSNumber*)progress
{
    
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
    
}
- (void)appArtworkChanged:(NSURL*)url
{
    
}
- (void)appStateChanged:(BOOL)isPlaying
{
    
}
- (void)appBuffingChanged:(BOOL)isBuffing
{
    
}
@end
