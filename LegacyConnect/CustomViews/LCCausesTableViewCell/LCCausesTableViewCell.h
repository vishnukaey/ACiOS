//
//  LCCausesTableViewCell.h
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCausesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *causeImageView;
@property (weak, nonatomic) IBOutlet UILabel *causeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *causeSupportersCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *causeSupportButton;
@property (weak, nonatomic) IBOutlet UIView *imageContainer;
@property (weak, nonatomic) LCCause *cause;
@end
