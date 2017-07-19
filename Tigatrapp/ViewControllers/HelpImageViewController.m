//
//  HelpImageViewController.m
//  Tigatrapp
//
//  Created by jordi on 02/06/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
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
    
    self.title = [LocalText with:@"header_title"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [_imageView addGestureRecognizer:tap];
    
    [Helper resizePortraitView:self.view];

    
}

-(NSString *) stringByStrippingHTML:(NSString *)string {
    NSRange r;
    NSString *s = [string copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (void) viewWillAppear:(BOOL)animated {
    float viewHeight = self.view.frame.size.height;
    
    [_imageLabel setFrame:CGRectMake(20.0, viewHeight, 280.0, 300.0)];
    
    if (_imageName) {
        self.imageView.image = [UIImage imageNamed:_imageName];
        self.imageLabel.text = [self stringByStrippingHTML:_caption];
        _imageLabel.numberOfLines = 0;
        [_imageLabel sizeToFit];
        float labelSize = _imageLabel.frame.size.height+20.0;
        [_imageView setFrame:CGRectMake(20.0, 20.0, 280.0, viewHeight-labelSize-20)];
        [_imageLabel setFrame:CGRectMake(20.0, viewHeight-labelSize, 280.0, labelSize)];
        
    } else {
        self.imageView.image = nil;
        self.imageLabel.text = [self stringByStrippingHTML:_caption];
        _imageLabel.numberOfLines = 0;
        [_imageLabel sizeToFit];
        float labelSize = _imageLabel.frame.size.height+20.0;
        //[_imageView setFrame:CGRectMake(20.0, 20.0, 280.0, viewHeight-labelSize-20)];
        [_imageLabel setFrame:CGRectMake(20.0, 70.0, 280.0, labelSize)];

    }
    
    
}

- (void)tapImage {
    float viewHeight = self.view.frame.size.height;
    float labelSize = _imageLabel.frame.size.height;
    if (_imageView.frame.size.height == viewHeight) {
        [_imageView setFrame:CGRectMake(20.0, 20.0, 280.0, viewHeight-labelSize-20)];
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
