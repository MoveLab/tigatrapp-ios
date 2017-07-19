//
//  Validate1ViewController.m
//  Tigatrapp
//
//  Created by jordi on 10/5/17.
//  Copyright © 2017 ibeji. All rights reserved.
//

#import "Validate1ViewController.h"
#import "RestApi.h"
#import "LocalText.h"

@interface Validate1ViewController ()
@property (nonatomic) BOOL readyToScroll;
@end

@implementation Validate1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [LocalText with:@"back"];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mosquitoToValidate:)
                                                 name:@"validateMosquito"
                                               object:nil];
    
    self.yesButton.hidden = YES;
    self.noButton.hidden = YES;
    self.notSureButton.hidden = YES;
    
    [RestApi sharedInstance].currentValidationImageScale = 1.0;
    [self drawScrollView];
    
    _titleLabel.text = [LocalText with:@"loading picture"];
    [_yesButton setTitle:[LocalText with:@"i18n_step1_yes"] forState:UIControlStateNormal];
    [_noButton setTitle:[LocalText with:@"i18n_step1_no"] forState:UIControlStateNormal];
    [_notSureButton setTitle:[LocalText with:@"i18n_notsurebtn"] forState:UIControlStateNormal];
    
    _mosquitoView.backgroundColor = C_GRAY;
    [[RestApi sharedInstance] getMosquitoToValidate];
    [RestApi sharedInstance].validation1ViewController = self;
    
    if ([RestApi sharedInstance].showValidation1Help) {
        [self performSegueWithIdentifier:@"validateHelp1Segue" sender:self];
        [RestApi sharedInstance].showValidation1Help = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"DONE" forKey:@"showValidation1Help"];
    }
    [Helper resizePortraitView:self.view];

}

- (void) drawScrollView {
    _readyToScroll = NO;

    self.scrollView.zoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.delegate = self;
    
    if ([RestApi sharedInstance].imageData != nil) {
        self.yesButton.hidden = NO;
        self.noButton.hidden = NO;
        self.notSureButton.hidden = NO;
        _titleLabel.text = [LocalText with:@"i18n_question1"];
        self.scrollView.zoomScale = [RestApi sharedInstance].currentValidationImageScale;
        self.scrollView.contentOffset = [RestApi sharedInstance].currentValidationImageOffset;
        [_imageView setImage:[UIImage imageWithData:[RestApi sharedInstance].imageData]];
    } else {
        _titleLabel.text = [LocalText with:@"loading picture"];
        self.yesButton.hidden = YES;
        self.noButton.hidden = YES;
        self.notSureButton.hidden = YES;
        [_imageView setImage: nil];
    }
    _readyToScroll = YES;

    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [self drawScrollView];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) alertError {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[LocalText with:@"header_title"]
                                 message:[LocalText with:@"pybossa_error"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:[LocalText with:@"menu_close"]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
    
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (void) mosquitoToValidate:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    if (info == nil) {
        if (SHOW_LOGS) NSLog(@"Info mosquit a validar buida");
        [self alertError];
    } else if (info[@"error"]) {
        if (SHOW_LOGS) NSLog(@"error al validar: %@", info[@"error"]);
        [self alertError];

    } else {
        // cas normal
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _titleLabel.text = [LocalText with:@"i18n_question1"];
            [RestApi sharedInstance].validationInfo = notification.userInfo;
            [[RestApi sharedInstance] getMosquitoImage:[RestApi sharedInstance].validationInfo[@"info"][@"uuid"]];
            [RestApi sharedInstance].currentValidationImageScale = 1.0;
            self.scrollView.zoomScale = [RestApi sharedInstance].currentValidationImageScale;
            self.scrollView.contentOffset = CGPointMake(0, 0);
            self.yesButton.hidden = NO;
            self.noButton.hidden = NO;
            self.notSureButton.hidden = NO;
            // main thread code
            [_imageView setImage:[UIImage imageWithData:[RestApi sharedInstance].imageData]];
            
        });
        
    }
    
}

- (void) sendValidation:(int)option {
    NSDictionary *dict = [[RestApi sharedInstance] validateInfoForOption:option];
    [[RestApi sharedInstance] sendMosquitoValidation:dict];
}


#pragma mark - buttons validacio

- (IBAction) pressYes:(id)sender {
    [self performSegueWithIdentifier:@"validate1Segue" sender:self];
}
- (IBAction) pressNo:(id)sender {
    [self sendValidation: OPTION_NO];
    [_imageView setImage:nil];
}
- (IBAction) pressNotSure:(id)sender {
    [self sendValidation: OPTION_NS];
    [_imageView setImage:nil];
}



- (IBAction)pressInfo:(id)sender {
    
    [self performSegueWithIdentifier:@"validateHelp1Segue" sender:self];
}

#pragma mark - uiscrollviewdelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat) scale {
    
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
