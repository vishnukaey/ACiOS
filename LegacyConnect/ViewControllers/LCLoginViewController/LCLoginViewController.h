//
//  LCLoginViewController.h
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCWebServiceManager.h"
#import "LCForgotPasswordViewController.h"
#import "LCUpdatePasswordViewController.h"

@interface LCLoginViewController : UIViewController<forgotPasswordDelegate,updatePasswordDelegate>

@property (nonatomic,retain) IBOutlet UITextField *emailTextField;
@property (nonatomic,retain) IBOutlet UITextField *passwordTextField;

@end
