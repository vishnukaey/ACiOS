//
//  LCConnectFriendsVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCConnectFriendsVC : UIViewController
@property (weak , nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet  NSLayoutConstraint *customNavigationHeight;

-(IBAction)buttonActions :(UIButton *)sender;

@end
