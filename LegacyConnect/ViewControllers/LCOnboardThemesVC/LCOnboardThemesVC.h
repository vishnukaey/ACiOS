//
//  LCChooseCausesVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCOnboardThemesVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *themesTable;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (assign, nonatomic) BOOL fromFacebook;
@end
