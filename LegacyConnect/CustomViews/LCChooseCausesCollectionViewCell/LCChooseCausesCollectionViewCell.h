//
//  LCChooseCausesCollectionViewCell.h
//  LegacyConnect
//
//  Created by Vishnu on 7/17/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChooseCausesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *causesImageView;
@property (strong, nonatomic) LCCause *cause;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;
- (void)setCellSelected :(BOOL)selected;
@end
