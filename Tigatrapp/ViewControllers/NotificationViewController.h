//
//  NotificationViewController.h
//  Tigatrapp
//
//  Created by jordi on 24/6/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSDictionary *notification;

- (IBAction) acknowledgeNotification:(id)sender;

@end
