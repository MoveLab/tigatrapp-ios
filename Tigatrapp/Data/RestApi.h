//
//  RestApi.h
//  Tigatrapp
//
//  Created by jordi on 30/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <Foundation/Foundation.h>


#define OPTION_NONE 0
#define OPTION_TIGER 11
#define OPTION_YELLOW 12
#define OPTION_TIGER_NO_TORAX 13
#define OPTION_YELLOW_NO_TORAX 14
#define OPTION_TIGER_NO_ABDOMEN 15
#define OPTION_YELLOW_NO_ABDOMEN 16
#define OPTION_NONE_OF_BOTH 13
#define OPTION_NOT_SURE 14
#define OPTION_NO 20
#define OPTION_NS 21


@interface RestApi : NSObject <NSURLSessionDelegate>

+ (RestApi *)sharedInstance;

@property (nonatomic, strong) NSMutableSet *imagesToUpload;
@property (nonatomic, strong) NSMutableSet *reportsToUpload;
@property (nonatomic, strong) NSMutableSet *imagesUploading;
@property (nonatomic, strong) NSMutableSet *reportsUploading;

@property (nonatomic,strong) NSMutableArray *notificationsArray;
@property (nonatomic,strong) NSMutableArray *ackNotificationsArray;


@property (nonatomic,strong) NSMutableArray *missionsArray;
@property (nonatomic,strong) NSMutableArray *ackMissionsArray;
@property (nonatomic,strong) NSMutableArray *deletedMissionsArray;

@property (nonatomic,strong) NSArray *serverNotificationsArray;
@property (nonatomic,strong) NSArray *serverMissionsArray;

@property (nonatomic,strong) NSString *notificationsToken;

@property (nonatomic) int userScore;
@property (nonatomic,strong) NSString *userScoreString;
@property (nonatomic, strong) NSDictionary *validationInfo;
@property (nonatomic,strong) NSData *imageData;
@property (nonatomic) int validationType;
@property (nonatomic,strong) UIViewController *validation1ViewController;
@property (nonatomic,strong) UIViewController *validation2ViewController;

@property (nonatomic) BOOL showValidation1Help;
@property (nonatomic) BOOL showValidation2Help;
@property (nonatomic) BOOL showValidation3Help;
@property (nonatomic) BOOL showValidation4Help;

@property (nonatomic) float currentValidationImageScale;
@property (nonatomic) CGPoint currentValidationImageOffset;

- (void) callUsers;

- (void)saveReportsToUpload;
- (void)saveImagesToUpload;

- (void) upload;
- (void) status;

- (void) updateMissions;
- (void) updateNotifications;

- (BOOL) existsMissionWithId:(int)mission;
- (BOOL) existsNotificationWithId:(int)notification;

- (void) acknowledgeNotification:(int)notificationId;
- (void) saveAckNotificationsToUserDefaults;

- (void) saveAckMissionsToUserDefaults;

- (void) nearbyReportsFromLat:(float)lat andLon:(float)lon andRadius:(float)radius;

- (void) sendNotificationsToken;

- (void) getMosquitoToValidate;
- (void) sendMosquitoValidation:(NSDictionary *)info;
- (NSDictionary *) validateInfoForOption:(int)option;
- (void) getUserScore;
- (void) getMosquitoImage:(NSString *)uuid;


@end
