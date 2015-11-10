//
//  LCCreateActions.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCActionsDateSelection.h"

typedef enum actionSectionTypes
{
  SECTION_NAME,
  SECTION_ACTIONTYPE,
  SECTION_DATE,
  SECTION_WEBSITE,
  SECTION_HEADER,
  SECTION_ABOUT
} sectionType;

@interface LCCreateActions : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, actionDateDelegate>

@property(nonatomic, retain)LCInterest *selectedInterest;

- (IBAction)cancelAction;
- (IBAction)nextButtonAction;

@end
