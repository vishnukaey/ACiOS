//
//  LCProfileEditVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 9/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum profileSectionTypes
{
  SECTION_NAME,
  SECTION_LOCATION,
  SECTION_HEADER_BACKGROUND,
  SECTION_BIRTHDAY,
  SECTION_GENDER
} sectionType;

@interface LCProfileEditVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
  
  IBOutlet UIImageView *profilePic;
  
  
  UITextField *txt_firstName;
  UITextField *txt_lastName;
  UITextField *txt_location;
  UIImageView *img_headerBG;
  UITextField *txt_birthday;
  UITextField *txt_gender;
  
  
  UIDatePicker *datePicker;
  NSString *dobTimeStamp;
  
}


@property(nonatomic, retain)LCUserDetail *userDetail;

- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)editPictureAction:(id)sender;

@end
