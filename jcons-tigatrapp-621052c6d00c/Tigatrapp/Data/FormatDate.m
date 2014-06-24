//
//  FormatDate.m
//  Tigatrapp
//
//  Created by jordi on 30/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
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

+ (NSString *) dateToString:(NSDate *)date {
    NSString *nowString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    nowString = [dateFormatter stringFromDate:date];
    dateFormatter=nil;
    return nowString;
}

+ (NSString *) rssStringToString:(NSString *)dateRSS {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
    NSDate *theDate = [dateFormatter dateFromString:dateRSS];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    return [dateFormatter stringFromDate:theDate];
}

@end
