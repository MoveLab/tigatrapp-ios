//
//  MenuViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "MenuViewController.h"
#import "CurrentLocation.h"

@interface MenuViewController ()
@property (nonatomic, strong) UIActionSheet *actionSheet;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[CurrentLocation sharedInstance] startLocation];
    
    // Do any additional setup after loading the view.
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Task List",
                            @"Tigatrapp Project",
                            @"Share app",
                            @"Help",
                            @"Testing",
                            @"About",
                            nil];
    
    
    // NSLocalizedStringFromTable(key, tbl, comment)
    
    NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"UDID %@", udid);
    
    /*
     
     The value of this property is the same for apps that come from the same vendor running on the same device. A different value is returned for apps on the same device that come from different vendors, and for apps on different devices regardless of vendor.
     
     If the value is nil, wait and get the value again later. This happens, for example, after the device has been restarted but before the user has unlocked the device.
     
     The value in this property remains the same while the app (or another app from the same vendor) is installed on the iOS device. The value changes when the user deletes all of that vendor’s apps from the device and subsequently reinstalls one or more of them. The value can also change when installing test builds using Xcode or when installing an app on a device using ad-hoc distribution. Therefore, if your app stores the value of this property anywhere, you should gracefully handle situations where the identifier changes.
     
     */
    
    
    NSString *queryEsc = [NSString stringWithFormat:@"%@users/?format=json",C_API];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    NSString *token = @"Token 3791ad3995d31cfb56add03030a804a7436079cc";
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    NSError *error;
    //NSDictionary *mapData = @{@"user_UDID":udid};
   
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:udid,@"user_UUID",nil];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *jsonData, NSURLResponse *response, NSError *error) {

        NSLog(@"crida = %@",mapData);
        NSString* newStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json = %@",newStr);
        
        NSError *herror;
        NSDictionary *responseDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&herror] : nil;
        
        if (herror) {
            NSLog(@"Error parsejant %@",[error localizedDescription]);
        } else {
            NSLog(@"dict %@",responseDict);
        }

        
    }];
    
    [postDataTask resume];
/*
    NSError *connectionError = nil;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest: request
                                             returningResponse: nil
                                                         error: &connectionError];
    if (connectionError) {
        NSLog(@"Error connexio %@",[connectionError localizedDescription]);
        NSLog(@"bytes = %d",jsonData.length);
    } else {
        NSLog(@"Connexio OK");
        NSLog(@"bytes = %d",jsonData.length);
        NSString* newStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json = %@",newStr);
    }
    
    NSError *error;
    NSDictionary *response = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) {
            NSLog(@"Error parsejant %@",[error localizedDescription]);
    } else {
        NSLog(@"dict %@",response);
    }
    
 */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) pressMoreOptions:(id)sender {
    [_actionSheet showInView:self.view];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //  [self FBShare];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation


- (IBAction) pressWebButton:(id)sender {
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Volver"
                                  style:UIBarButtonItemStylePlain
                                  target:nil
                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;

}


@end
