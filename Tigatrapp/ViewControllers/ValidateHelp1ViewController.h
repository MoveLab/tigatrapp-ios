//
//  ValidateHelp1ViewController.h
//  Tigatrapp
//
//  Created by jordi on 9/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidateHelp1ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *text2Label;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

- (IBAction) pressDone:(id)sender;

@end
