//
//  LCActionsDateSelection.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol actionDateDelegate <NSObject>

- (void)actionDateSelected :(NSDate *)start :(NSDate *)end;

@end

@interface LCActionsDateSelection : UIViewController
{
  IBOutlet UISegmentedControl *startEndSegment;
  IBOutlet UIDatePicker *datePicker;
  IBOutlet UIButton *removeButton;
}

@property(nonatomic, retain)id delegate;
@property(nonatomic, retain)NSDate *startDate, *endDate;

@end
