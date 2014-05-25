//
//  UserReports.m
//  Tigatrapp
//
//  Created by jordi on 25/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "UserReports.h"
#import "Report.h"

@implementation UserReports

static UserReports *sharedInstance = nil;

+ (UserReports *) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (NSMutableArray *)reports {
    // lazy instantiation
    if (!_reports) {
        _reports = [[NSMutableArray alloc] init];
        [self loadReports];
    }
    return _reports;
}

- (void) addReport:(Report *)report {
    
    [self.reports addObject:report];
    if (SHOW_LOGS) [report print];
    [self saveReports];
}


- (void)saveReports {
    
    NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
    
    for (Report *report in self.reports) {
        NSDictionary *dictionary = [report reportDictionary];
        [archiveArray addObject:dictionary];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:archiveArray forKey:@"UserReports"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadReports {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserReports"]) {
        NSArray *archiveArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserReports"];
        for (NSDictionary *reportDictionary in archiveArray) {
            Report *report = [[Report alloc] initWithDictionary:reportDictionary];
            [self.reports addObject:report];
        }
        
    }
}

- (Report *) reportWithId:(NSString *)reportId {
    for (Report *report in self.reports) {
        if ([report.reportId isEqualToString:reportId]) {
            return report;
        }
    }
    return nil;
}


@end
