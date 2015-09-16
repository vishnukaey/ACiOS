//
//  LCSignUpUserPhotoVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSignUpUserPhotoVC.h"
#import "RSKImageCropViewController.h"

@interface LCSignUpUserPhotoVC ()
@property (weak, nonatomic) IBOutlet UIButton *chooseFromLibraryBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoNoteYPosition;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *welcomeNoteYPosition;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *takePhotoContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *takePhotoContainerWidth;
@end

@implementation LCSignUpUserPhotoVC

- (void)initialUISetUp
{
  [self.chooseFromLibraryBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
  [self.chooseFromLibraryBtn.layer setBorderWidth:1.0f];
  [self.chooseFromLibraryBtn.layer setCornerRadius:5];
  if (IS_IPHONE_4)
  {
    self.infoNoteYPosition.constant = 4.0f;
    self.welcomeNoteYPosition.constant = 0.0f;
    self.takePhotoContainerHeight.constant = 250.0f;
    self.takePhotoContainerWidth.constant = 250.0f;
  }
  else if (IS_IPHONE_5)
  {
    self.welcomeNoteYPosition.constant = 5.0f;
    self.infoNoteYPosition.constant = 15.0f;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _firstNameLabel.text = [NSString stringWithFormat:@"Welcome, %@ !",[LCDataManager sharedDataManager].firstName];
  [self initialUISetUp];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)takeAPhoto:(id)sender
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  imagePicker.allowsEditing = false;
  
  [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)chooseAPhotoFromLibrary:(id)sender
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  imagePicker.allowsEditing = false;
  
  
  [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ImagePicker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:^{
    UIImage * originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:originalImage];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
  }];
}

- (void)saveUserDetailsToDataManagerFromResponse:(id)response
{
  NSDictionary *userInfo = response[kResponseData];
  [LCDataManager sharedDataManager].avatarUrl = userInfo[kFBAvatarImageUrlKey];
}

#pragma mark - Other methods
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//  if ([navigationController.viewControllers count] == 3)
//  {
//    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
//    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    
//    UIView *plCropOverlay = [[[viewController.view.subviews objectAtIndex:1]subviews] objectAtIndex:0];
//    
//    plCropOverlay.hidden = YES;
//    
//    int position = screenHeight/5;
//    
//    CAShapeLayer *circleLayer = [CAShapeLayer layer];
//    
//    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
//                           CGRectMake(10.0f, position, screenWidth-20.0f, screenWidth-20.0f)];
//    [path2 setUsesEvenOddFillRule:YES];
//    
//    [circleLayer setPath:[path2 CGPath]];
//    
//    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, screenWidth, screenHeight-72) cornerRadius:0];
//    
//    [path appendPath:path2];
//    [path setUsesEvenOddFillRule:YES];
//    
//    CAShapeLayer *fillLayer = [CAShapeLayer layer];
//    fillLayer.path = path.CGPath;
//    fillLayer.fillRule = kCAFillRuleEvenOdd;
//    fillLayer.fillColor = [UIColor colorWithRed:40.0f/255 green:40.0f/255 blue:40.0f/255 alpha:.75f].CGColor;
//    fillLayer.opacity = 1;
//    [viewController.view.layer addSublayer:fillLayer];
//    
//    UIView * topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 65)];
//    [topBar setBackgroundColor:[UIColor colorWithRed:40.0f/255 green:40.0f/255 blue:40.0f/255 alpha:1]];
//    
//    UILabel *moveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, screenWidth, 50)];
//    [moveLabel setText:@"MOVE AND SCALE"];
//    [moveLabel setFont:[UIFont fontWithName:@"Gotham-Bold" size:12.0f]];
//    [moveLabel setTextAlignment:NSTextAlignmentCenter];
//    [moveLabel setTextColor:[UIColor whiteColor]];
//    [topBar addSubview:moveLabel];
//    
//    [viewController.view addSubview:topBar];
//  }
//}

- (void)invokeUploadImageAPIWithImage:(UIImage*)croppedImage
{
  [LCAPIManager uploadImage:croppedImage ofUser:[LCDataManager sharedDataManager].userID
                withSuccess:^(id response) {
                  [self saveUserDetailsToDataManagerFromResponse:response];
                  [self performSegueWithIdentifier:@"chooseCauses" sender:self];
                  
                } andFailure:^(NSString *error) {
                  
                }];

}

#pragma mark - RSKImageCropViewControllerDelegate implementation
// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
  [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
  [self.navigationController popViewControllerAnimated:YES];
  [self invokeUploadImageAPIWithImage:croppedImage];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
  [self.navigationController popViewControllerAnimated:YES];
  [self invokeUploadImageAPIWithImage:croppedImage];
}


@end
