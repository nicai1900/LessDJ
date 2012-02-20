//
//  WindowController.m
//  LessDJ
//
//  Created by xu xhan on 2/15/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import "WindowController.h"
#import "DBList.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "AppleJam.h"
#import "Player.h"

@implementation WindowController
@synthesize webView;

- (id)init
{
    self = [super initWithWindowNibName:@"WindowController"];
    return self;    
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSString*path = @"/Users/less/Desktop/test.lessdj/index2.html";
    NSURL* url = [NSURL fileURLWithPath:path];

    jam = [[AppleJam alloc] initWithWebView:webView
                                       path:url];
    [jam setLoadedCallback:self sel:@selector(pageLoaded:)];
    Player* player = [[Player alloc] initWithJam:jam];
    [jam addCommandInstance:player];
    [player release];
}


- (void)pageLoaded:(AppleJam*)jam
{
    NSLog(@"loaded");
    [[Player s] startTick];
}


@end
