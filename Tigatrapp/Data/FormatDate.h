//
//  FormatDate.h
//  Tigatrapp
//
//  Created by jordi on 30/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatDate : NSObject

+ (NSString *) nowToString;
+ (NSString *) dateToString:(NSDate *)date;
+ (NSString *) rssStringToString:(NSString *)dateRSS;


@end
