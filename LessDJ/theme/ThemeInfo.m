//
//  ThemeInfo.m
//  LessDJ
//
//  Created by xu xhan on 2/20/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import "ThemeInfo.h"

@implementation ThemeInfo

@synthesize author, info, name , version ,identify ,authorURL ,themePath ,windowSize ,windowSizeMax, windowHasBorder , windowHasShadow;

#define _Info(key) PLHashV(dict,key)

+ (ThemeInfo*)loadThemeInfo:(NSString*)path
{
    //TODO error check
    NSString*errorMsg = nil;
    
    NSString*plistPath = [path stringByAppendingPathComponent:@"Info.plist"];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    if (!dict) {
        errorMsg = @"can't open info.plist file inside package";        
    }
    

    ThemeInfo*info = [[[ThemeInfo alloc] initWithDict:dict] autorelease];
    info.themePath = path;
    errorMsg = [info infoValid];
    if (errorMsg) {
        //TODO: error msg handle
        NSAlert* alert = [NSAlert alertWithError:[NSError errorWithDomain:@"LessDJ.Theme.error"
                                                                     code:0 
                                                                 userInfo:@{ NSLocalizedDescriptionKey : errorMsg }]];
        [alert runModal];
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
    NSString* errorMsg = nil;
    if (![self.identify isNonEmpty]) {
        errorMsg = @"identify";
    }

    if (self.windowSize.height <= 0 || self.windowSize.width <= 0 ) {
        errorMsg = @"window size error";
    }
    return errorMsg;
}


- (void)dealloc
{
    PLSafeRelease(identify);
    PLSafeRelease(author);
    PLSafeRelease(authorURL);
    PLSafeRelease(name);
    PLSafeRelease(version);
    PLSafeRelease(info);
    PLSafeRelease(themePath);
    [super dealloc];
}

@end
