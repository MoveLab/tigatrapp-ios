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
@property (nonatomic, strong) NSMutableSet *imagesUploading;
@property (nonatomic, strong) NSMutableSet *reportsUploading;

-(id) init;

- (void) callUsers;

- (void)saveReportsToUpload;
- (void)saveImagesToUpload;

- (void) upload;
- (void) status;
@end
