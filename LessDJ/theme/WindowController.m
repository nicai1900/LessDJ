//
//  WindowController.m
//  LessDJ
//
//  Created by xu xhan on 2/15/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import "WindowController.h"
#import "DBList.h"
#import "LessDJAppDelegate.h"

@implementation WindowController
@synthesize webView;


- (void)songChanged:(DBItem*)item
{
    NSString* script = [NSString stringWithFormat:@"DJ.app_songchanged(new Track('%@','%@','%@'))",
     item.title, item.artist,item.album];
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
    NSString*path = @"/Users/less/Desktop/test.bun/index.html";
    NSURL* url = [NSURL fileURLWithPath:path];
    [webView setPolicyDelegate:self];
    [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
}


#define DJ_SCHEME @"lessdj"
#define DJ_action_next @"next"
#define DJ_action_toggle @"toggle_play"

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
            [[LessDJAppDelegate s] playNext:nil];
        }
        [listener ignore];
    }else{
        [listener use];
    }
    
}
@end
