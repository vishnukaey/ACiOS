//
//  LCActionsImageEditer.m
//  LegacyConnect
//
//  Created by Jijo on 11/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCActionsImageEditer.h"

@implementation LCActionsImageEditer

- (void)presentImageEditorOnController :(UIViewController *)controller witImage:(UIImage *)image
{
  presentingController = controller;
  [self showImageCropViewWithImage:image];
}

- (void) showImageCropViewWithImage:(UIImage *)image {
  
  RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
  imageCropVC.delegate = self;
  imageCropVC.cropMode = RSKImageCropModeCustom;
  imageCropVC.dataSource = self;
  
  [presentingController presentViewController:imageCropVC animated:YES completion:nil];
  [self customizeCropViewUI:imageCropVC];
}

- (void)customizeCropViewUI:(RSKImageCropViewController*)imageCropVC {
  
  [imageCropVC.view setAlpha:1];
  [imageCropVC.cancelButton setHidden:true];
  [imageCropVC.chooseButton setHidden:true];
  [imageCropVC.moveAndScaleLabel setHidden:true];
  
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  UIView * topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(presentingController.view.frame), statusBarViewRect.size.height+presentingController.navigationController.navigationBar.frame.size.height)];
  [topBar setBackgroundColor:[UIColor colorWithRed:40.0f/255 green:40.0f/255 blue:40.0f/255 alpha:.9]];
  
  [topBar setUserInteractionEnabled:true];
  CGFloat btnY = statusBarViewRect.size.height+presentingController.navigationController.navigationBar.frame.size.height -38;
  
  UIButton * cancelBtn = [self getCancelButtonForImageCropView:imageCropVC andButtonyPosition:btnY];
  UIButton *doneBtn = [self getDoneButtonForImageCropView:imageCropVC buttonyPosition:btnY andTopBarFrame:topBar.frame];
  
  CGFloat screenWidth = CGRectGetWidth(topBar.frame);
  UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, btnY, screenWidth, 30)];
  [titleLabel setTextAlignment:NSTextAlignmentCenter];
  [titleLabel setTextColor:[UIColor whiteColor]];
  [titleLabel setText:NSLocalizedString(@"move_and_scale", nil)];
  [titleLabel setFont:[UIFont fontWithName:@"Gotham-Bold" size:12.0f]];
  [titleLabel setUserInteractionEnabled:NO];
  
  [topBar addSubview:cancelBtn];
  [topBar addSubview:doneBtn];
  [topBar addSubview:titleLabel];
  [imageCropVC.view addSubview:topBar];
}

- (UIButton*)getCancelButtonForImageCropView:(RSKImageCropViewController*)cropView andButtonyPosition:(CGFloat)btnY
{
  CGFloat btnWidth = 75;

  UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnY, btnWidth, 30)];
  [cancelBtn setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
  [cancelBtn.titleLabel setTextColor:[UIColor whiteColor]];
  [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:17.0f]];
  for (id target in cropView.cancelButton.allTargets) {
    NSArray *actions = [cropView.cancelButton actionsForTarget:target
                                                  forControlEvent:UIControlEventTouchUpInside];
    for (NSString *action in actions) {
      [cancelBtn addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  return cancelBtn;
}

- (UIButton*)getDoneButtonForImageCropView:(RSKImageCropViewController*)cropView buttonyPosition:(CGFloat)btnY andTopBarFrame:(CGRect)topBarFrame
{
  CGFloat btnWidth = 75;
  UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(topBarFrame) - btnWidth, btnY, btnWidth, 30)];
  [doneBtn setTitle:NSLocalizedString(@"done", @"done button title") forState:UIControlStateNormal];
  [doneBtn.titleLabel setTextColor:[UIColor whiteColor]];
  [doneBtn.titleLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:17.0f]];
  for (id target in cropView.chooseButton.allTargets) {
    NSArray *actions = [cropView.chooseButton actionsForTarget:target
                                                  forControlEvent:UIControlEventTouchUpInside];
    for (NSString *action in actions) {
      [doneBtn addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  return doneBtn;
}

#pragma mark - RSKImageCropViewControllerDatasource

// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
  CGSize maskSize;
  maskSize = CGSizeMake(presentingController.view.frame.size.width, 165);
  
  
  CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
  CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
  
  CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                               (viewHeight - maskSize.height) * 0.5f,
                               maskSize.width,
                               maskSize.height);
  return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
  CGRect rect = controller.maskRect;
  UIBezierPath *rectangle = [UIBezierPath bezierPathWithRect:rect];
  
  return rectangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
  // If the image is not rotated, then the movement rect coincides with the mask rect.
  return controller.maskRect;
}




#pragma mark - RSKImageCropViewControllerDelegate
// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
  [presentingController dismissViewControllerAnimated:YES completion:nil];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
  [presentingController dismissViewControllerAnimated:YES completion:^{
    [self.delegate RSKFinishedPickingImage:croppedImage];
  }];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
  [presentingController dismissViewControllerAnimated:YES completion:^{
    [self.delegate RSKFinishedPickingImage:croppedImage];
  }];
}

@end
