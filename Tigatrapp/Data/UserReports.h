//
//  UserReports.h
//  Tigatrapp
//
//  Created by jordi on 25/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Report;

@interface UserReports : NSObject

@property (nonatomic, strong) NSMutableArray *reports;

+ (UserReports *)sharedInstance;

- (void) addReport:(Report *)report;

- (Report *) reportWithId:(NSString *)reportId;

@end
