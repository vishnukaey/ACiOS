//
//  LCRequestNotificationTVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/30/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCRequestNotificationTVC.h"

@implementation LCRequestNotificationTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setRequest:(LCRequest *)request
{
  _request = request;
  _thumbImage.layer.cornerRadius = _thumbImage.frame.size.width / 2;
  _thumbImage.clipsToBounds = YES;
  [_nameLabel setText:[NSString stringWithFormat:@"%@ %@",[LCUtilityManager performNullCheckAndSetValue:request.firstName], [LCUtilityManager performNullCheckAndSetValue:request.lastName]]];
  if(request.requestStatus)
  {
    [_responseView setHidden:NO];
    [_responseLabel setText:@""];
    if([request.requestStatus isEqualToString:@"1"])
    {
      [_responseLabel setText:@"Accepted"];
    }
    else
    {
      [_responseLabel setText:@"Rejected"];
    }
  }
  else
  {
    [_responseView setHidden:YES];
  }
  
  if([request.type isEqualToString:@"event"])
  {
    [_detailLabel setText:@"Invited you to an Event"];
    [_typeDetailLabel setText:[NSString stringWithFormat:@"%@",request.eventName]];
    [_thumbImage sd_setImageWithURL:[NSURL URLWithString:request.eventImage] placeholderImage:nil];
  }
  else
  {
    [_detailLabel setText:[NSString stringWithFormat: @"%@",[LCUtilityManager performNullCheckAndSetValue:request.addressCity]]];
    [_thumbImage sd_setImageWithURL:[NSURL URLWithString:request.avatarURL] placeholderImage:nil];
  }
}

- (IBAction)acceptRequest:(id)sender
{
  [self setUserInteractionEnabled:NO];
  self.alpha = 0.5;
  [LCAPIManager acceptFriendRequest:_request.friendID withSuccess:^(id response)
  {
    [self setUserInteractionEnabled:YES];
    self.alpha = 1.0;
    _request.requestStatus = @"1";
    [self.delegate requestActionedForRequest:_request];
  } andFailure:^(NSString *error)
  {
    [self setUserInteractionEnabled:YES];
    self.alpha = 1.0;
  }];
}
- (IBAction)rejectRequest:(id)sender
{
  [self setUserInteractionEnabled:NO];
  self.alpha = 0.5;
  [LCAPIManager rejectFriendRequest:_request.friendID withSuccess:^(id response)
   {
     [self setUserInteractionEnabled:YES];
     self.alpha = 1.0;
     _request.requestStatus = @"2";
     [self.delegate requestActionedForRequest:_request];
   } andFailure:^(NSString *error)
   {
     [self setUserInteractionEnabled:YES];
     self.alpha = 1.0;
   }];
}


@end
