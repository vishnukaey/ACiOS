//
//  LCChooseInterestCVC.h
//  LegacyConnect
//
//  Created by Vishnu on 8/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChooseInterestCVC : UICollectionViewCell
@property (strong, nonatomic) LCInterest *interest;
@property (weak, nonatomic) IBOutlet UIImageView *interestsImageView;
@property (weak, nonatomic) IBOutlet UILabel *interestNameLabel;

- (void)setCellSelected :(BOOL)selected;
@end
