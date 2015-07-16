//
//  LCSignupViewController.h
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLoginTextField.h"

@interface LCSignupViewController : UIViewController
{
  LCUser *user;
}
@property (weak, nonatomic) IBOutlet LCLoginTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet LCLoginTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet LCLoginTextField *emailTextField;
@property (weak, nonatomic) IBOutlet LCLoginTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet LCLoginTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@end
