//
//  UserReports.h
//  Tigatrapp
//
//  Created by jordi on 25/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//
// user reports es la base de dades


#import <Foundation/Foundation.h>
@class Report;

@interface UserReports : NSObject

@property (nonatomic, strong) NSMutableArray *reports;

+ (UserReports *)sharedInstance;

- (void) addReport:(Report *)report;
- (void) deleteReport:(Report *)report;
- (void) saveReports;
- (Report *) reportWithId:(NSString *)reportId;

@end
