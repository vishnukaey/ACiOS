//
//  LCSignupViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSignupViewController.h"
#import "LCTermsOfServiceViewController.h"

@interface LCSignupViewController ()
{
  NSString *dobTimeStamp;
}
@end

#define kInfoBoldFont [UIFont fontWithName:@"Gotham-Bold" size:13.0f]
#define kInfoFont [UIFont fontWithName:@"Gotham-Book" size:13.0f]
#define kInfoColor [UIColor colorWithRed:35/255.0 green:31/255.0  blue:32/255.0  alpha:1]
#define kBGColor [UIColor colorWithRed:250/255.0 green:70/255.0  blue:22/255.0  alpha:1]

@implementation LCSignupViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setDobTextFieldWithInputView];
  [self initialUISetUp];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  _signupButton.layer.cornerRadius = 5.0;
  [_signupButton clipsToBounds];
  [self textFieldDidChange];
  
  [_firstNameTextField addTarget:self action:@selector(textFieldDidChange)
            forControlEvents:UIControlEventEditingChanged];
  [_lastNameTextField addTarget:self
                         action:@selector(textFieldDidChange)
               forControlEvents:UIControlEventEditingChanged];
  [_emailTextField addTarget:self
                      action:@selector(textFieldDidChange)
            forControlEvents:UIControlEventEditingChanged];
  [_passwordTextField addTarget:self
                         action:@selector(textFieldDidChange)
               forControlEvents:UIControlEventEditingChanged];
  [_confirmPasswordTextField addTarget:self
                      action:@selector(textFieldDidChange)
            forControlEvents:UIControlEventEditingChanged];
  [_dobTextField addTarget:self
                         action:@selector(textFieldDidChange)
               forControlEvents:UIControlEventEditingChanged];
  self.navigationController.navigationBarHidden = true;
  //GATracking
  [LCGAManager ga_trackViewWithName:@"Registration"];
}

- (void)initialUISetUp
{
  NSString *infoText = @"By signing up you agree to these Terms of Service";
  NSMutableAttributedString *info = [[NSMutableAttributedString alloc] initWithString:infoText];
  
  NSRange fullTxtRng = [infoText rangeOfString:infoText];
  [info addAttribute:NSFontAttributeName value:kInfoFont range:fullTxtRng];
  [info addAttribute:NSForegroundColorAttributeName value:kInfoColor range:fullTxtRng];
  
  NSRange boldTxtRag1 = [infoText rangeOfString:@"Terms of Service"];
  [info addAttribute:NSFontAttributeName value:kInfoBoldFont range:boldTxtRag1];
  
  NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
  NSDictionary *tagsDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithRange:boldTxtRag1],@"range", nil];
  [tagsArray addObject:tagsDict];
  _termsLabel.tagsArray = tagsArray;
  _termsLabel.nameTagTapped = ^(int index)
  {
    [self readTermsofService];
  };
  [self.termsLabel setAttributedText:info];
}

-(void)readTermsofService
{
  UIStoryboard *signSB = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  LCTermsOfServiceViewController *termsVC = [signSB instantiateViewControllerWithIdentifier:@"LCTermsOfServiceViewController"];
  [self.navigationController pushViewController:termsVC animated:YES];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - private method implementation
- (void) setDobTextFieldWithInputView
{
  datePicker = [[UIDatePicker alloc] init];
  datePicker.datePickerMode = UIDatePickerModeDate;
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDate *currentDate = [NSDate date];
  NSDateComponents *comps = [[NSDateComponents alloc] init];
  [comps setYear:-150];
  NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
  [comps setYear:-13];
  NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
  [comps setYear:-50];
  NSDate *defualtDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];

  datePicker.minimumDate = minDate;
  datePicker.maximumDate = maxDate;
  datePicker.date = defualtDate;
  
  _dobTextField.inputView = datePicker;
  [self createDatePickerInputAccessoryView];
}


