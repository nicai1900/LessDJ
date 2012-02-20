//
//  LessDJAppDelegate+action.m
//  LessDJ
//
//  Created by xu xhan on 2/10/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import "AppDelegate+action.h"
#import "AppDelegate.h"
#import "WindowController.h"
@implementation AppDelegate (action)
- (IBAction)reloadTheme:(id)sender
{
    [windowc.window close];
    PLSafeRelease(windowc);
    
    NSArray* pathes = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    if (pathes.count ==0) return;
    NSString* path = [[pathes lastObject] stringByAppendingPathComponent:@"test.lessdj"];
    
    
    
    windowc = [[WindowController alloc] initWithTheme:path];
    [windowc.window center];
    [windowc showWindow:nil];
}
@end
