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
@implementation WindowController
@synthesize webView;


- (void)songChanged:(DBItem*)item
{
//    NSString* script = [NSString stringWithFormat:@"DJ.app_songchanged(new Track('%@','%@','%@'))",
//     item.title, item.artist,item.album];
    NSString* json = [item.dict JSONRepresentation];
    NSString* script = [NSString stringWithFormat:@"app_song_changed(%@)",json];
    [webView stringByEvaluatingJavaScriptFromString:script];
}

- (void)play:(BOOL)isplay
{
    NSString* script =[NSString stringWithFormat:@"app_player_state_change(%d,1)",isplay];
    [webView stringByEvaluatingJavaScriptFromString:script];
}

- (void)loading:(BOOL)isload
{
    
}

- (void)ontick
{
    float location = [AppDelegate s].songLocation;
    NSString* script =[NSString stringWithFormat:@"app_player_location_changed(%f)",location];
    [webView stringByEvaluatingJavaScriptFromString:script];
}


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
    NSString*path = @"/Users/less/Desktop/test.bun/index2.html";
    NSURL* url = [NSURL fileURLWithPath:path];
    [webView setPolicyDelegate:self];
    [webView setFrameLoadDelegate:self];
    [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
}


#define DJ_SCHEME @"ajam"
#define DJ_action_next @"Player.nextTrack"
#define DJ_action_toggle @"Player.togglePlay"

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
          frame:(WebFrame *)frame
decisionListener:(id<WebPolicyDecisionListener>)listener
{
    //TODO: need a routes to map action to selectors
    NSURL* url = [actionInformation objectForKey:WebActionOriginalURLKey];
    NSString* scheme = [url scheme];
    NSString* action = [url resourceSpecifier];
    if ([DJ_SCHEME isEqualToString:scheme]) {
        if ([action isEqualToString:DJ_action_next]) {
            [[AppDelegate s] playNext:nil];
        }else if ([action isEqualToString:DJ_action_toggle] ){
            [[AppDelegate s] onTogglePlay:nil];
        }
        [listener ignore];
    }else{
        [listener use];
    }
    
}


- (void)webView:(WebView *)awebView didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame
{
    NSLog(@"clean");
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"AppleJam.js" withExtension:nil];
    NSString* str = [NSString stringWithFormat:@"document.write(\"<script src='%@' type='text/javascript'></script>\")",[url absoluteString]];
    NSLog(@"%@",str);
//    [webView stringByEvaluatingJavaScriptFromString:str];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    NSLog(@"loaded");
//    [webView stringByEvaluatingJavaScriptFromString:@"Jam.markAsLoaded();"];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(ontick) userInfo:nil
                                    repeats:YES];
}
@end
