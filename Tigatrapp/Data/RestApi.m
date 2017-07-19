//
//  RestApi.m
//  Tigatrapp
//
//  Created by jordi on 30/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "RestApi.h"
#import "Report.h"
#import "UserReports.h"

@implementation RestApi
static RestApi *sharedInstance = nil;

+ (RestApi *) sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id) init {
    self = [super init];
    if (self) {
        self.imagesUploading = [[NSMutableSet alloc] init];
        self.imagesToUpload = [[NSMutableSet alloc] init];
        self.reportsUploading = [[NSMutableSet alloc] init];
        self.reportsToUpload = [[NSMutableSet alloc] init];
        self.missionsArray = [[NSMutableArray alloc] init];
        self.ackMissionsArray = [[NSMutableArray alloc] init];
        self.deletedMissionsArray = [[NSMutableArray alloc] init];
        self.notificationsArray = [[NSMutableArray alloc] init];
        self.ackNotificationsArray = [[NSMutableArray alloc] init];

        self.serverNotificationsArray = [[NSArray alloc] init];
        self.serverMissionsArray = [[NSArray alloc] init];
        self.userScoreString = @"user_score_beginner";
        self.userScore = 0;
        
        [self restoreFromUserDefaults];
        [self loadReportsToUpload];
        [self loadImagesToUpload];
        
        self.currentValidationImageScale = 1.0;
        
    }
    return self;
}


- (void) callApiWithName:(NSString *)name andParameters:(NSDictionary *)parameters {
    
    NSString *queryEsc = [NSString stringWithFormat:@"%@%@/?format=json",C_API,name];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    if (error)  NSLog(@"Error preparant post report %@",[error localizedDescription]);
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {

        if (error)  NSLog(@"Error post report %@",[error localizedDescription]);

        NSError *herror;
        NSDictionary *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error return post report %@",[error localizedDescription]);
            [_reportsToUpload addObject:parameters];
            [_reportsUploading removeObject:parameters];

        } else {
            [_reportsUploading removeObject:parameters];

            if (SHOW_LOGS) NSLog(@"Report pujat: %@",responseDict);
        }
        [self saveReportsToUpload];

        
    }];
    
    [postDataTask resume];
}

- (void) callPhotosApiWithParameters:(NSDictionary *)parameters {

    
    NSString *queryEsc = [NSString stringWithFormat:@"%@photos/?format=json",C_API];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"478374n---------43-4333-3-43-128498493";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add report
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"report"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:@"report"]] dataUsingEncoding:NSUTF8StringEncoding]];

    // add image data
    //NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    NSData *imageData = [parameters objectForKey:@"photo"];
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"photo"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString* returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        if ([returnString isEqualToString:@"\"uploaded\""]) {
            if (SHOW_LOGS) NSLog(@"image Uploaded");
            [_imagesUploading removeObject:parameters];
        } else {
            if (SHOW_LOGS) NSLog(@"couldn't load image. Error %@ ",returnString);
            [_imagesToUpload addObject:parameters];
            [_imagesUploading removeObject:parameters];
        }
        [self saveImagesToUpload];
    }];
    
    [postDataTask resume];
}


- (void) callUsers {
    
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:udid,@"user_UUID",nil];
    NSString *queryEsc = [NSString stringWithFormat:@"%@users/?format=json",C_API];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSDictionary *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error users %@",[error localizedDescription]);
        } else {
            if (SHOW_LOGS) NSLog(@"user ok %@",responseDict);
        }
        
        
    }];
    
    [postDataTask resume];

}

- (void) callReports {
    if ([_reportsUploading count]==0) {
        [_reportsUploading addObjectsFromArray:[_reportsToUpload allObjects]];
        [_reportsToUpload removeAllObjects];
        for (NSDictionary *reportDictionary in _reportsUploading) {
            [self callApiWithName:@"reports" andParameters:reportDictionary];
        }
    }
}

