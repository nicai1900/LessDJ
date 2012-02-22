//
//  Player.h
//  LessDJ
//
//  Created by xu xhan on 2/17/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JamCommand.h"
@class DBItem;
@interface Player : JamCommand
{
    NSTimer*timer;
}
+(Player*)s;

// js connection methods
- (void)nextTrack;
- (void)togglePlay;
- (void)changeVolume:(NSNumber*)volume;
//- (void)changeChannel:(NSNumber*)channel;
- (void)changeProgress:(NSNumber*)progress;
- (void)closeWindow;
- (void)minimizeWindow;
- (void)showChannelList;

// app methods
- (void)appSongChanged:(DBItem*)item;
- (void)appArtworkChanged:(NSURL*)url;
- (void)appStateChanged:(BOOL)isPlaying;
- (void)appBuffingChanged:(BOOL)isBuffing;
- (void)appChannelLoaded:(NSDictionary*)channels;

- (void)_onTick;
- (void)startTick;
@end
