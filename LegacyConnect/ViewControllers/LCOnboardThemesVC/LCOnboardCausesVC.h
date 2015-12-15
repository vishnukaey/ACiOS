//
//  LCOnboardCausesVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCollectionViewController.h"

@interface LCOnboardCausesVC : LCCollectionViewController

  @property (strong, nonatomic) LCInterest *interest;
  @property (weak, nonatomic) IBOutlet UILabel *navBarTitle;

@end
