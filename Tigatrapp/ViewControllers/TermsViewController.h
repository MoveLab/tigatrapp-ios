//
//  TermsViewController.h
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *acceptLabel;
@property (nonatomic, weak) IBOutlet UILabel *denyLabel;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

- (IBAction)pressAccept:(id)sender;
- (IBAction)pressDeny:(id)sender;

@end
