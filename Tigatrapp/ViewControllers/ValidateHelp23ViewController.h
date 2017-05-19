//
//  ValidateHelp23ViewController.h
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidateHelp23ViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *mosquitoLabel;
@property (nonatomic, weak) IBOutlet UILabel *latinLabel;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *text2Label;
@property (nonatomic, weak) IBOutlet UILabel *text3Label;
@property (nonatomic, weak) IBOutlet UILabel *exampleLabel;
@property (nonatomic, weak) IBOutlet UILabel *toraxLabel;
@property (nonatomic, weak) IBOutlet UILabel *abdomenLabel;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

- (IBAction) pressDone;
@end
