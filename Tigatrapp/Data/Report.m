//
//  Report.m
//  Tigatrapp
//
//  Created by jordi on 23/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "Report.h"

@implementation Report

@synthesize versionUUID;
@synthesize versionNumber;
@synthesize reportId;
@synthesize serverUploadTime;
@synthesize phoneUploadTime;
@synthesize creationTime;
@synthesize versionTime;
@synthesize type;
@synthesize locationChoice;
@synthesize currentLocationLon;
@synthesize currentLocationLat;
@synthesize selectedLocationLon;
@synthesize selectedLocationLat;
@synthesize note;
@synthesize packageName;
@synthesize packageVersion;
@synthesize deviceManufacturer;
@synthesize deviceModel;
@synthesize os;
@synthesize osVersion;
@synthesize osLanguage;
@synthesize appLanguage;
@synthesize responses;
@synthesize user;

- (id) initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        // Custom initialization
        self.responses = [[NSMutableArray alloc] init];
        self.images = [[NSMutableArray alloc] init];

        if (dictionary == nil) {
            NSString *nowString;
            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
            nowString = [dateFormatter stringFromDate:now];
            dateFormatter=nil;
            
            self.user = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            self.versionUUID = [[NSUUID UUID] UUIDString];
            self.versionNumber = [NSNumber numberWithInt:1];
            self.reportId = [self defineReportId];
            self.creationTime = nowString;
            self.versionTime = nowString;
            
            self.packageName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            self.packageVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            self.deviceManufacturer = @"Apple";
            self.deviceModel = [[UIDevice currentDevice] model];
            self.os = [[UIDevice currentDevice] systemName];
            self.osVersion = [[UIDevice currentDevice] systemVersion];
            self.osLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
            self.appLanguage = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
            
        } else {
            if ([dictionary valueForKey:@"version_UUID"]) self.versionUUID = [dictionary valueForKey:@"version_UUID"];
            if ([dictionary valueForKey:@"version_number"]) self.versionNumber = [dictionary valueForKey:@"version_number"];
            if ([dictionary valueForKey:@"user"]) self.user = [dictionary valueForKey:@"user"];
            if ([dictionary valueForKey:@"report_id"]) self.reportId = [dictionary valueForKey:@"report_id"];
            if ([dictionary valueForKey:@"creation_time"]) self.creationTime = [dictionary valueForKey:@"creation_time"];
            if ([dictionary valueForKey:@"version_time"]) self.versionTime = [dictionary valueForKey:@"version_time"];
            if ([dictionary valueForKey:@"type"]) self.type = [dictionary valueForKey:@"type"];
            if ([dictionary valueForKey:@"location_choice"]) self.locationChoice = [dictionary valueForKey:@"location_choice"];
            if ([dictionary valueForKey:@"current_location_lon"]) self.currentLocationLon = [dictionary valueForKey:@"current_location_lon"];
            if ([dictionary valueForKey:@"current_location_lat"]) self.currentLocationLat = [dictionary valueForKey:@"current_location_lat"];
            if ([dictionary valueForKey:@"selected_location_lon"]) self.selectedLocationLon = [dictionary valueForKey:@"selected_location_lon"];
            if ([dictionary valueForKey:@"selected_location_lat"]) self.selectedLocationLat = [dictionary valueForKey:@"selected_location_lat"];
            if ([dictionary valueForKey:@"note"]) self.note = [dictionary valueForKey:@"note"];
            if ([dictionary valueForKey:@"package_name"]) self.packageName = [dictionary valueForKey:@"package_name"];
            if ([dictionary valueForKey:@"package_version"]) self.packageVersion = [dictionary valueForKey:@"package_version"];
            if ([dictionary valueForKey:@"device_manufacturer"]) self.deviceManufacturer = [dictionary valueForKey:@"device_manufacturer"];
            if ([dictionary valueForKey:@"device_model"]) self.deviceModel = [dictionary valueForKey:@"device_model"];
            if ([dictionary valueForKey:@"os"]) self.os = [dictionary valueForKey:@"os"];
            if ([dictionary valueForKey:@"os_version"]) self.osVersion = [dictionary valueForKey:@"os_version"];
            if ([dictionary valueForKey:@"os_language"]) self.osLanguage = [dictionary valueForKey:@"os_language"];
            if ([dictionary valueForKey:@"app_language"]) self.appLanguage = [dictionary valueForKey:@"app_language"];
            if ([dictionary valueForKey:@"responses"]) [self.responses addObjectsFromArray:[dictionary valueForKey:@"responses"]];
            if ([dictionary valueForKey:@"images"]) [self.images addObjectsFromArray:[dictionary valueForKey:@"images"]];
        }
    }
    return self;
}

