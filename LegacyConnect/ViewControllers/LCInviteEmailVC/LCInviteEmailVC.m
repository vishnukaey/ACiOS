//
//  LCInviteEmailVC.m
//  LegacyConnect
//
//  Created by Kaey on 18/03/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCInviteEmailVC.h"


@interface LCInviteEmailVC ()

@end

NSString *const kPlaceholderText = @"Type email addresses here separated by commas";

@implementation LCInviteEmailVC

- (void)viewDidLoad
{
  if(_emailsArray.count>0)
  {
    _emailTextView.text = [_emailsArray componentsJoinedByString:@", "];
    _emailTextView.textColor = [UIColor blackColor];
  }
  else
  {
    _emailTextView.text = kPlaceholderText;
    _emailTextView.textColor = [UIColor lightGrayColor];
  }
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
  if([_emailTextView.text isEqualToString:kPlaceholderText])
  {
    _emailTextView.text = kEmptyStringValue;
  }
  _emailTextView.textColor = [UIColor blackColor];
  return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
  
  if(_emailTextView.text.length == 0)
  {
    _emailTextView.textColor = [UIColor lightGrayColor];
    _emailTextView.text = kPlaceholderText;
    [_emailTextView resignFirstResponder];
  }
}

-(IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButtonTapped:(id)sender
{
  NSArray *emails = [_emailTextView.text componentsSeparatedByString:@","];
  [_emailsArray removeAllObjects];
  [_emailsArray addObjectsFromArray:emails];
  NSLog(@"count %ld",_emailsArray.count);
  [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}




@end
