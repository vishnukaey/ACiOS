//
//  LCSignUpUserPhotoVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSKImageCropper/RSKImageCropper.h>

@interface LCSignUpUserPhotoVC : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@end