- (NSString *) defineReportId {
    int nextReportId;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"reportId"]) {
        nextReportId = 1+[[[NSUserDefaults standardUserDefaults] objectForKey:@"reportId"] intValue];
    } else {
        nextReportId = 1;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:nextReportId] forKey:@"reportId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return [[[NSString stringWithFormat:@"0x%04x",nextReportId] stringByReplacingOccurrencesOfString:@"0" withString:@"z"] substringFromIndex:2];
}

- (NSMutableDictionary *) reportDictionary {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (self.versionUUID) [dictionary setObject:self.versionUUID forKey:@"version_UUID"];
    if (self.versionNumber) [dictionary setObject:self.versionNumber forKey:@"version_number"];
    if (self.user) [dictionary setObject:self.user forKey:@"user"];
    if (self.reportId) [dictionary setObject:self.reportId forKey:@"report_id"];
    if (self.creationTime) [dictionary setObject:self.creationTime forKey:@"creation_time"];
    if (self.versionTime) [dictionary setObject:self.versionTime forKey:@"version_time"];
    if (self.type) [dictionary setObject:self.type forKey:@"type"];
    if (self.locationChoice) [dictionary setObject:self.locationChoice forKey:@"location_choice"];
    if (self.currentLocationLon) [dictionary setObject:self.currentLocationLon forKey:@"current_location_lon"];
    if (self.currentLocationLat) [dictionary setObject:self.currentLocationLat forKey:@"current_location_lat"];
    if (self.selectedLocationLon) [dictionary setObject:self.selectedLocationLon forKey:@"selected_location_lon"];
    if (self.selectedLocationLat) [dictionary setObject:self.selectedLocationLat forKey:@"selected_location_lat"];
    if (self.note) [dictionary setObject:self.note forKey:@"note"];
    if (self.packageName) [dictionary setObject:self.packageName forKey:@"package_name"];
    if (self.packageVersion) [dictionary setObject:self.packageVersion forKey:@"package_version"];
    if (self.deviceManufacturer) [dictionary setObject:self.deviceManufacturer forKey:@"device_manufacturer"];
    if (self.deviceModel) [dictionary setObject:self.deviceModel forKey:@"device_model"];
    if (self.os) [dictionary setObject:self.os forKey:@"os"];
    if (self.osVersion) [dictionary setObject:self.osVersion forKey:@"os_version"];
    if (self.osLanguage) [dictionary setObject:self.osLanguage forKey:@"os_language"];
    if (self.appLanguage) [dictionary setObject:self.appLanguage forKey:@"app_language"];
    if (self.responses) [dictionary setObject:self.responses forKey:@"responses"];
    if (self.images) [dictionary setObject:self.images forKey:@"images"];
    
    return dictionary;
}

- (void) print {
    NSLog(@"===========================");
    NSLog(@"user           :%@", self.user);
    NSLog(@"versionUUID    :%@", self.versionUUID);
    NSLog(@"versionNumber  :%d", [self.versionNumber intValue]);
    NSLog(@"reportId       :%@", self.reportId);
    NSLog(@"creationTime   :%@", self.creationTime);
    NSLog(@"versionTime    :%@", self.versionTime);
    NSLog(@"packageName    :%@", self.packageName);
    NSLog(@"packageVersion :%@", self.packageVersion);
    NSLog(@"deviceModel    :%@", self.deviceModel);
    NSLog(@"os             :%@", self.os);
    NSLog(@"osVersion      :%@", self.osVersion);
    NSLog(@"osLanguage     :%@", self.osLanguage);
    NSLog(@"appLanguage    :%@", self.appLanguage);
    NSLog(@"type           :%@", self.type);
    NSLog(@"locationChoice :%@", self.locationChoice);
    NSLog(@"currentLat     :%f", [self.currentLocationLat floatValue]);
    NSLog(@"currentLon     :%f", [self.currentLocationLon floatValue]);
    NSLog(@"selectedLat    :%f", [self.selectedLocationLat floatValue]);
    NSLog(@"selectedLon    :%f", [self.selectedLocationLon floatValue]);
    NSLog(@"note           :%@", self.note);
    NSLog(@"responses      :%@", self.responses);
    NSLog(@"images         :%d", self.images.count);
    NSLog(@"===========================");
}


@end
