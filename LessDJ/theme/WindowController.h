//
//  WindowController.h
//  LessDJ
//
//  Created by xu xhan on 2/15/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class DBItem, AppleJam, ThemeInfo;
@interface WindowController : NSWindowController {
    WebView *webView;
    AppleJam*jam;
    ThemeInfo* info;
}

@property (assign) IBOutlet WebView *webView;
@property(retain,nonatomic) ThemeInfo* info;
- (id)initWithTheme:(NSString*)path;

- (NSWindow*)bordlessWindow:(CGSize)size;
@end
