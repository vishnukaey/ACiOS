//
//  LCActionsCellView.m
//  LegacyConnect
//
//  Created by Akhil K C on 9/28/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCActionsCellView.h"
#import "NSDate+TimeAgo.h"

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
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:_event.time.longLongValue/1000];
  NSString *timeAgo = [date timeAgo];
  [self.eventTimeLabel setText:timeAgo];
  [self.supportersCountLabel setText:[NSString stringWithFormat:@"Supported by %@ People",_event.supportersCount]];
  [self.headerPhotoImageView sd_setImageWithURL:[NSURL URLWithString:_event.headerPhoto] placeholderImage:[UIImage imageNamed:@"event_placeholder"]];
}

@end
