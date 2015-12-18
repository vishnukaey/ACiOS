//
//  LCHorizontalInterestCollectionCell.h
//  LegacyConnect
//
//  Created by Jijo on 12/18/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHorizontalInterestCollectionCell : UICollectionViewCell

@property(nonatomic, retain)IBOutlet UIImageView *checkMark;
@property(nonatomic, retain)IBOutlet UIImageView *interestLogo;
@property(nonatomic, retain)IBOutlet UILabel *interestName;
@property(nonatomic, retain)LCInterest *interest;
- (void)setInterestSelected :(BOOL)isSelected;

@end
