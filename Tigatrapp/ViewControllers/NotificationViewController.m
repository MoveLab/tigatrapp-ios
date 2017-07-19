//
//  NotificationViewController.m
//  Tigatrapp
//
//  Created by jordi on 24/6/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import "NotificationViewController.h"
#import "RestApi.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LocalText with:@"header_title"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    if (SHOW_LOGS) NSLog(@"notification = %@",_notification);
    
    NSString *html = @"<html> \n"
    "<head> \n"
    "<style type=\"text/css\"> \n"
    "body {font-family: Futura; font-size: 18;}\n"
    "</style> \n"
    "</head><body>";
    
    
    if ( _notification[@"photo_url"]  == [ NSNull null ] ) {
        html = [html stringByAppendingString:[NSString stringWithFormat:@"%@",_notification[@"expert_html"]]];
    } else {
        if ([_notification[@"photo_url"] length] > 10) {
            html = [html stringByAppendingString:[NSString stringWithFormat:@"<img width=\"100%%\" src=\"%@\"/><br>%@",_notification[@"photo_url"],_notification[@"expert_html"]]];
        } else {
            html = [html stringByAppendingString:[NSString stringWithFormat:@"%@",_notification[@"expert_html"]]];
        }
        
    }
    
    
    html = [html stringByAppendingString:@"</body></html>"];
    [_webView loadHTMLString:html baseURL:nil];
    _webView.scrollView.bounces = NO;
    
    [Helper resizePortraitView:self.view];

}

- (void) viewDidAppear:(BOOL)animated {
    
    [self acknowledgeNotification:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) acknowledgeNotification:(id)sender {
    int notificationId = [_notification[@"id"] intValue];
    if (SHOW_LOGS) NSLog(@"AcknowledgeNotification=====");
    
    if ([[RestApi sharedInstance] existsNotificationWithId:notificationId]) {
        // ja estava notificat
    } else {
        [[RestApi sharedInstance].notificationsArray removeObject:_notification];
        [[RestApi sharedInstance].ackNotificationsArray addObject:_notification];
        [[RestApi sharedInstance] saveAckNotificationsToUserDefaults];
        [[RestApi sharedInstance] acknowledgeNotification:notificationId];
        // actualitzo badge
        [UIApplication sharedApplication].applicationIconBadgeNumber = [RestApi sharedInstance].notificationsArray.count;

    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
