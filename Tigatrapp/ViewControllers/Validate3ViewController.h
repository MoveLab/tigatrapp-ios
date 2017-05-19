//
//  Validate3ViewController.h
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Validate3ViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIView *toraxView;
@property (nonatomic, weak) IBOutlet UIImageView *toraxImageView;
@property (nonatomic, weak) IBOutlet UIButton *yesToraxButton;
@property (nonatomic, weak) IBOutlet UIButton *noToraxButton;


- (IBAction) pressYesTorax:(id)sender;
- (IBAction) pressNoTorax:(id)sender;
- (IBAction) pressInfo:(id)sender;

@end
