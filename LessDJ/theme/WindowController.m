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

#import "ThemeInfo.h"

@interface PView : NSView
@end
@implementation PView
- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor clearColor] set];
    //    [[NSColor redColor] set];
    NSRectFill([self bounds]);
}

@end



@implementation WindowController
@synthesize webView, info;


- (NSWindow*)bordlessWindow:(CGSize)size
{
    NSWindow* window = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, size.width, size.height) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [window setOpaque:NO];
    [window setMovableByWindowBackground:YES];
    [window setAlphaValue:1];
//    [window setLevel:NSStatusWindowLevel];
    [window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    [window setReleasedWhenClosed:NO];  //cause we retained _view
    [window center];
//    if(![window setFrameUsingName:@"SingleLineWindowFrame"])
//        [window setFrameOrigin:CGPointMake(window.frame.origin.x, 200)]; 
//    [window setFrameAutosaveName:@"SingleLineWindowFrame"];
    return [window autorelease];
}

- (id)initWithTheme:(NSString*)path
{
    ThemeInfo* _info = [ThemeInfo loadThemeInfo:path];
    if (!_info) return nil;
    CGSize size = _info.windowSize;
    if (_info.windowHasBorder) {
        self = [self init];
        self.info = _info;
        [self.window setContentSize:size];        
    }else {
        self = [super init];
        self.info = _info;
        self.window = [self bordlessWindow:size];        
//        
        PView* v = [[PView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self.window setContentView:v];        
        
        webView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        webView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
//        [self.window setContentView:webView];        
        [v addSubview:webView];
        [self windowDidLoad];
    }
    
    return self;
}

//- (void)loadWindow
//{
//    if (!self.info.windowHasBorder) {
//        CGSize size = self.info.windowSize;
//        self.window = [self bordlessWindow:size];        
//        PView* v = [[PView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//        [self.window setContentView:v];        
//    }
//}

- (id)init
{
    self = [super initWithWindowNibName:@"WindowController"];
    return self;    
}

//- (id)initWithWindow:(NSWindow *)window
//{
//    self = [super initWithWindow:window];
//    if (self) {
//        // Initialization code here.
//    }
//    
//    return self;
//}p

- (void)windowDidLoad
{    
    [super windowDidLoad];
    [self.window center];
    [self.window setHasShadow:info.windowHasShadow];
//    NSString*path = @"/Users/less/Desktop/test.lessdj/index.html";
    
    NSString*path = [info.themePath stringByAppendingPathComponent:@"index.html"];
    
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
