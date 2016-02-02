//
//  LCActionHelper.m
//  LegacyConnect
//
//  Created by qbuser on 02/02/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCActionHelper.h"

@implementation LCActionHelper

+ (NSString*)getEventDateInfo:(LCEvent*)eventObject
{
  NSString * eventDateInfo = kEmptyStringValue;
  if (![LCUtilityManager isEmptyString:eventObject.startDate]) {
     eventDateInfo = [LCUtilityManager getDateFromTimeStamp:eventObject.startDate WithFormat:@"MMM dd yyyy"];
    if (![LCUtilityManager isEmptyString:eventObject.endDate]) {
      eventDateInfo = [NSString stringWithFormat:@"%@ to %@",eventDateInfo,[LCUtilityManager getDateFromTimeStamp:eventObject.endDate WithFormat:@"MMM dd yyyy"]];
    }
  }
  return eventDateInfo;
}

+ (LCActionsHeader*)getActionsHeaderForSection:(NSInteger)section
{
  NSString * headerText;
  if (section == 0) {
    headerText = NSLocalizedString(@"details_caps", nil);
  } else {
    headerText = NSLocalizedString(@"comments_caps", nil);
  }
  LCActionsHeader * headerView = [[[NSBundle mainBundle] loadNibNamed:@"LCActionsHeader" owner:self options:nil] firstObject];
  [headerView.headerTextLabel setText:headerText];
  return headerView;
}


@end
