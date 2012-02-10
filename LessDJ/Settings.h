//
//  Settings.h
//  LessDJ
//
//  Created by xu xhan on 2/10/12.
//  Copyright (c) 2012 xu han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSettings.h"

@interface Settings : PLSettings
{
    
}

+ (Settings*)singleton;
@end

extern Settings* AppSetting();