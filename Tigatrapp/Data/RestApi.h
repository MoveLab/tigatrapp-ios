//
//  RestApi.h
//  Tigatrapp
//
//  Created by jordi on 30/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestApi : NSObject <NSURLSessionDelegate>

+ (RestApi *)sharedInstance;

@property (nonatomic, strong) NSMutableSet *imagesToUpload;
@property (nonatomic, strong) NSMutableSet *reportsToUpload;

- (void) callUsers;
- (void) callReports;

- (void)saveReportsToUpload;
- (void)saveImagesToUpload;

@end