- (void) callImages {
    if ([_imagesUploading count] == 0) {
        [_imagesUploading addObjectsFromArray:[_imagesToUpload allObjects]];
        [_imagesToUpload removeAllObjects];
        for (NSDictionary *imageDictionary in _imagesUploading) {
            [self callPhotosApiWithParameters:imageDictionary];
        }
    }
}


- (void) status {
    
    if (SHOW_LOGS) {
        for (NSDictionary *imageDictionary in _imagesToUpload) {
            NSLog(@"image to upload from report %@",[imageDictionary valueForKey:@"report"]);
        }
        for (NSDictionary *imageDictionary in _imagesUploading) {
            NSLog(@"image uploading from report %@",[imageDictionary valueForKey:@"report"]);
        }
        for (NSDictionary *imageDictionary in _reportsToUpload) {
            NSLog(@"report to upload %@ version %d",[imageDictionary valueForKey:@"report_id"]
                  , [[imageDictionary valueForKey:@"version_number"] intValue]);
        }
        for (NSDictionary *imageDictionary in _reportsUploading) {
            NSLog(@"report uploading %@ version %d",[imageDictionary valueForKey:@"report_id"]
                  , [[imageDictionary valueForKey:@"version_number"] intValue]);
        }
    }
}


#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    if (SHOW_LOGS) NSLog(@"URLSession:(NSURLSession *)session didBecomeInvalidWithError %@",[error localizedDescription]);
}


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    if (SHOW_LOGS) NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
}

- (void) upload {
    [self callReports];
    [self callImages];
}

- (void)saveReportsToUpload {
    
    NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *reportDictionary in self.reportsToUpload) {
        [archiveArray addObject:reportDictionary];
    }
    for (NSDictionary *reportDictionary in self.reportsUploading) {
        [archiveArray addObject:reportDictionary];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:archiveArray forKey:@"ReportsToUpload"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveImagesToUpload {
    
    NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *reportDictionary in self.imagesToUpload) {
        [archiveArray addObject:reportDictionary];
    }
    for (NSDictionary *reportDictionary in self.imagesUploading) {
        [archiveArray addObject:reportDictionary];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:archiveArray forKey:@"ImagesToUpload"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)loadReportsToUpload {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ReportsToUpload"]) {
        
        NSArray *archiveArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReportsToUpload"];
        for (NSDictionary *reportDictionary in archiveArray) {
            [_reportsToUpload addObject:reportDictionary];
        }
    }
}

- (void)loadImagesToUpload {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ImagesToUpload"]) {
        
        NSArray *archiveArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ImagesToUpload"];
        for (NSDictionary *reportDictionary in archiveArray) {
            [_imagesToUpload addObject:reportDictionary];
        }
    }
}

- (void) updateMissions {
    
    NSString *queryEsc = [NSString stringWithFormat:@"%@missions/?format=json&platform=ios",C_API];
    if (SHOW_LOGS) NSLog(@"get %@", queryEsc);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSArray *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error post report %@",[error localizedDescription]);
            
        } else {
            self.serverMissionsArray = responseDict;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"missionsUpdated"
                                                                object:self
                                                              userInfo:nil];
            
            if (SHOW_LOGS) NSLog(@"Missions recuperades: %@",responseDict);
        }
        
    }];
    
    [postDataTask resume];
    
}

