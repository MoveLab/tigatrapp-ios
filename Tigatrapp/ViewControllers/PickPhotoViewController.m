//
//  PickPhotoViewController.m
//  Tigatrapp
//
//  Created by jordi on 24/05/14.
//  Copyright (c) 2014 OMA Technologies, Ibeji digital, John R.B. Palmer, Aitana Oltra, Joan Garriga and Frederic Bartumeus
//

#import "PickPhotoViewController.h"
#import "PhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

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
    [_takePhotoButton setTitle:[LocalText with:@"photo_selector_take_photo_button"] forState:UIControlStateNormal];
    [_pickPhotoButton setTitle:[LocalText with:@"photo_selector_attach_photo_button"] forState:UIControlStateNormal];
    UIImage* logoImage = [UIImage imageNamed:@"atrapaeltigre_site_icon_large-1"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
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

    /*
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {


        NSLog(@"%zd", [group numberOfAssets]);
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access, code: %zd", error.code);
        } else {
            NSLog(@"Other error code: %zd", error.code);
        }
    }];
     */
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
 
    //NSLog(@"torno image picker info %@", info);
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSData *imageData = UIImagePNGRepresentation(image);
    NSData* imageData = UIImageJPEGRepresentation(image, 0.4); //0.4 is the compression rate.
    [_report.images addObject:imageData];

    // guardar foto a carpeta
    [self insertImage:image intoAlbumNamed:@"Mosquito Alert"];
    
    
    
    [_collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark Photos

- (void)insertImage:(UIImage *)image intoAlbumNamed:(NSString *)albumName {
    //Fetch a collection in the photos library that has the title "albumNmame"
    PHAssetCollection *collection = [self fetchAssetCollectionWithAlbumName: albumName];
    
    if (collection == nil) {
        //If we were unable to find a collection named "albumName" we'll create it before inserting the image
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle: albumName];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Error inserting image into album: %@", error.localizedDescription);
            }
            
            if (success) {
                //Fetch the newly created collection (which we *assume* exists here)
                PHAssetCollection *newCollection = [self fetchAssetCollectionWithAlbumName:albumName];
                [self insertImage:image intoAssetCollection: newCollection];
            }
        }];
    } else {
        //If we found the existing AssetCollection with the title "albumName", insert into it
        [self insertImage:image intoAssetCollection: collection];
    }
}

- (PHAssetCollection *)fetchAssetCollectionWithAlbumName:(NSString *)albumName {
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    //Provide the predicate to match the title of the album.
    fetchOptions.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"title == '%@'", albumName]];
    
    //Fetch the album using the fetch option
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    
    //Assuming the album exists and no album shares it's name, it should be the only result fetched
    return fetchResult.firstObject;
}

- (void)insertImage:(UIImage *)image intoAssetCollection:(PHAssetCollection *)collection {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //This will request a PHAsset be created for the UIImage
        PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAssetFromImage:image];
        
        //Create a change request to insert the new PHAsset in the collection
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        
        //Add the PHAsset placeholder into the creation request.
        //The placeholder is used because the actual PHAsset hasn't been created yet
        if (request != nil && creationRequest.placeholderForCreatedAsset != nil) {
            [request addAssets: @[creationRequest.placeholderForCreatedAsset]];
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error inserting image into asset collection: %@", error.localizedDescription);
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:[LocalText with:@"back"]
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
