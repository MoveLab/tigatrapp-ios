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

- (id) init {
    
    self = [super init];
    if (self) {
        // Custom initialization
        NSLog(@"initi ");
        self.responses = [[NSMutableArray alloc] init];
        self.images = [[NSMutableArray alloc] init];
        self.user = @"Flopper";
    }
    return self;

}



@end
