//
//  Validate2ViewController.m
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import "Validate2ViewController.h"
#import "RestApi.h"
#import "LocalText.h"

@interface Validate2ViewController ()
@property (nonatomic) BOOL readyToScroll;
@end

@implementation Validate2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LocalText with:@"back"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    self.readyToScroll = NO;
    [self drawScrollView];
    
    _typeView.backgroundColor = C_GRAY;
    _titleLabel.text = [LocalText with:@"i18n_whatmosquito"];
    _yellowLabel.text = [LocalText with:@"i18n_yellowfeverbtn"];
    _tigerLabel.text = [LocalText with:@"i18n_tigerbtn"];
    [_dontKnowButton setTitle:[LocalText with:@"i18n_notsurebtn2"] forState:UIControlStateNormal];
    [_noneButton setTitle:[LocalText with:@"i18n_noneofbothbtn"] forState:UIControlStateNormal];
    
    [RestApi sharedInstance].validation2ViewController = self;
    
    if ([RestApi sharedInstance].showValidation2Help) {
        [self performSegueWithIdentifier:@"validateHelp2Segue" sender:self];
        [RestApi sharedInstance].showValidation2Help = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"DONE" forKey:@"showValidation2Help"];
    }


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

- (void) viewWillAppear:(BOOL)animated {
    
    [self drawScrollView];
    
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

- (IBAction) pressTiger:(id)sender {
    [RestApi sharedInstance].validationType = OPTION_TIGER;
    [self performSegueWithIdentifier:@"validate2Segue" sender:self];
}
- (IBAction) pressYellow:(id)sender {
    [RestApi sharedInstance].validationType = OPTION_YELLOW;
    [self performSegueWithIdentifier:@"validate2Segue" sender:self];
}

- (IBAction) pressDontKnow:(id)sender {
    [self sendValidation: OPTION_NOT_SURE];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction) pressNone:(id)sender {
    [self sendValidation: OPTION_NONE_OF_BOTH];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)pressInfo:(id)sender {
    [self performSegueWithIdentifier:@"validateHelp2Segue" sender:self];
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
