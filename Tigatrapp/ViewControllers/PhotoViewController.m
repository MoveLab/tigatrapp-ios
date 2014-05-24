//
//  PhotoViewController.m
//  Tigatrapp
//
//  Created by jordi on 24/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

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
    _imageView.image = [UIImage imageWithData:[_report.images objectAtIndex:_imageIndex]];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pressDelete:(id)sender {
    [_report.images removeObjectAtIndex:_imageIndex];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
