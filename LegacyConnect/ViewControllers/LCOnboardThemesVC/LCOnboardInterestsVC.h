//
//  LCOnboardInterestsVC.h
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCollectionViewController.h"

@interface LCOnboardInterestsVC : LCCollectionViewController

@property (strong, nonatomic) LCTheme *theme;
@property (weak, nonatomic) IBOutlet UILabel *navBarTitle;

@end
