//
//  HelpImageViewController.m
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "HelpImageViewController.h"

@interface HelpImageViewController ()

@end

@implementation HelpImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = [UIImage imageNamed:_imageName];
    self.imageLabel.text = _caption;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [_imageView addGestureRecognizer:tap];
    
}

- (void)tapImage {
    float viewHeight = self.view.frame.size.height;
    if (_imageView.frame.size.height == viewHeight) {
        [_imageView setFrame:CGRectMake(20.0, 20.0, 280.0, 300.0)];
    } else {
        [_imageView setFrame:CGRectMake(0.0, 0.0, 320.0, viewHeight)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
