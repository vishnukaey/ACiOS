//
//  LCRequestNotificationTVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LCRequestNotificationTVCDelegate <NSObject>

- (void)requestActionedForRequest:(LCRequest *)request;

@end

@interface LCRequestNotificationTVC : UITableViewCell
@property (nonatomic, unsafe_unretained) NSObject <LCRequestNotificationTVCDelegate> *delegate;
@property (weak, nonatomic) LCRequest *request;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *responseView;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight;
@end