- (void) updateNotifications {
    
    
    // estrategia per evitar mutants
    // quan es llegeixen notificacions es guarden en una llista de notificacions pendents de processar
    // a l'entrar a la vista menu, processo les pendents i les poso a la taula rebudes
    // d'aquesta manera, l'actualització no pot produir-se dins de l'array
    

    
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *queryEsc = [NSString stringWithFormat:@"%@user_notifications/?user_id=%@",C_API,udid];
 
    //NSString *queryEsc = [NSString stringWithFormat:@"%@user_notifications/",C_API];
    if (SHOW_LOGS) NSLog(@"get %@", queryEsc);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSArray *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        //NSLog(@"response=>%@", responseDict);
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error post report %@",[error localizedDescription]);
            
        } else {
            // cal fer un tractament per eliminar els <null> en els json
            NSArray *newResponse = [[NSMutableArray alloc] init];
            for (NSDictionary *d in responseDict) {
                NSMutableDictionary *newD = [[NSMutableDictionary alloc] initWithDictionary:d];
                for (NSString* key in newD.allKeys) {
                    if ([newD objectForKey:key] == [NSNull null]) {
                        [newD setValue:@"" forKey:key];
                    }
                }
            }
            
            //_serverNotificationsArray = responseDict;
            _serverNotificationsArray = newResponse;
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationsUpdated"
                                                                object:self
                                                              userInfo:nil];
            if (SHOW_LOGS) NSLog(@"Notificacions recuperades: %d",(int) responseDict.count);
        }
        
    }];
    
    [postDataTask resume];
    
}

- (void) acknowledgeNotification:(int)notificationId {
    
    NSString *queryEsc = [NSString stringWithFormat:@"%@user_notifications/?id=%d&acknowledged=True",C_API,notificationId];
    if (SHOW_LOGS) NSLog(@"POST %@", queryEsc);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSArray *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error post ack %@",[error localizedDescription]);
            
        } else {
            
            
            if (SHOW_LOGS) NSLog(@"Restultat Notificacion ack: %@",responseDict);
        }
        
    }];
    
    [postDataTask resume];
    
}

- (void) restoreFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *nArray = [userDefaults objectForKey:@"ackNotificationsArray"];
    [self.ackNotificationsArray addObjectsFromArray:nArray];
    NSArray *mArray = [userDefaults objectForKey:@"ackMissionsArray"];
    [self.ackMissionsArray addObjectsFromArray:mArray];
    NSArray *dmArray = [userDefaults objectForKey:@"deletedMissionsArray"];
    [self.deletedMissionsArray addObjectsFromArray:dmArray];
    if ([userDefaults objectForKey:@"userScore"]) {
        _userScore = [[userDefaults objectForKey:@"userScore"] intValue];
        _userScoreString = [userDefaults objectForKey:@"userScoreString"];
    }
    if (SHOW_LOGS) {
        NSLog(@"RECUPERAT DE USER DEFAULTS: ");
        NSLog(@"- ackNotifications: %d ",  (int)_ackNotificationsArray.count);
        NSLog(@"- ackMissions: %d ", (int)_ackMissionsArray.count);
        NSLog(@"- deletedMissions: %d ", (int)_deletedMissionsArray.count);
        NSLog(@"- userScore: %d ", _userScore);
        NSLog(@"- userScoreString: %@ ", _userScoreString);
    }
    
    _showValidation1Help = ([userDefaults objectForKey:@"showValidation1Help"] == nil);
    _showValidation2Help = ([userDefaults objectForKey:@"showValidation2Help"] == nil);
    _showValidation3Help = ([userDefaults objectForKey:@"showValidation3Help"] == nil);
    _showValidation4Help = ([userDefaults objectForKey:@"showValidation4Help"] == nil);
}

- (void) saveAckNotificationsToUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.ackNotificationsArray forKey:@"ackNotificationsArray"];
    [userDefaults synchronize];
    if (SHOW_LOGS) {
        NSLog(@"GRAVAT A USER DEFAULTS: ");
        NSLog(@"- ackNotifications: %d ", (int)_ackNotificationsArray.count);
    }
}

