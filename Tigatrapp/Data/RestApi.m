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
        
        [self restoreFromUserDefaults];
        [self loadReportsToUpload];
        [self loadImagesToUpload];
        
        
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
        
        if (herror) {
            if (SHOW_LOGS) NSLog(@"Error post report %@",[error localizedDescription]);
            
        } else {
            _serverNotificationsArray = responseDict;
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
    if (SHOW_LOGS) {
        NSLog(@"RECUPERAT DE USER DEFAULTS: ");
        NSLog(@"- ackNotifications: %d ",  (int)_ackNotificationsArray.count);
        NSLog(@"- ackMissions: %d ", (int)_ackMissionsArray.count);
        NSLog(@"- deletedMissions: %d ", (int)_deletedMissionsArray.count);
    }
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


@end
