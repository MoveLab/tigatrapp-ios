//
//  UserReports.m
//  Tigatrapp
//
//  Created by jordi on 25/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "UserReports.h"
#import "Report.h"
#import "RestApi.h"
#import "FormatDate.h"

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

    for (NSData *image in report.images) {
        NSDictionary *imageDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:image,@"photo", report.versionUUID, @"report", nil];
        [[[RestApi sharedInstance] imagesToUpload] addObject:imageDictionary];
    }

    NSMutableDictionary *reportDictionary = [report dictionaryIncludingImages:NO];
    [reportDictionary setObject:[FormatDate nowToString] forKey:@"phone_upload_time"];
    [[[RestApi sharedInstance] reportsToUpload] addObject:reportDictionary];

    [[RestApi sharedInstance] upload];
}

- (void) deleteReport:(Report *)report {
    if (SHOW_LOGS) NSLog(@"delete report");
    if (SHOW_LOGS) [report print];
    
    NSMutableDictionary *reportDictionary = [report dictionaryIncludingImages:NO];
    [reportDictionary setObject:[FormatDate nowToString] forKey:@"phone_upload_time"];
    [reportDictionary setObject:@-1 forKey:@"version_number"];
    [[[RestApi sharedInstance] reportsToUpload] addObject:reportDictionary];
    
    [self.reports removeObject:report];
    [self saveReports];
}

- (void)saveReports {
    
    NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
    
    for (Report *report in self.reports) {
        NSDictionary *dictionary = [report dictionaryIncludingImages:YES];
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
