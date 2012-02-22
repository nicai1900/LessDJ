//
//  ThemeInfo.h
//  LessDJ
//
//  Created by xu xhan on 2/20/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeInfo : NSObject

{
    NSString *identify;
    NSString *author,*authorURL;
    NSString *name, *version, *info;
    BOOL windowHasBorder, windowHasShadow;  //DragToMove = YES if no Border
    CGSize windowSize, windowSizeMax;
    
    NSString* themePath;
}
@property(copy,nonatomic)  NSString* themePath;

@property(copy,nonatomic)  NSString *identify;
@property(copy,nonatomic)  NSString *author;
@property(copy,nonatomic)  NSString *authorURL;
@property(copy,nonatomic)  NSString *name;
@property(copy,nonatomic)  NSString *version;
@property(copy,nonatomic)  NSString *info;

@property(assign,nonatomic)  CGSize windowSize;
@property(assign,nonatomic)  CGSize windowSizeMax;
@property(assign,nonatomic) BOOL windowHasBorder;
@property(assign,nonatomic) BOOL windowHasShadow;


+ (ThemeInfo*)loadThemeInfo:(NSString*)path;
- (ThemeInfo*)initWithDict:(NSDictionary*)dict;
- (NSString*)infoValid; //return nil if valid
@end
