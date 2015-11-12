//
//  LCActionsDateSelection.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCActionsDateSelection.h"


@implementation LCActionsDateSelection
@synthesize delegate;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  if (_startDate) {
    datePicker.date = _startDate;
  }
  removeButton.layer.cornerRadius = 5;
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (IBAction)doneButtonAction
{
  [delegate actionDateSelected:_startDate :_endDate];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backAction
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)removeAction
{
  [delegate actionDateSelected:nil :nil];
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - datepicker action
- (IBAction)dateIsChanged:(UIDatePicker *)sender{
  if (startEndSegment.selectedSegmentIndex == 0)//start
  {
    _startDate = sender.date;
  }
  else
  {
    _endDate = sender.date;
  }
}

#pragma mark - segment action
- (IBAction)segmentChanged:(UISegmentedControl *)sender{
  if (sender.selectedSegmentIndex == 0)//start
  {
    if (_startDate) {
     [datePicker setDate:_startDate];
    }
  }
  else
  {
    if (_endDate) {
      [datePicker setDate:_endDate];
    }
  }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
