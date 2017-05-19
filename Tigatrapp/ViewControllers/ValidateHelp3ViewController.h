//
//  ValidateHelp3ViewController.h
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidateHelp3ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *tigerLabel;
@property (nonatomic, weak) IBOutlet UILabel *yellowLabel;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

- (IBAction) pressDone:(id)sender;
@end