- (void) saveAckMissionsToUserDefaults {
    if (SHOW_LOGS) {
        NSLog(@"GRAVAT A USER DEFAULTS: ");
        NSLog(@"- ackMissions: %d ", (int)_ackMissionsArray.count);
        NSLog(@"- deletedMissions: %d ", (int)_deletedMissionsArray.count);
        
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *d in _ackMissionsArray) {
        NSDictionary *dd = @{@"id":d[@"id"]
                             ,@"short_description_english":d[@"short_description_english"]
                             ,@"short_description_catalan":d[@"short_description_catalan"]
                             ,@"short_description_spanish":d[@"short_description_spanish"]
                                                            };
        [temp addObject:dd];
    }

    NSMutableArray *tempDeleted = [[NSMutableArray alloc] init];
    for (NSDictionary *d in _deletedMissionsArray) {
        NSDictionary *dd = @{@"id":d[@"id"]
                             ,@"short_description_english":d[@"short_description_english"]
                             ,@"short_description_catalan":d[@"short_description_catalan"]
                             ,@"short_description_spanish":d[@"short_description_spanish"]
                             };
        [tempDeleted addObject:dd];
    }

    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:temp forKey:@"ackMissionsArray"];
    [userDefaults setObject:tempDeleted forKey:@"deletedMissionsArray"];
    //[userDefaults setObject:self.deletedMissionsArray forKey:@"deletedMissionsArray"];
    [userDefaults synchronize];

}

- (void) saveUserScoreToUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:_userScore] forKey:@"userScore"];
    [userDefaults setObject:_userScoreString forKey:@"userScoreString"];
    [userDefaults synchronize];
    if (SHOW_LOGS) {
        NSLog(@"GRAVAT A USER DEFAULTS: ");
        NSLog(@"- userScore: %d ", _userScore);
        NSLog(@"- userScoreString: %@ ", _userScoreString);
    }
}



- (BOOL) existsMissionWithId:(int)mission {
    for (NSDictionary *m in self.ackMissionsArray) {
        if ([m[@"id"] intValue] == mission) {
            return YES;
        }
    }
    for (NSDictionary *m in self.deletedMissionsArray) {
        if ([m[@"id"] intValue] == mission) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) existsNotificationWithId:(int)notification {
    for (NSDictionary *m in self.ackNotificationsArray) {
        if ([m[@"id"] intValue] == notification) {
            return YES;
        }
    }
    return NO;
}


- (void) nearbyReportsFromLat:(float)lat andLon:(float)lon andRadius:(float)radius {
    
    // /api/nearby_reports/?format=json&lat=[y]&lon=[x]&radius=[z]
    
    NSString *queryEsc = [NSString stringWithFormat:@"%@nearby_reports/?format=json&lat=%f&lon=%f&radius=%f",C_API,lat,lon,radius];

    if (SHOW_LOGS) NSLog(@"GET %@", queryEsc);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSArray *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        NSString* newStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (SHOW_LOGS) NSLog(@"Retorna <<%@>>",newStr);
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error post ack %@",[error localizedDescription]);
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"nearbyReports"
                                                                object:self
                                                              userInfo:@{@"response":responseDict}];
            if (SHOW_LOGS) NSLog(@"Restultat nearby : %@",responseDict);
        }
        
    }];
    
    [postDataTask resume];

    
}

- (void) sendNotificationsToken {

    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    NSString *queryEsc = [NSString stringWithFormat:@"%@token/?token=%@&user_id=%@",C_API,_notificationsToken,udid];
    
    if (SHOW_LOGS) NSLog(@"GET %@", queryEsc);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSArray *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        NSString* newStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (SHOW_LOGS) NSLog(@"Retorna <<%@>>",newStr);
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error post ack %@",[error localizedDescription]);
            
        } else {
            if (SHOW_LOGS) NSLog(@"Restultat token : %@",responseDict);
        }
        
    }];
    
    [postDataTask resume];
    
}


