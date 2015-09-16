//
//  LCSignupViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSignupViewController.h"

@interface LCSignupViewController ()
{
  NSString *dobTimeStamp;
}
@end

@implementation LCSignupViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setDobTextFieldWithInputView];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  _signupButton.enabled = NO;
  [_firstNameTextField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
  [_lastNameTextField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
  [_emailTextField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
  [_passwordTextField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
  [_confirmPasswordTextField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
  [_dobTextField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
  self.navigationController.navigationBarHidden = true;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) setDobTextFieldWithInputView
{
  datePicker = [[UIDatePicker alloc] init];
  datePicker.datePickerMode = UIDatePickerModeDate;
  [datePicker setMaximumDate:[NSDate date]];
  NSString *str =@"1900-01-01";
  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:kDefaultDateFormat];
  NSDate *date = [formatter dateFromString:str];
  [datePicker setMinimumDate:date];
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setYear:1950];
  [components setMonth:1];
  [components setDay:1];
  NSDate *defualtDate = [calendar dateFromComponents:components];
  datePicker.date = defualtDate;
  _dobTextField.inputView = datePicker;
  [self createDatePickerInputAccessoryView];
//  [self createInputAccessoryView];
}


-(void)createDatePickerInputAccessoryView
{
  UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
  accessoryView.barStyle = UIBarStyleBlackTranslucent;
  UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setDateAndDismissDatePickerView:)];
  [doneButton setTintColor:[UIColor whiteColor]];
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDatePickerView:)];
  [cancelButton setTintColor:[UIColor whiteColor]];
  [accessoryView setItems:[NSArray arrayWithObjects:cancelButton,flexSpace, doneButton, nil] animated:NO];
  [self.dobTextField setInputAccessoryView:accessoryView];
}


-(void)createInputAccessoryView
{
  UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
  accessoryView.barStyle = UIBarStyleBlackTranslucent;
  UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setDateAndDismissDatePickerView:)];
  [doneButton setTintColor:[UIColor whiteColor]];
  UIBarButtonItem *shiftLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(dismissDatePickerView:)];
  UIBarButtonItem *shiftRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(dismissDatePickerView:)];
  [shiftLeft setTintColor:[UIColor whiteColor]];
   [shiftRight setTintColor:[UIColor whiteColor]];
  [accessoryView setItems:[NSArray arrayWithObjects:shiftLeft,shiftRight,flexSpace, doneButton, nil] animated:NO];
  [self.firstNameTextField setInputAccessoryView:accessoryView];
}

- (void) setDateAndDismissDatePickerView:(id)sender
{
  [_dobTextField resignFirstResponder];
  [self updateTextFieldWithDate:self];
}

- (void)dismissDatePickerView:(id)sender
{
  [_dobTextField resignFirstResponder];
}


-(void) updateTextFieldWithDate:(id) picker
{
  dobTimeStamp = [LCUtilityManager getTimeStampStringFromDate:[datePicker date]];
  _dobTextField.text = [LCUtilityManager getDateFromTimeStamp:dobTimeStamp WithFormat:@"MM/dd/yyyy"];
}


- (IBAction)cancelButtonTapped:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:NO];
}


- (IBAction)nextButtonTapped:(id)sender
{
  if([LCUtilityManager validateEmail:_emailTextField.text])
  {
    [self registerUserOnline];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"invalid_mail_address", @"")];
  }

}


- (void)registerUserOnline
{
  NSString *dob = [LCUtilityManager getDateFromTimeStamp:dobTimeStamp WithFormat:@"dd-MM-yyyy"];
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[self.firstNameTextField.text,self.lastNameTextField.text,self.emailTextField.text,self.passwordTextField.text,dob] forKeys:@[kFirstNameKey, kLastNameKey, kEmailKey, kPasswordKey, kDobKey]];
  [LCAPIManager registerNewUser:dict withSuccess:^(id response) {
    NSLog(@"%@",response);
    [LCUtilityManager saveUserDetailsToDataManagerFromResponse:response];
    [LCUtilityManager saveUserDefaultsForNewUser];
    [self performSegueWithIdentifier:@"selectPhoto" sender:self];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
}


- (void)saveUserAcessTokenAndUserIDFromResponse:(id)response
{
  NSDictionary *userInfo = response[kResponseData];
  [LCDataManager sharedDataManager].userID = userInfo[kUserIDKey];
  [LCDataManager sharedDataManager].userToken = userInfo[kAccessTokenKey];
}


- (void)textFieldDidChange:(id)sender
{
  if(_firstNameTextField.text.length!=0 && _lastNameTextField.text.length!=0 && _emailTextField.text.length!=0 && _passwordTextField.text.length!=0 && _confirmPasswordTextField.text.length!=0 && _dobTextField.text.length!=0 )
  {
    _signupButton.enabled = YES;
  }
  else
  {
    _signupButton.enabled = NO;
  }
}
  
  
@end
