//
//  LCProfileEditVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 9/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQUIView+IQKeyboardToolbar.h"

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

@interface LCProfileEditVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
  
  
  IBOutlet UIView *profilePicBorderView;
  IBOutlet UIButton *buttonSave;
  
  IBOutlet UIView *navigationBar;
  
  UITextField *txt_firstName;
  UITextField *txt_lastName;
  UITextField *txt_location;
  UITextField *txt_birthday;
  UITextField *txt_gender;
  
  
  UIDatePicker *datePicker;
  NSString *dobTimeStamp;
  
  UIPickerView *genderPicker;
  NSArray *genderTypes;
  
  UIImage *profilePicPlaceholder;
}

@property(weak, nonatomic) IBOutlet UIImageView *profilePic;
@property(weak, nonatomic) IBOutlet UIImageView *headerBGImage;
@property(nonatomic) imageEditState avatarPicState;
@property(nonatomic) imageEditState headerPicState;
@property(strong, nonatomic) UIImage *actualHeaderImage;
@property(strong, nonatomic) UIImage *actualAvatarImage;


@property(nonatomic, retain)LCUserDetail *userDetail;

- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)editProfilePicAction:(id)sender;
- (IBAction)editHeaderBGAction:(id)sender;
- (void)validateFields;

@end
