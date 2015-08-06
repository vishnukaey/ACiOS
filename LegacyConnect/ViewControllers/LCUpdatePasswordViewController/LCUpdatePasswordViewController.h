//
//  LCUpdatePasswordViewController.h
//  LegacyConnect
//
//  Created by Govind_Office on 15/07/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLoginTextField.h"

@protocol updatePasswordDelegate <NSObject>

- (void)updatePasswordSuccessful;

@end


@interface LCUpdatePasswordViewController : UIViewController


@property (nonatomic,retain) IBOutlet LCLoginTextField *passwordTextField;
@property (nonatomic,retain) IBOutlet LCLoginTextField *confirmPasswordTextField;
@property (nonatomic, unsafe_unretained) NSObject <updatePasswordDelegate> *delegate;

@end
