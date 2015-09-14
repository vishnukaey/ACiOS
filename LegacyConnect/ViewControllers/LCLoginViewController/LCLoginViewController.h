//
//  LCLoginViewController.h
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCForgotPasswordViewController.h"
#import "LCUpdatePasswordViewController.h"

@interface LCLoginViewController : UIViewController<forgotPasswordDelegate,updatePasswordDelegate>

@property (nonatomic,weak) IBOutlet UITextField *emailTextField;
@property (nonatomic,weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@end
