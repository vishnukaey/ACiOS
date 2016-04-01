//
//  LCForgotPasswordViewController.h
//  LegacyConnect
//
//  Created by Govind_Office on 15/07/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol forgotPasswordDelegate <NSObject>

- (void)forgotPasswordRequestSent:(NSString *)user;

@end


@interface LCForgotPasswordViewController : UIViewController


@property (nonatomic, unsafe_unretained) NSObject <forgotPasswordDelegate> *delegate;
@property (nonatomic,weak) IBOutlet UITextField *emailTextField;


@end
