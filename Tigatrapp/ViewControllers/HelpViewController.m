//
//  HelpViewController.m
//  Tigatrapp
//
//  Created by jordi on 29/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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


    if (_urlString!=nil) {
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
    } else {
        
        NSString *html = [NSString stringWithFormat:@"<html> \n"
        "<head> \n"
        "<style type=\"text/css\"> \n"
        "body {font-family: Futura; font-size: 18;}\n"
        "</style> \n"
        "</head><body>%@</body></html>", _htmlString];
        
        
        [self.webView setBackgroundColor:[UIColor clearColor]];
        [self.webView loadHTMLString:html baseURL:nil];
    }
    
    [Helper resizePortraitView:self.view];

}

#pragma mark - UIWebView delegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_urlString]) {
        [_webView loadHTMLString:[[NSUserDefaults standardUserDefaults] objectForKey:_urlString]
                         baseURL:nil];
    } else if (_fallbackFile) {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:_fallbackFile ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_urlString!=nil) {
        if (SHOW_LOGS) NSLog(@"webview did finish load %@",_urlString);
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                          @"document.body.innerHTML"];
        [[NSUserDefaults standardUserDefaults] setObject:html forKey:_urlString];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        if (SHOW_LOGS) NSLog(@"webview did finish load local file");
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
