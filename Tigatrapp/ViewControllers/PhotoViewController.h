//
//  PhotoViewController.h
//  Tigatrapp
//
//  Created by jordi on 24/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Report.h"

@interface PhotoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic) int imageIndex;
@property (nonatomic, weak) Report *report;

-(IBAction)pressDelete:(id)sender;

@end
