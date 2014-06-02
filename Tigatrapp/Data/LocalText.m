//
//  LocalText.m
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "LocalText.h"

@implementation LocalText

+(NSString *) with:(NSString *)string {
    return NSLocalizedString(string,nil);
}

@end
