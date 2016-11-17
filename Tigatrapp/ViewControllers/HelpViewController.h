//
//  HelpViewController.h
//  Tigatrapp
//
//  Created by jordi on 29/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *fallbackFile;
@property (nonatomic, strong) NSString *htmlString;
@end
