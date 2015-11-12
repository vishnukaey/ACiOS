//
//  LCEditActionController.h
//  LegacyConnect
//
//  Created by Jijo on 11/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//
#import "LCActionsForm.h"
#import "LCActionsImageEditer.h"

@interface LCEditActions :NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, LCActionFormDelegate, UITextViewDelegate, LCActionsImageEditerDelegate>
{
  BOOL headerImageEdited;
  LCActionsImageEditer *imageCroper;
}

@property(nonatomic, weak)LCActionsForm *actionForm;
@property(nonatomic, retain)LCEvent *eventToEdit;
@end
