//
//  Validate1ViewController.h
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Validate1ViewController : UIViewController  <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIView *mosquitoView;
@property (nonatomic, weak) IBOutlet UIButton *yesButton;
@property (nonatomic, weak) IBOutlet UIButton *noButton;
@property (nonatomic, weak) IBOutlet UIButton *notSureButton;

- (IBAction) pressYes:(id)sender;
- (IBAction) pressNo:(id)sender;
- (IBAction) pressNotSure:(id)sender;

- (IBAction) pressInfo:(id)sender;

@end
