//
//  Validate2ViewController.h
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Validate2ViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIView *typeView;
@property (nonatomic, weak) IBOutlet UILabel *yellowLabel;
@property (nonatomic, weak) IBOutlet UILabel *tigerLabel;
@property (nonatomic, weak) IBOutlet UIButton *tigerButton;
@property (nonatomic, weak) IBOutlet UIButton *yellowButton;
@property (nonatomic, weak) IBOutlet UIButton *dontKnowButton;
@property (nonatomic, weak) IBOutlet UIButton *noneButton;


- (IBAction) pressTiger:(id)sender;
- (IBAction) pressYellow:(id)sender;
- (IBAction) pressDontKnow:(id)sender;
- (IBAction) pressNone:(id)sender;

- (IBAction) pressInfo:(id)sender;

@end
