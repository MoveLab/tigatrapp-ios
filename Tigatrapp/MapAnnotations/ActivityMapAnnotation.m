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



- (id)initWithReport:(Report *)report {
    if ((self = [super init])) {
        if ([report.type isEqualToString:@"adult"]) {
            self.title = [LocalText with:@"view_report_title_adult"];
        } else if ([report.type isEqualToString:@"site"]) {
            self.title = [LocalText with:@"view_report_title_site"];
        }
        self.subtitle = report.niceCreationTime;
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
