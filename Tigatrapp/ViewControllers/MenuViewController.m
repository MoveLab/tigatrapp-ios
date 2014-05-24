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
    
    
    NSString *queryEsc = @"http://161.111.254.98/api/users/?format=json";
    
    NSURL *url= [NSURL URLWithString:queryEsc];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    NSString *token = @"Token 3791ad3995d31cfb56add03030a804a7436079cc";
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSError * error = nil;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest: request
                                             returningResponse: nil
                                                         error: &error];
    
    NSDictionary *response = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) {
            NSLog(@"Error connexio %@",[error localizedDescription]);
            NSLog(@"Capturo d'user defaults");
    } else {
        NSLog(@"dict %@",response);
    }
    
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
