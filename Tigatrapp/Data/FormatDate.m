//
//  FormatDate.m
//  Tigatrapp
//
//  Created by jordi on 30/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "FormatDate.h"

@implementation FormatDate

+ (NSString *) nowToString {
    NSString *nowString;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    nowString = [dateFormatter stringFromDate:now];
    dateFormatter=nil;
    return nowString;
}

@end