- (void) getMosquitoToValidate {
    
    if ([RestApi sharedInstance].pybossaBearer != nil) {
        // si ja tinc un bearer continuo
       [self getMosquitoToValidateStep2];
    } else {
        if (SHOW_LOGS) NSLog(@"=================== getAuth =================");
        
        // pas 1 : trobar token"
        NSString *queryStep1 = [NSString stringWithFormat:@"%@/api/auth/project/%@/token",C_PYBOSSA_HOST,C_PYBOSSA_PROJECT_NAME];
        
        if (SHOW_LOGS) NSLog(@"GET %@", queryStep1);
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
        NSURL *url= [NSURL URLWithString:queryStep1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:10.0];
        
        [request setValue:C_PYBOSSA_AUTH forHTTPHeaderField:@"Authorization"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPMethod:@"GET"];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
            
            NSString* bearer = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (SHOW_LOGS) NSLog(@"Retorna <<%@>>",bearer);
            
            if (bearer.length < 3) {
                if (SHOW_LOGS) NSLog(@"Error get auth");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"validateMosquito"
                                                                    object:self
                                                                  userInfo:@{@"error":@"auth"}];
                
            } else {
                [RestApi sharedInstance].pybossaBearer = [NSString stringWithFormat:@"Bearer %@",bearer];
                [self getMosquitoToValidateStep2];
            }
            
        }];
        
        [postDataTask resume];
    }
}

- (void) getMosquitoToValidateStep2 {
    
    
    if (SHOW_LOGS) NSLog(@"=================== getMosquito =================");

    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    // http://mosquitoalert.pybossa.com/project/mosquito_alert_test
    // http://mosquitoalert.pybossa.com/project/mosquito-alert
    // ip projecte desenvolupament 2
    // id projecte producció 1
    NSString *queryEsc = [NSString stringWithFormat:@"%@/api/project/%@/newtask?external_uid=%@",C_PYBOSSA_HOST, C_PYBOSSA_PROJECT_ID, udid];
    
    if (SHOW_LOGS) NSLog(@"GET %@", queryEsc);
    if (SHOW_LOGS) NSLog(@"Authorization: %@", _pybossaBearer);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:_pybossaBearer forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSDictionary *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        NSString* newStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (SHOW_LOGS) NSLog(@"Retorna <<%@>>",newStr);
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error post ack %@",[error localizedDescription]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"validateMosquito"
                                                                object:self
                                                              userInfo:@{@"error":herror.localizedDescription}];
            
        } else {
            if (SHOW_LOGS) NSLog(@"Restultat formulari : %@",responseDict);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"validateMosquito"
                                                                object:self
                                                              userInfo:responseDict];
        }
        
    }];
    
    [postDataTask resume];
}



- (void) sendMosquitoValidation:(NSDictionary *)info {
    
    self.imageData = nil;
    
    if (SHOW_LOGS) NSLog(@"=================== sendMosquitoValidation =================");
    
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //NSString *queryEsc = [NSString stringWithFormat:@"%@/api/taskrun?external_uid=%@", C_PYBOSSA_HOST,udid];
    
    NSDictionary *outDict = @{@"project_id":[RestApi sharedInstance].validationInfo[@"project_id"]
                              ,@"task_id":[RestApi sharedInstance].validationInfo[@"id"]
                              ,@"external_uid":udid
                              ,@"info": info
                              };
    
    
    //NSString *queryEsc = [NSString stringWithFormat:@"%@/api/taskrun", C_PYBOSSA_HOST];
    NSString *queryEsc = [NSString stringWithFormat:@"%@/api/taskrun?external_uid=%@", C_PYBOSSA_HOST,udid];
    if (SHOW_LOGS) NSLog(@"POST %@", queryEsc);
    if (SHOW_LOGS) NSLog(@"info: %@", outDict);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:_pybossaBearer forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:outDict options:0 error:&error];
    [request setHTTPBody:postData];
    if (SHOW_LOGS) NSLog(@"posData error sendValidatoin= %@", error.localizedDescription);
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSDictionary *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        NSString* newStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (SHOW_LOGS) NSLog(@"Retorna <<%@>>",newStr);
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error post ack %@",[error localizedDescription]);
            
        } else {
            if (SHOW_LOGS) NSLog(@"Restultat formulari : %@",responseDict);
            

        }
        [[RestApi sharedInstance] getMosquitoToValidate]; // seguent mosquit
        
    }];
    
    [postDataTask resume];
    
}

