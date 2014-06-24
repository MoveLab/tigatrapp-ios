//
//  MenuViewController.h
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UIActionSheetDelegate,NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UIButton *breedingButton;
@property (nonatomic, weak) IBOutlet UIButton *mosquitoButton;
@property (nonatomic, weak) IBOutlet UIButton *mapButton;
@property (nonatomic, weak) IBOutlet UIButton *galleryButton;
@property (nonatomic, weak) IBOutlet UIButton *webButton;

@property (nonatomic, weak) IBOutlet UILabel *breedingHeaderLabel;
@property (nonatomic, weak) IBOutlet UILabel *breedingFootLabel;
@property (nonatomic, weak) IBOutlet UILabel *mosquitoHeaderLabel;
@property (nonatomic, weak) IBOutlet UILabel *mosquitoFootLabel;
@property (nonatomic, weak) IBOutlet UILabel *mapHeaderLabel;
@property (nonatomic, weak) IBOutlet UILabel *mapFootLabel;
@property (nonatomic, weak) IBOutlet UILabel *galleryHeaderLabel;
@property (nonatomic, weak) IBOutlet UILabel *galleryFootLabel;

- (IBAction) pressWebButton:(id)sender;


@end
