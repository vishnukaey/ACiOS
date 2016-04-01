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
  [_emailTextView resignFirstResponder];
  NSArray *emails = [_emailTextView.text componentsSeparatedByString:@","];
  if([self validateEmails:emails])
  {
    [_emailsArray removeAllObjects];
    [_emailsArray addObjectsFromArray:emails];
    NSLog(@"count %ld",(unsigned long)_emailsArray.count);
    [self.navigationController popViewControllerAnimated:YES];
  }
}


-(BOOL)validateEmails:(NSArray*)emailsArray
{
  for (NSString *mailID in emailsArray)
  {
    if (![self isValidEmail:mailID])
    {
      [LCUtilityManager showAlertViewWithTitle:@"Invalid Email ID" andMessage:[NSString stringWithFormat:@"%@ is invalid",mailID]];
      return NO;
    }
  }
  return YES;
}


-(BOOL)isValidEmail:(NSString *)checkString
{
  BOOL stricterFilter = NO;
  NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
  NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}




@end
