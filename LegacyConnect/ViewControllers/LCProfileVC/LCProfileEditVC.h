//
//  LCProfileEditVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 9/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSKImageCropper/RSKImageCropper.h>

typedef enum profileSectionTypes
{
  SECTION_NAME,
  SECTION_LOCATION,
  SECTION_BIRTHDAY,
  SECTION_GENDER
} sectionType;

typedef enum imageEditStates
{
  IMAGE_REMOVED,
  IMAGE_EDITED,
  IMAGE_UNTOUCHED
} imageEditState;

@interface LCProfileEditVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, RSKImageCropViewControllerDataSource, RSKImageCropViewControllerDelegate>
{
  
  IBOutlet UIImageView *profilePic;
  IBOutlet UIView *profilePicBorderView;
  IBOutlet UIButton *buttonSave;
  IBOutlet UIImageView *headerBGImage;
  
  
  UITextField *txt_firstName;
  UITextField *txt_lastName;
  UITextField *txt_location;
  UITextField *txt_birthday;
  UITextField *txt_gender;
  
  
  UIDatePicker *datePicker;
  NSString *dobTimeStamp;
  
  UIPickerView *genderPicker;
  NSArray *genderTypes;
  
  BOOL isEditingProfilePic;
  imageEditState avatarPicState, headerPicState;
  UIImage *actualHeaderImage, *actualAvatarImage;
  
  UIImage *profilePicPlaceholder;
}


@property(nonatomic, retain)LCUserDetail *userDetail;

- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)editProfilePicAction:(id)sender;
- (IBAction)editHeaderBGAction:(id)sender;

@end
