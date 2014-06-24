//
//  Report.m
//  Tigatrapp
//
//  Created by jordi on 23/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "Report.h"
#import "FormatDate.h"

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
@synthesize answer1;
@synthesize answer2;
@synthesize answer3;

- (id) initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        // Custom initialization
        self.responses = [[NSMutableArray alloc] init];
        self.images = [[NSMutableArray alloc] init];

        if (dictionary == nil) {
            NSString *nowString = [FormatDate nowToString];
            
            self.user = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            self.versionUUID = [[NSUUID UUID] UUIDString];
            self.versionNumber = [NSNumber numberWithInt:1];
            self.reportId = [self defineReportId];
            self.creationTime = nowString;
            self.versionTime = nowString;
            self.packageName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            //self.packageVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            self.packageVersion = [NSString stringWithFormat:@"%d",PACKAGE_VERSION];
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
            if ([dictionary valueForKey:@"phone_upload_time"]) self.phoneUploadTime = [dictionary valueForKey:@"phone_upload_time"];
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
            if ([dictionary valueForKey:@"answer1"]) self.answer1 = [dictionary valueForKey:@"answer1"];
            if ([dictionary valueForKey:@"answer2"]) self.answer2 = [dictionary valueForKey:@"answer2"];
            if ([dictionary valueForKey:@"answer3"]) self.answer3 = [dictionary valueForKey:@"answer3"];
        }
    }
    return self;
}

- (NSString *) niceCreationTime {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    NSDate *date = [dateFormat dateFromString:self.creationTime];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"HH:mm dd/MM/yyyy"];
    return [dateFormat stringFromDate:date];
}

- (NSMutableDictionary *) dictionaryIncludingImages:(BOOL)imagesIncluded {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (self.versionUUID) [dictionary setObject:self.versionUUID forKey:@"version_UUID"];
    if (self.versionNumber) [dictionary setObject:self.versionNumber forKey:@"version_number"];
    if (self.user) [dictionary setObject:self.user forKey:@"user"];
    if (self.reportId) [dictionary setObject:self.reportId forKey:@"report_id"];
    if (self.creationTime) [dictionary setObject:self.creationTime forKey:@"creation_time"];
    if (self.versionTime) [dictionary setObject:self.versionTime forKey:@"version_time"];
    if (self.phoneUploadTime) [dictionary setObject:self.phoneUploadTime forKey:@"phone_upload_time"];
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
    
    if (imagesIncluded) {
        if (self.images) [dictionary setObject:self.images forKey:@"images"];
        if (self.answer1) [dictionary setObject:self.answer1 forKey:@"answer1"];
        if (self.answer2) [dictionary setObject:self.answer2 forKey:@"answer2"];
        if (self.answer3) [dictionary setObject:self.answer3 forKey:@"answer3"];
    }
    
    return dictionary;
}

- (NSString *) defineReportId {

    
    // I am removing potentially confusing characters 0, o, and O
    NSArray *digits = @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"A",
        @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",
        @"N", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",
        @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l",
        @"m", @"n", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"];
    
    /*
     * I am giving the report IDs 4 digits using the set of 62 alphanumeric
     * characters taking (capitalization into account). If we would receive
     * 1000 reports, the probability of at least two ending up with the same
     * random ID is about .03 (based on the Taylor approximation solution to
     * the birthday paradox: 1- exp((-(1000^2))/((62^4)*2))). For 100
     * reports, the probability is about .0003. Since each report is also
     * linked to a unique userID, and since the only consequence of a double
     * ID would be to make it harder for us to link a mailed sample to a
     * report -- assuming the report with the double ID included a mailed
     * sample -- this seems like a reasonable risk to take. We could reduce
     * the probability by adding digits, but then it would be harder for
     * users to record their report IDs.
     *
     * UPDATE: I now removed 0 and o and O to avoid confusion, so the
     * probabilities would need to be recaclulated...
     */
    
    return ([NSString stringWithFormat:@"%@%@%@%@"
             ,[digits objectAtIndex:(arc4random() % 58)]
             ,[digits objectAtIndex:(arc4random() % 58)]
             ,[digits objectAtIndex:(arc4random() % 58)]
             ,[digits objectAtIndex:(arc4random() % 58)]
             ]);
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
    NSLog(@"images         :%lu", self.images.count);
    NSLog(@"===========================");
 
}


@end
