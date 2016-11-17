//
//  PybossaViewController.h
//  Tigatrapp
//
//  Created by jordi on 19/5/16.
//  Copyright © 2016 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PybossaViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *fallbackFile;
@property (nonatomic, strong) NSString *htmlString;

@end
