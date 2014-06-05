//
//  RestApi.m
//  Tigatrapp
//
//  Created by jordi on 30/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
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
    
    [request setValue:@"Token 3791ad3995d31cfb56add03030a804a7436079cc" forHTTPHeaderField:@"Authorization"];
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
            if (SHOW_LOGS) NSLog(@"Error post report %@",[error localizedDescription]);
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
    
    [request setValue:@"Token 3791ad3995d31cfb56add03030a804a7436079cc" forHTTPHeaderField:@"Authorization"];
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
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    [request setValue:@"Token 3791ad3995d31cfb56add03030a804a7436079cc" forHTTPHeaderField:@"Authorization"];
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
/*
- (void) callReports {
    if ([_reportsUploading count]==0) {
        for (NSDictionary *reportDictionary in _reportsToUpload) {
            NSLog(@"report to upload %@",reportDictionary);
            [self callApiWithName:@"reports" andParameters:reportDictionary];
        }
    }
}
 */

- (void) callReports {
    NSLog(@"reports to upload = %d uploading=%d", _reportsToUpload.count, _reportsUploading.count);
    if ([_reportsUploading count]==0) {
        [_reportsUploading addObjectsFromArray:[_reportsToUpload allObjects]];
        NSLog(@"reports to upload = %d uploading=%d", _reportsToUpload.count, _reportsUploading.count);
        [_reportsToUpload removeAllObjects];
        NSLog(@"reports to upload = %d uploading=%d", _reportsToUpload.count, _reportsUploading.count);
        for (NSDictionary *reportDictionary in _reportsUploading) {
            NSLog(@"report to upload %@",reportDictionary);
            [self callApiWithName:@"reports" andParameters:reportDictionary];
        }
    }
}

- (void) callImages {
    NSLog(@"images to upload = %d uploading=%d", _imagesToUpload.count, _imagesUploading.count);
    if ([_imagesUploading count] == 0) {
        [_imagesUploading addObjectsFromArray:[_imagesToUpload allObjects]];
        [_imagesToUpload removeAllObjects];
        NSLog(@"images to upload = %d uploading=%d", _imagesToUpload.count, _imagesUploading.count);
        for (NSDictionary *imageDictionary in _imagesUploading) {
            NSLog(@"image to upload from report %@",[imageDictionary valueForKey:@"report"]);
            [self callPhotosApiWithParameters:imageDictionary];
        }
    }
}

- (void) status {
    NSLog(@"=========================================================");
    
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

    NSLog(@"=========================================================");

}


#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    NSLog(@"URLSession:(NSURLSession *)session didBecomeInvalidWithError %@",[error localizedDescription]);
}


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
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



@end
