//
//  LCChangePasswordViewController.h
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChangePasswordViewController : UIViewController
{
  __weak IBOutlet UITextField *newPasswordField;
  __weak IBOutlet UITextField *confirmPasswordField;
  __weak IBOutlet UIButton *saveButton;
}
@end
