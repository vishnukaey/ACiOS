//
//  LCCreateActions.h
//  LegacyConnect
//
//  Created by Jijo on 11/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//
#import "LCActionsForm.h"
@interface LCCreateActions : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, LCActionFormDelegate>

@property(nonatomic, weak)LCActionsForm *actionForm;
@property(nonatomic, weak)LCInterest *selectedInterest;
@end
