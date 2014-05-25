//
//  ActivityMapAnnotation.m
//  Tigatrapp
//
//  Created by jordi on 22/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "ActivityMapAnnotation.h"
#import "Report.h"

@implementation ActivityMapAnnotation

- (NSString *) niceDate:(NSString *)dateString {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"HH:mm dd/MM/yyyy"];
    return [dateFormat stringFromDate:date];
}

- (id)initWithReport:(Report *)report {
    if ((self = [super init])) {
        if ([report.type isEqualToString:@"adult"]) {
            self.title = @"Troballa de mosquit tigre";
        } else if ([report.type isEqualToString:@"site"]) {
            self.title = @"Troballa de lloc";
        }
        self.subtitle = [self niceDate:report.creationTime];
        self.type = report.type;
        self.reportId = report.reportId;
        if ([report.locationChoice isEqualToString:@"current"]) {
            self.coordinate = CLLocationCoordinate2DMake([report.currentLocationLat floatValue]
                                                         ,[report.currentLocationLon floatValue]);
        } else {
            self.coordinate = CLLocationCoordinate2DMake([report.selectedLocationLat floatValue]
                                                         ,[report.selectedLocationLon floatValue]);
        }
    }
    return self;
}


- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}


@end
