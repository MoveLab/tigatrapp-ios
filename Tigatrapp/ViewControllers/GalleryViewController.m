//
//  GalleryViewController.m
//  Tigatrapp
//
//  Created by jordi on 25/04/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

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
    
    NSArray *imagesArray = @[@"a.jpg",@"c.jpg",@"d.jpg",@"e.jpg",@"f.jpg",@"g.jpg"
                             ,@"h.jpg",@"i.jpg",@"j.jpg",@"k.jpg",@"l.jpg"];
    NSArray *labelsArray = @[@"gallery_array",@"gallery_array_1",@"gallery_array_2",@"gallery_array_3",@"gallery_array_4"
                             ,@"gallery_array_5",@"gallery_array_6",@"gallery_array_7",@"gallery_array_8"
                             ,@"gallery_array_9",@"gallery_array_10"];
    
    _pageControl.numberOfPages = imagesArray.count;
    
    float scrollviewWidth = _scrollView.frame.size.width;
    float scrollviewHeight = _scrollView.frame.size.height-100.0;
    
    if (SHOW_LOGS) NSLog(@"Draw Scrollview width=%f height=%f", scrollviewWidth,scrollviewHeight);
    
    _scrollView.contentSize = CGSizeMake(scrollviewWidth*imagesArray.count, scrollviewHeight);
    _scrollView.scrollsToTop = YES;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    
    for (int i=0; i<imagesArray.count; i++) {

        UIView *pageView = [[UIView alloc]  initWithFrame:CGRectMake(scrollviewWidth*i,0.0,scrollviewWidth,scrollviewHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0,20.0,scrollviewWidth-40.0,200.0)];
        imageView.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
        [pageView addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0,230.0,scrollviewWidth-40.0,scrollviewHeight-200.0)];
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Futura-Medium" size:15.0];
        
        
        NSString *theString = NSLocalizedString([labelsArray objectAtIndex:i],nil);
        theString = [theString stringByReplacingOccurrencesOfString:@" +" withString:@" "
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange(0, theString.length)];
        
        NSLog(@"stringo=%@",theString);
        label.text = theString;
        [pageView addSubview:label];
        
        [_scrollView addSubview:pageView];
    }
}

#pragma mark - scrollview delegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float pageWidth = _scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    long page = lround(fractionalPage);
    [self.pageControl setCurrentPage:(int)page];
}

#pragma mark - page control

- (IBAction)pressChangePage:(UIPageControl *) pageControl {

    float scrollviewWidth = _scrollView.frame.size.width;
    [_scrollView scrollRectToVisible:CGRectMake(scrollviewWidth*pageControl.currentPage
                                                , 0.0, scrollviewWidth, 1.0) animated:YES];
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
