//
//  ThemeInfo.m
//  LessDJ
//
//  Created by xu xhan on 2/20/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import "ThemeInfo.h"

@implementation ThemeInfo

//@synthesize author, info, name , version ,identify ,authorURL ,themePath ,windowSize ,windowSizeMax, windowHasBorder , windowHasShadow;

#define _Info(key) PLHashV(dict,key)

+ (ThemeInfo*)loadThemeInfo:(NSString*)path
{
    //TODO error check
    NSString*errorMsg = nil;
    
    NSString*plistPath = [path stringByAppendingPathComponent:@"Info.plist"];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    if (!dict) {
        errorMsg = @"can't open info.plist file inside package";        
        return nil;
    }
    

    ThemeInfo*info = [[[ThemeInfo alloc] initWithDict:dict] autorelease];
    info.themePath = path;
    errorMsg = [info infoValid];
    if (errorMsg) {
        return nil;
    }
    return info;
}

- (ThemeInfo*)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    self.identify = _Info(@"DJIdentifier");
    self.author   = _Info(@"DJAuthor");
    self.authorURL= _Info(@"DJAuthorURL");
    self.name     = _Info(@"DJThemeName");
    self.version  = _Info(@"DJThemeVersion");
    self.info     = _Info(@"DJThemeInfo");
    self.windowHasBorder = [_Info(@"DJWindowHasBorder") boolValue];
    self.windowHasShadow = [_Info(@"DJWindowHasShadow") boolValue];
    self.windowSize = CGSizeMake([_Info(@"DJWindowWidth") intValue],
                            [_Info(@"DJWindowHeight") intValue]);
    
    self.windowSizeMax = CGSizeMake([_Info(@"DJWindowWidthMax") intValue],
                               [_Info(@"DJWindowHeightMax") intValue]);    
    return self;
}

- (NSString*)infoValid
{
    NSString* errorMsg;
    if (![self.identify isNonEmpty]) {
        errorMsg = @"identify";
    }
//    TODO: parse more
    return errorMsg;
}


- (void)dealloc
{
    /* TODO:release these
     NSString *identify;
     NSString *author,*authorURL;
     NSString *name, *version, *info;
     BOOL windowHasBorder, windowHasShadow;  //DragToMove = YES if no Border
     CGSize windowSize, windowSizeMax;
     
     NSString* themePath;
     */
    [super dealloc];
}

@end
