//
//  LCSignUpUserPhotoVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSignUpUserPhotoVC : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak,nonatomic) IBOutlet UIImageView *imageView;
@end
