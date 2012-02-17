//
//  LessDJAppDelegate+Stream.h
//  LessDJ
//
//  Created by xu xhan on 2/9/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Stream)
- (void)createStreamer:(NSURL*)url;
- (void)destroyStreamer;
@end
