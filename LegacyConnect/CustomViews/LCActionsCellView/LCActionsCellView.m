//
//  LCActionsCellView.m
//  LegacyConnect
//
//  Created by Akhil K C on 9/28/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCActionsCellView.h"
#import "NSDate+TimeAgo.h"

static NSString *kActionsDateFormat = @"MMM dd yyyy hh:mm a";
static NSString *kEventPlaceholderImage = @"event_placeholder";
static NSString *kSupportedByPeople = @"Supported by %@ People";

@interface LCActionsCellView ()
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportersCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerPhotoImageView;

@end

@implementation LCActionsCellView

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setEvent:(LCEvent *)event
{
  _event = event;
  [self.eventNameLabel setText:_event.name];
  NSString * displayDate = [LCUtilityManager getDateFromTimeStamp:_event.time WithFormat:kActionsDateFormat];
  [self.eventTimeLabel setText:displayDate];
  [self.supportersCountLabel setText:[NSString stringWithFormat:kSupportedByPeople,_event.supportersCount]];
  [self.headerPhotoImageView sd_setImageWithURL:[NSURL URLWithString:_event.headerPhoto] placeholderImage:[UIImage imageNamed:kEventPlaceholderImage]];
}

@end
