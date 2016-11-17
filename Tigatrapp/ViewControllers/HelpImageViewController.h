//
//  HelpImageViewController.h
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import <UIKit/UIKit.h>

@interface HelpImageViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *imageLabel;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *imageName;

@end
