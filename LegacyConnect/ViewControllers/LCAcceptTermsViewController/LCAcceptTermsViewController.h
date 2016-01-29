//
//  LCAcceptTermsViewController.h
//  LegacyConnect
//
//  Created by Kaey on 29/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAcceptTermsViewController : UIViewController
@property (nonatomic, strong) NSDictionary *userDict;
@property (nonatomic, weak) IBOutlet UIButton *readTermsButton;
@property (nonatomic, weak) IBOutlet UIButton *acceptTermsButton;
@end
