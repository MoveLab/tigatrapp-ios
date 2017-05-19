//
//  Validate4ViewController.m
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import "Validate4ViewController.h"
#import "RestApi.h"
#import "LocalText.h"

@interface Validate4ViewController ()
@property (nonatomic) BOOL readyToScroll;
@end

@implementation Validate4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [LocalText with:@"back"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    self.readyToScroll = NO;

    [self drawScrollView];

    _abdomenView.backgroundColor = C_GRAY;
    [_imageView setImage:[UIImage imageWithData:[RestApi sharedInstance].imageData]];
    
    if ([RestApi sharedInstance].validationType == OPTION_TIGER) {
        [_abdomenImageView setImage:[UIImage imageNamed:@"abdomenTigre"]];
    } else {
        [_abdomenImageView setImage:[UIImage imageNamed:@"abdomenGroga"]];
    }

    _titleLabel.text = [LocalText with:@"i18n_recognize_abdomen"];
    [_yesAbdomenButton setTitle:[LocalText with:@"i18n_yesbtn4"] forState:UIControlStateNormal];
    [_noAbdomenButton setTitle:[LocalText with:@"i18n_nobtn4"] forState:UIControlStateNormal];
    
    if ([RestApi sharedInstance].showValidation4Help) {
        [self performSegueWithIdentifier:@"validateHelp4Segue" sender:self];
        [RestApi sharedInstance].showValidation4Help = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"DONE" forKey:@"showValidation4Help"];
    }


}

- (void) viewWillAppear:(BOOL)animated {
    [self drawScrollView];
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

- (void) sendValidation:(int)option {
    
    NSDictionary *dict = [[RestApi sharedInstance] validateInfoForOption:option];
    NSDictionary *outDict = @{@"project_id":[RestApi sharedInstance].validationInfo[@"project_id"]
                              ,@"task_id":[RestApi sharedInstance].validationInfo[@"id"]
                              ,@"info": dict
                              };
    [[RestApi sharedInstance] sendMosquitoValidation:outDict];
}


#pragma mark - buttons validacio

- (IBAction) pressYesAbdomen:(id)sender {
    if ([RestApi sharedInstance].validationType == OPTION_TIGER) {
        [self sendValidation: OPTION_TIGER];
    } else if ([RestApi sharedInstance].validationType == OPTION_YELLOW) {
        [self sendValidation: OPTION_YELLOW];
    }
    [self.navigationController popToViewController:[RestApi sharedInstance].validation1ViewController animated:YES];

}

- (IBAction) pressNoAbdomen:(id)sender {
    if ([RestApi sharedInstance].validationType == OPTION_YELLOW) {
        [self sendValidation: OPTION_YELLOW_NO_ABDOMEN];
        [_imageView setImage:nil];
    } else if ([RestApi sharedInstance].validationType == OPTION_TIGER) {
        [self sendValidation: OPTION_TIGER_NO_ABDOMEN];
        [_imageView setImage:nil];
    }
    [self.navigationController popToViewController:[RestApi sharedInstance].validation1ViewController animated:YES];
}

- (IBAction)pressInfo:(id)sender {
    [self performSegueWithIdentifier:@"validateHelp4Segue" sender:self];
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
