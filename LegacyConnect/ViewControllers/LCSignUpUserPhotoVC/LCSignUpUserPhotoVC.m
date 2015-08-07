//
//  LCSignUpUserPhotoVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSignUpUserPhotoVC.h"
#import "LCWebServiceManager.h"

@interface LCSignUpUserPhotoVC ()

@end

@implementation LCSignUpUserPhotoVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
  self.imageView.clipsToBounds = YES;
  _firstNameLabel.text = [LCDataManager sharedDataManager].firstName;
  
  // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)takeAPhoto:(id)sender
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
  imagePicker.allowsEditing = TRUE;
  [self presentViewController:imagePicker animated:YES completion:nil];
}


- (IBAction)chooseAPhotoFromLibrary:(id)sender
{
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  imagePicker.allowsEditing = TRUE;
  [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - ImagePicker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:nil];
  self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
  
  [LCAPIManager UploadImage:_imageView.image ofUser:@"6875"
                withSuccess:^(id response) {
                  [self saveUserDetailsToDataManagerFromResponse:response];
                  [self performSegueWithIdentifier:@"chooseCauses" sender:self];
    
                } andFailure:^(NSString *error) {
    
                }];
}

//- (void)performImageUpload
//{
//  LCWebServiceManager *webService = [[LCWebServiceManager alloc] init];
//  NSString *imageData= [self encodeImageToBase64String:_imageView.image];
//  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[[LCDataManager sharedDataManager].userID,imageData,[self contentTypeForImageData:_imageView.image]] forKeys:@[kUserIDKey, kUserImageData, kUserimageExtension]];
//  NSString *url = [NSString stringWithFormat:@"%@%@", kBaseURL, kUploadUserImageURL];
//  [webService performPostOperationWithUrl:url withParameters:dict withSuccess:^(id response)
//   {
//     if([response[kResponseCode] isEqualToString:kStatusCodeFailure])
//     {
//       [LCUtilityManager showAlertViewWithTitle:nil andMessage:response[kResponseMessage]];
//     }
//     else
//     {
//       NSLog(@"%@",response);
//       [self saveUserDetailsToDataManagerFromResponse:response];
//       [self performSegueWithIdentifier:@"chooseCauses" sender:self];
//     }
//   } andFailure:^(NSString *error)
//  {
//    [LCUtilityManager showAlertViewWithTitle:nil andMessage:error];
//   }];
//}

- (void)saveUserDetailsToDataManagerFromResponse:(id)response
{
  NSDictionary *userInfo = response[kResponseData];
  [LCDataManager sharedDataManager].avatarUrl = userInfo[kFBAvatarImageUrlKey];
}


- (NSString *)encodeImageToBase64String:(UIImage *)image
{
  return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


- (NSString *)contentTypeForImageData:(UIImage*)image
{
  NSData *imageData =UIImagePNGRepresentation(image);
  //  NSData *imageData =UIImageJPEGRepresentation (image,0);
  
  uint8_t c;
  [imageData getBytes:&c length:1];
  
  switch (c)
  {
    case 0xFF:
      return @"jpeg";;
    case 0x89:
      return @"png";;
    case 0x47:
      return @"gif";;
    case 0x49:
    case 0x4D:
      return @"tiff";;
    case 0x42:
      return @"@bmp";;
  }
  return nil;
}


#pragma mark - Other methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if ([navigationController.viewControllers count] == 3)
  {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    UIView *plCropOverlay = [[[viewController.view.subviews objectAtIndex:1]subviews] objectAtIndex:0];
    
    plCropOverlay.hidden = YES;
    
    int position = screenHeight/5;
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
                           CGRectMake(10.0f, position, screenWidth-20.0f, screenWidth-20.0f)];
    [path2 setUsesEvenOddFillRule:YES];
    
    [circleLayer setPath:[path2 CGPath]];
    
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, screenWidth, screenHeight-72) cornerRadius:0];
    
    [path appendPath:path2];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.8;
    [viewController.view.layer addSublayer:fillLayer];
    
    UILabel *moveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, screenWidth, 50)];
    [moveLabel setText:@"Move and Scale"];
    [moveLabel setTextAlignment:NSTextAlignmentCenter];
    [moveLabel setTextColor:[UIColor whiteColor]];
    [viewController.view addSubview:moveLabel];
  }
}

@end
