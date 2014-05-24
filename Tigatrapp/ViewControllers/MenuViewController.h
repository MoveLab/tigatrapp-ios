//
//  MenuViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIButton *breedingButton;
@property (nonatomic, weak) IBOutlet UIButton *mosquitoButton;
@property (nonatomic, weak) IBOutlet UIButton *mapButton;
@property (nonatomic, weak) IBOutlet UIButton *galleryButton;
@property (nonatomic, weak) IBOutlet UIButton *webButton;
@property (nonatomic, weak) IBOutlet UILabel *reportLabel;
@property (nonatomic, weak) IBOutlet UILabel *utilitiesLabel;

- (IBAction) pressWebButton:(id)sender;


@end
