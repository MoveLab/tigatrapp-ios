//
//  Validate3ViewController.m
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import "Validate3ViewController.h"
#import "RestApi.h"
#import "LocalText.h"

@interface Validate3ViewController ()
@property (nonatomic) BOOL readyToScroll;
@end

@implementation Validate3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LocalText with:@"back"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    self.readyToScroll = NO;
    [self drawScrollView];

    _toraxView.backgroundColor = C_GRAY;
    [_imageView setImage:[UIImage imageWithData:[RestApi sharedInstance].imageData]];
    
    if ([RestApi sharedInstance].validationType == OPTION_TIGER) {
        [_toraxImageView setImage:[UIImage imageNamed:@"toraxTigre"]];
    } else {
        [_toraxImageView setImage:[UIImage imageNamed:@"toraxGroga"]];
    }
    
    _titleLabel.text = [LocalText with:@"i18n_thorax_question"];
    [_yesToraxButton setTitle:[LocalText with:@"i18n_yesbtn3"] forState:UIControlStateNormal];
    [_noToraxButton setTitle:[LocalText with:@"i18n_nobtn3"] forState:UIControlStateNormal];

    if ([RestApi sharedInstance].showValidation3Help) {
        [self performSegueWithIdentifier:@"validateHelp3Segue" sender:self];
        [RestApi sharedInstance].showValidation3Help = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"DONE" forKey:@"showValidation3Help"];
    }

    [Helper resizePortraitView:self.view];

}
- (void) drawScrollView {
    _readyToScroll = NO;
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.contentSize = self.imageView.frame.size;
    [_imageView setImage:[UIImage imageWithData:[RestApi sharedInstance].imageData]];
    
    self.scrollView.delegate = self;
    
    [_imageView setImage:[UIImage imageWithData:[RestApi sharedInstance].imageData]];
    self.scrollView.zoomScale = [RestApi sharedInstance].currentValidationImageScale;
    self.scrollView.contentOffset = [RestApi sharedInstance].currentValidationImageOffset;
    _readyToScroll = YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self drawScrollView];
}


- (void) sendValidation:(int)option {
    NSDictionary *dict = [[RestApi sharedInstance] validateInfoForOption:option];
    [[RestApi sharedInstance] sendMosquitoValidation:dict];
}


#pragma mark - buttons validacio

- (IBAction) pressYesTorax:(id)sender {
    [self performSegueWithIdentifier:@"validate3Segue" sender:self];
}

- (IBAction) pressNoTorax:(id)sender {
    if ([RestApi sharedInstance].validationType == OPTION_YELLOW) {
        [self sendValidation: OPTION_YELLOW_NO_TORAX];
        [self.navigationController popToViewController:[RestApi sharedInstance].validation1ViewController animated:YES];
    } else if ([RestApi sharedInstance].validationType == OPTION_TIGER) {
        [self sendValidation: OPTION_TIGER_NO_TORAX];
        [self.navigationController popToViewController:[RestApi sharedInstance].validation1ViewController animated:YES];
    }
}

- (IBAction)pressInfo:(id)sender {
    [self performSegueWithIdentifier:@"validateHelp3Segue" sender:self];
}

#pragma mark - uiscrollviewdelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [RestApi sharedInstance].currentValidationImageScale = scale;
    [RestApi sharedInstance].currentValidationImageOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_readyToScroll) {
        [RestApi sharedInstance].currentValidationImageOffset = scrollView.contentOffset;

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
