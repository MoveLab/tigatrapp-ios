//
//  RestApi.h
//  Tigatrapp
//
//  Created by jordi on 30/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <Foundation/Foundation.h>

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




@end