- (void) getUserScore {
    
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *queryEsc = [NSString stringWithFormat:@"%@user_score/?user_id=%@",C_API,udid];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setValue:C_TOKEN forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {
        
        NSError *herror;
        NSDictionary *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error users %@",[error localizedDescription]);
        } else {
            if (responseDict != nil) {
                _userScore = [responseDict[@"score"] intValue];
                _userScoreString = responseDict[@"score_label"];
                [self saveUserScoreToUserDefaults];
            }
            if (SHOW_LOGS) NSLog(@"score = %d ok %@",_userScore, responseDict);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreUpdated"
                                                            object:self
                                                          userInfo:responseDict];
        
        
    }];
    
    [postDataTask resume];
    
}


- (void) getMosquitoImage:(NSString *)uuid {
    
    //NSString *imageURLString = [NSString stringWithFormat:@"http://humboldt.ceab.csic.es/get_photo/q0n50KN2Tg1O0Zh/%@/medium", _info[@"info"][@"uuid"]];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@/get_photo/q0n50KN2Tg1O0Zh/%@/medium", @"http://humboldt.ceab.csic.es", uuid];
    
    //NSLog(@"image =%@", imageURLString);
    _imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]];
    
    //NSLog(@"size = %lu", (unsigned long)_imageData.length);
    
}

- (NSDictionary *) validateInfoForOption:(int)option {
    if (option == OPTION_NO) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"no"
                 ,@"mosquito": @"no"
                 ,@"type" : @"unknown"
                 ,@"yellowTorax" : @"no"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    } else if (option == OPTION_NS) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"no"
                 ,@"mosquito": @"unknown"
                 ,@"type" : @"unknown"
                 ,@"yellowTorax" : @"no"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
        
    } else if (option == OPTION_TIGER_NO_TORAX) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"no"
                 ,@"type" : @"tiger"
                 ,@"mosquito": @"yes"
                 ,@"yellowTorax" : @"no"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    } else if (option == OPTION_TIGER_NO_ABDOMEN) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"yes"
                 ,@"type" : @"tiger"
                 ,@"mosquito": @"yes"
                 ,@"yellowTorax" : @"no"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    } else if (option == OPTION_TIGER) {
        return @{@"tigerAbdomen" : @"yes"
                 ,@"tigerTorax" : @"yes"
                 ,@"type" : @"tiger"
                 ,@"mosquito": @"yes"
                 ,@"yellowTorax" : @"no"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    } else if (option == OPTION_YELLOW) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"no"
                 ,@"mosquito": @"yes"
                 ,@"type" : @"yellow"
                 ,@"yellowTorax" : @"yes"
                 ,@"yellowAbdomen" : @"yes"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    } else if (option == OPTION_YELLOW_NO_TORAX) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"no"
                 ,@"mosquito": @"yes"
                 ,@"type" : @"yellow"
                 ,@"yellowTorax" : @"no"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    } else if (option == OPTION_YELLOW_NO_ABDOMEN) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"no"
                 ,@"mosquito": @"yes"
                 ,@"type" : @"yellow"
                 ,@"yellowTorax" : @"yes"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    } else if (option == OPTION_NOT_SURE) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"no"
                 ,@"mosquito": @"yes"
                 ,@"type" : @"tiger-unknown"
                 ,@"yellowTorax" : @"no"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    } else if (option == OPTION_NONE_OF_BOTH) {
        return @{@"tigerAbdomen" : @"no"
                 ,@"tigerTorax" : @"no"
                 ,@"mosquito": @"yes"
                 ,@"type" : @"mosquito-noneofboth"
                 ,@"yellowTorax" : @"no"
                 ,@"yellowAbdomen" : @"no"
                 ,@"user_lang" : [LocalText currentLoc]
                 };
    }
    return @{};
}



@end
