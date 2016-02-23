//
//  LCSingleInterestBC.h
//  LegacyConnect
//
//  Created by Jijo on 1/13/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCSingleInterestBC : UIViewController
{
  __weak IBOutlet UILabel *interestName;
  __weak IBOutlet UILabel *interestDescription;
  __weak IBOutlet UIImageView *interestImage;
  __weak IBOutlet UIImageView *interestBGImage;
  __weak IBOutlet UIButton *interestFollowButton;
  __weak IBOutlet UILabel *actionsCount;
  __weak IBOutlet UILabel *followersCount;

}

@property(nonatomic, strong) LCInterest *interest;
@property(nonatomic, strong) IBOutlet LCNavigationBar *navigationBarLC;

- (void) updateInterestDetails;

@end
