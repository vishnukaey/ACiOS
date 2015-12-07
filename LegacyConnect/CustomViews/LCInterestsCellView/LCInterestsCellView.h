//
//  LCInterestsCellView.h
//  LegacyConnect
//
//  Created by Akhil K C on 9/28/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCInterestsCellView : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *interestNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *interestFollowLabel;
@property (strong, nonatomic) IBOutlet UIImageView *interestsBG;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;//for select interest in create post flow
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkButtonTrailing;

- (void)setData: (LCInterest *) interest;
@end
