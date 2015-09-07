//
//  LCInterestsTableViewCell.h
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCInterestsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *interestImageView;
@property (weak, nonatomic) IBOutlet UILabel *interestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestFollowersCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *interestFollowButton;
@property (weak, nonatomic) LCInterest *interest;
@end
