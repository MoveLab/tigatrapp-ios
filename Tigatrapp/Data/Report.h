//
//  Report.h
//  Tigatrapp
//
//  Created by jordi on 23/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Report : NSObject

@property (nonatomic, strong) NSString *versionUUID;
@property (nonatomic, strong) NSNumber *versionNumber;
@property (nonatomic, strong) NSString *reportId;
@property (nonatomic, strong) NSString *serverUploadTime;
@property (nonatomic, strong) NSString *phoneUploadTime;
@property (nonatomic, strong) NSString *creationTime;
@property (nonatomic, strong) NSString *versionTime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *locationChoice;
@property (nonatomic, strong) NSNumber *currentLocationLon;
@property (nonatomic, strong) NSNumber *currentLocationLat;
@property (nonatomic, strong) NSNumber *selectedLocationLon;
@property (nonatomic, strong) NSNumber *selectedLocationLat;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *packageName;
@property (nonatomic, strong) NSString *packageVersion;
@property (nonatomic, strong) NSString *deviceManufacturer;
@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *osLanguage;
@property (nonatomic, strong) NSString *appLanguage;
@property (nonatomic, strong) NSMutableArray *responses;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSNumber *answer1;
@property (nonatomic, strong) NSNumber *answer2;
@property (nonatomic, strong) NSNumber *answer3;


- (id) initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *) dictionaryIncludingImages:(BOOL)imagesIncluded;
- (NSString *)niceCreationTime;
- (void) print;

@end
