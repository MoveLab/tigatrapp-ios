//
//  PickPhotoViewController.m
//  Tigatrapp
//
//  Created by jordi on 24/05/14.
//  Copyright (c) 2014 ibeji. All rights reserved.
//

#import "PickPhotoViewController.h"
#import "PhotoViewController.h"

@interface PickPhotoViewController ()
@property (nonatomic) int selectedImageIndex;
@end

@implementation PickPhotoViewController

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
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"mosquitoImages"];

}

- (void)viewWillAppear:(BOOL)animated {
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _report.images.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"mosquitoImages" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:981];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0,5.0,80.0,80.0)];
        [imageView setTag:981];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell addSubview:imageView];
    }
    
    imageView.image = [UIImage imageWithData:[_report.images objectAtIndex:indexPath.row]];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 90);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedImageIndex = (int) indexPath.row;
    [self performSegueWithIdentifier: @"photoSegue" sender: self];
}


#pragma mark - Photo

-(IBAction) pickPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

-(IBAction) takePhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.showsCameraControls = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSData *imageData = UIImagePNGRepresentation(image);
    NSData* imageData = UIImageJPEGRepresentation(image, 0.4); //0.4 is the compression rate.
    [_report.images addObject:imageData];
    [_collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Volver"
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    if ([segue.identifier isEqualToString:@"photoSegue"]) {
        PhotoViewController *viewController = segue.destinationViewController;
        viewController.report = _report;
        viewController.imageIndex = _selectedImageIndex;
    }
    
}

@end
