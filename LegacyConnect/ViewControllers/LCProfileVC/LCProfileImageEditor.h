//
//  LCProfileImageEditor.h
//  LegacyConnect
//
//  Created by Akhil K C on 12/28/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "RSKImageCropViewController.h"
#import "LCProfileEditVC.h"

@interface LCProfileImageEditor : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDataSource, RSKImageCropViewControllerDelegate>
{
  BOOL isProfilePic;
}

@property(nonatomic, strong)LCProfileEditVC *parentController;

- (void) editProfilePicture;
- (void) editHeaderBackground;

@end

