//
//  Validate4ViewController.h
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Validate4ViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIView *abdomenView;
@property (nonatomic, weak) IBOutlet UIImageView *abdomenImageView;
@property (nonatomic, weak) IBOutlet UIButton *yesAbdomenButton;
@property (nonatomic, weak) IBOutlet UIButton *noAbdomenButton;


- (IBAction) pressYesAbdomen:(id)sender;
- (IBAction) pressNoAbdomen:(id)sender;

- (IBAction) pressInfo:(id)sender;

@end
