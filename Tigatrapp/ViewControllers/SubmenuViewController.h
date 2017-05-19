//
//  SubmenuViewController.h
//  Tigatrapp
//
//  Created by jordi on 22/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>

@interface SubmenuViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UILabel *menuLabel;
@property (nonatomic, weak) IBOutlet UILabel *newsLabel;
@property (nonatomic, weak) IBOutlet UILabel *helpLabel;
@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;
@property (nonatomic, weak) IBOutlet UILabel *shareLabel;
@property (nonatomic, weak) IBOutlet UILabel *galleryLabel;
@property (nonatomic, weak) IBOutlet UILabel *webLabel;

@end