-(void)createDatePickerInputAccessoryView
{
  UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
  accessoryView.barStyle = UIBarStyleDefault;
  UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setDateAndDismissDatePickerView)];
  [doneButton setTintColor:[UIColor blackColor]];
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDatePickerView)];
  [cancelButton setTintColor:[UIColor blackColor]];
  [accessoryView setItems:@[cancelButton,flexSpace, doneButton] animated:NO];
  [self.dobTextField setInputAccessoryView:accessoryView];
}


- (void)setDateAndDismissDatePickerView
{
  [_dobTextField resignFirstResponder];
  [self updateTextFieldWithDate];
  [self textFieldDidChange];
}

- (void)dismissDatePickerView
{
  [self textFieldDidChange];
  [_dobTextField resignFirstResponder];
}


-(void)updateTextFieldWithDate
{
  dobTimeStamp = [LCUtilityManager getTimeStampStringFromDate:[datePicker date]];
  _dobTextField.text = [LCUtilityManager getDateFromTimeStamp:dobTimeStamp WithFormat:@"dd-MMM-YYYY"];
}


- (void)registerUserOnline
{
  [self.signupButton setEnabled:false];
  NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[self.firstNameTextField.text,self.lastNameTextField.text,self.emailTextField.text,self.passwordTextField.text,dobTimeStamp] forKeys:@[kFirstNameKey, kLastNameKey, kEmailKey, kPasswordKey, kDobKey]];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCOnboardingAPIManager registerNewUser:dict withSuccess:^(id response) {
    
    //GA Tracking
    [LCGAManager ga_trackEventWithCategory:@"Registration" action:@"Success" andLabel:@"New User Registration Successful"];
    
    [LCUtilityManager saveUserDetailsToDataManagerFromResponse:response];
    [LCUtilityManager saveUserDefaultsForNewUser];
    [self.signupButton setEnabled:true];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self performSegueWithIdentifier:@"selectPhoto" sender:self];
    [LCTutorialManager resetTutorialPersistance];
  } andFailure:^(NSString *error) {
    [self.signupButton setEnabled:true];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}


- (void)saveUserAcessTokenAndUserIDFromResponse:(id)response
{
  NSDictionary *userInfo = response[kResponseData];
  [LCDataManager sharedDataManager].userID = userInfo[kUserIDKey];
  [LCDataManager sharedDataManager].userToken = userInfo[kAccessTokenKey];
}

- (void)textFieldDidChange
{
  if(_firstNameTextField.text.length!=0 && _lastNameTextField.text.length!=0 && _emailTextField.text.length!=0 && _passwordTextField.text.length!=0 && _confirmPasswordTextField.text.length!=0 && _dobTextField.text.length!=0 )
  {
    _signupButton.enabled = YES;
    [_signupButton setBackgroundColor:kBGColor];
    
  }
  else
  {
    _signupButton.enabled = NO;
    [_signupButton setBackgroundColor:[UIColor lightGrayColor]];
  }
}


#pragma mark - IBAction implementation
- (IBAction)cancelButtonTapped:(id)sender
{
  [self.navigationController popToRootViewControllerAnimated:NO];
}

-(IBAction)readTermsofService:(id)sender
{
  UIStoryboard *signSB = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  LCTermsOfServiceViewController *termsVC = [signSB instantiateViewControllerWithIdentifier:@"LCTermsOfServiceViewController"];
  [self.navigationController pushViewController:termsVC animated:YES];
}


- (IBAction)nextButtonTapped:(id)sender
{
  if(![LCUtilityManager validateEmail:_emailTextField.text])
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"invalid_mail_address", @"")];
  }
  else if(![LCUtilityManager validatePassword:self.passwordTextField.text])
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"invalid_password", @"")];
  }
  else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text])
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"password_mismatch", @"")];
  }
  else
  {
    [self registerUserOnline];
  }
}

  
@end
