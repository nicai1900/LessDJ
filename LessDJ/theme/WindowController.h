//
//  WindowController.h
//  LessDJ
//
//  Created by xu xhan on 2/15/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class DBItem;
@interface WindowController : NSWindowController {
    WebView *webView;
}

@property (assign) IBOutlet WebView *webView;

- (void)songChanged:(DBItem*)item;

@end
