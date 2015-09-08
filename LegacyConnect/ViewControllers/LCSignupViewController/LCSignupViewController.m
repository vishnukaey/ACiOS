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
  [self createInputAccessoryView];
}


-(void)createInputAccessoryView
{
  UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
  accessoryView.barStyle = UIBarStyleBlackTranslucent;
  UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setDateAndDismissDatePickerView:)];
  [doneButton setTintColor:[UIColor whiteColor]];
  UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDatePickerView:)];
  [cancelButton setTintColor:[UIColor whiteColor]];
  [accessoryView setItems:[NSArray arrayWithObjects:cancelButton,flexSpace, doneButton, nil] animated:NO];
  [self.dobTextField setInputAccessoryView:accessoryView];
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
  if([self validateFields])
  {
    [self registerUserOnline];
  }
//  [self performSegueWithIdentifier:@"selectPhoto" sender:self];

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


- (BOOL)validateFields
{
  if([self fieldsNotMissing])
  {
    if([self validateEmail])
    {
      if([self validatePasswords])
      {
        return YES;
      }
    }
  }
  return NO;
}


- (BOOL)fieldsNotMissing
{
  [self clearWarnings];
  bool isValid = YES;
  if([_firstNameTextField.text isEqualToString:kEmptyStringValue])
  {
    _firstNameTextField.isValid = NO;
    isValid = NO;
  }
  else if([_lastNameTextField.text isEqualToString:kEmptyStringValue])
  {
    _lastNameTextField.isValid = NO;
    isValid = NO;
  }
  
  else if([_dobTextField.text isEqualToString:kEmptyStringValue])
  {
    _dobTextField.isValid = NO;
    isValid = NO;
  }
  
  if(!isValid)
  {
    _warningLabel.text = @"Missing Fields";
  }
  return isValid;
}


- (BOOL)validateEmail
{
  [self clearWarnings];
  NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  bool isvalid = [emailTest evaluateWithObject:_emailTextField.text];
  if(isvalid)
  {
    _emailTextField.isValid = YES;
    return YES;
  }
  else
  {
    _emailTextField.isValid = NO;
    _warningLabel.text = @"Invalid Email";
    return NO;
  }
}


- (BOOL)validatePasswords
{
  [self clearWarnings];
  if([_passwordTextField.text isEqualToString:kEmptyStringValue])
  {
    _warningLabel.text = @"Password Missing";
    _passwordTextField.isValid = NO;
    return NO;
  }
  else if([_passwordTextField.text isEqualToString:_confirmPasswordTextField.text])
  {
    _confirmPasswordTextField.isValid=YES;
    
    return YES;
  }
  else
  {
    _warningLabel.text = @"Password Mismatch";
    _confirmPasswordTextField.isValid = NO;
    return NO;
  }
}

-(void)clearWarnings
{
  _warningLabel.text=@"";
  _firstNameTextField.isValid = YES;
  _lastNameTextField.isValid = YES;
  _emailTextField.isValid = YES;
  _passwordTextField.isValid = YES;
  _confirmPasswordTextField.isValid = YES;
  _dobTextField.isValid =YES;
}
@end
