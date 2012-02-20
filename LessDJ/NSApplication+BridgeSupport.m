//
//  NSApplication+BridgeSupport.m
//  LessDJ
//
//  Created by xu xhan on 11/11/11.
//  Copyright (c) 2011 xu han. All rights reserved.
//

#import "NSApplication+BridgeSupport.h"
#import "DBList.h"
#import "AppDelegate.h"

@implementation NSApplication (BridgeSupport)

//currentSongItem;
- (DBItem*)currentSongItem
{
    AppDelegate* delegate = (AppDelegate*)[NSApp delegate];
    return delegate.curItem;
}

- (CGFloat)currentLocation
{
    AppDelegate* delegate = (AppDelegate*)[NSApp delegate];
    return delegate.songLocation;    
}

- (NSScriptObjectSpecifier *)objectSpecifier
{
    return nil;
}
@end

