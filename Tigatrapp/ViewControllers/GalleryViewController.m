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
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0,20.0,scrollviewWidth-40.0,260.0)];
        imageView.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
        [pageView addSubview:imageView];
        
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
