//
//  HelpImageViewController.h
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpImageViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *imageLabel;
@property (nonatomic, weak) IBOutlet NSString *caption;
@property (nonatomic, weak) IBOutlet NSString *imageName;

@end
