//
//  LCProfileImageEditor.h
//  LegacyConnect
//
//  Created by Akhil K C on 12/28/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "RSKImageCropViewController.h"

@protocol LCActionsImageEditerDelegate <NSObject>

- (void)RSKFinishedPickingProfileImage :(UIImage *)image;
- (void)RSKFinishedPickingHeaderImage :(UIImage *)image;

@end


@interface LCProfileImageEditor : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDataSource, RSKImageCropViewControllerDelegate>
{
  UIViewController *presentingController;
  BOOL isProfilePic;
}

@property(nonatomic, weak)id delegate;

- (void)showImagePickerOnController:(UIViewController*)controller withSource:(UIImagePickerControllerSourceType) imageSource isEditingProfilePic:(BOOL) isEditingProfilePic;
- (void)presentImageEditorOnController :(UIViewController *)controller withImage:(UIImage *)image isEditingProfilePic:(BOOL) isEditingProfilePic;

@end

