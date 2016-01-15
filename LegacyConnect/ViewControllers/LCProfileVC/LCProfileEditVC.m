//
//  LCProfileEditVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 9/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCProfileEditVC.h"

@interface LCProfileEditVC ()

@end

NSString * const kCellIdentifierName = @"LCProfileNameCell";
NSString * const kCellIdentifierLocation = @"LCProfileLocationCell";
NSString * const kCellIdentifierHeaderBG = @"LCProfileHeaderBGCell";
NSString * const kCellIdentifierBirthday = @"LCProfileBirthdayCell";
NSString * const kCellIdentifierSection = @"LCProfileSectionHeader";

NSString * const kDOBFormat = @"MMMM dd, yyyy";
NSString * const kMaleString = @"Male";
NSString * const kFemaleString = @"Female";

NSInteger const kNumberOfSections = 4;
NSInteger const kNumberOfRows = 1;
NSInteger const kHeightForHeader = 44;

@implementation LCProfileEditVC

@synthesize userDetail;

- (void)viewDidLoad {
  
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self initialSetup];
}


- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setLCStatusBarStyle];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)initialSetup {
  
  self.navigationController.navigationBarHidden = YES;
  
  imageEditor = [[LCProfileImageEditor alloc] init];
  imageEditor.delegate = self;
  
  profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
  profilePicBorderView.layer.cornerRadius = profilePicBorderView.frame.size.width/2;
  
  profilePicPlaceholder = [UIImage imageNamed:@"userProfilePic"];
  profilePic.image = profilePicPlaceholder;
  avatarPicState = IMAGE_UNTOUCHED;
  headerPicState = IMAGE_UNTOUCHED;
  
  NSString *profileUrlString = [NSString stringWithFormat:@"%@?type=large",userDetail.avatarURL];
  [profilePic sd_setImageWithURL:[NSURL URLWithString:profileUrlString]
                placeholderImage:profilePicPlaceholder
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         if (headerPicState == IMAGE_UNTOUCHED) {
                           actualAvatarImage = image;
                         }
                         else {
                           //image already edited by user
                           profilePic.image = actualAvatarImage;
                         }
                       }];
  
  [headerBGImage sd_setImageWithURL:[NSURL URLWithString:userDetail.headerPhotoURL]
                   placeholderImage:nil
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (headerPicState == IMAGE_UNTOUCHED) {
                              actualHeaderImage = image;
                            }
                            else {
                              //image already edited by user
                              headerBGImage.image = actualHeaderImage;
                            }
                          }];
  
  dobTimeStamp = userDetail.dob;
  genderTypes = @[kMaleString, kFemaleString];
  
  [self fillGradientForNavigation];
  [self fillGradientForNavigation];
}

- (void)fillGradientForNavigation
{
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, navigationBar.bounds.size.height);
  gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
  [navigationBar.layer insertSublayer:gradient atIndex:0];
}


- (void)validateFields
{
  if(![LCUtilityManager isEmptyString:txt_firstName.text] &&
     ![LCUtilityManager isEmptyString:txt_lastName.text] &&
     ![LCUtilityManager isEmptyString:txt_birthday.text]){
    buttonSave.enabled = YES;
  }
  else {
    buttonSave.enabled = NO;
  }
}


#pragma mark - button actions

- (IBAction)saveAction:(id)sender {
  
  userDetail.firstName = txt_firstName.text;
  userDetail.lastName = txt_lastName.text;
  userDetail.dob = dobTimeStamp;
  userDetail.gender = txt_gender.text;
  userDetail.location = txt_location.text;
  
  UIImage *avatarToPass = nil, *headerToPass = nil;
  BOOL isAvatarRemoved = NO, isHeaderRemoved = NO;
  
  if (avatarPicState == IMAGE_REMOVED)
  {
    isAvatarRemoved = YES;
  }
  else if (avatarPicState == IMAGE_EDITED)
  {
    avatarToPass = actualAvatarImage;
  }
  
  if (headerPicState == IMAGE_REMOVED)
  {
    isHeaderRemoved = YES;
  }
  else if (headerPicState == IMAGE_EDITED)
  {
    headerToPass = actualHeaderImage;
  }
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCUserProfileAPIManager updateProfile:userDetail havingHeaderPhoto:headerToPass removedState:isHeaderRemoved andAvtarImage:avatarToPass removedState:isAvatarRemoved withSuccess:^(NSArray *response) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    LCDLog(@"%@",error);
  }];
}

- (IBAction)cancelAction:(id)sender {
  
  [self.view endEditing:YES];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editProfilePicAction:(id)sender {
  
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    if (avatarPicState == IMAGE_UNTOUCHED) {
      
      NSURL *avatarUrl = [NSURL URLWithString:userDetail.avatarURL];
      
      NSString *avatarUrlString;
      if ([avatarUrl.host containsString:@"facebook"]) {
        avatarUrlString = [NSString stringWithFormat:@"%@?width=800",userDetail.avatarURL];
      }
      else {
        avatarUrlString = [NSString stringWithFormat:@"%@?type=large",userDetail.avatarURL];
      }
      
      SDWebImageManager *manager = [SDWebImageManager sharedManager];
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      [manager downloadImageWithURL:[NSURL URLWithString:avatarUrlString]
                            options:0
                           progress:nil
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                              [imageEditor presentImageEditorOnController:self withImage:image isEditingProfilePic:YES];
                            }
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                          }];
    }
    else {
      [imageEditor presentImageEditorOnController:self withImage:actualAvatarImage isEditingProfilePic:YES];
    }
  }];
  
  UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

    imageEditor = [[LCProfileImageEditor alloc] init];
    imageEditor.delegate = self;
    [imageEditor showImagePickerOnController:self withSource:UIImagePickerControllerSourceTypeCamera isEditingProfilePic:YES];
    
  }];
  
  UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    imageEditor = [[LCProfileImageEditor alloc] init];
    imageEditor.delegate = self;
    [imageEditor showImagePickerOnController:self withSource:UIImagePickerControllerSourceTypePhotoLibrary isEditingProfilePic:YES];
    
  }];
  
  UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Profile Photo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    avatarPicState = IMAGE_REMOVED;
    actualAvatarImage = nil;
    profilePic.image = profilePicPlaceholder;
    [self validateFields];
  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  
  
  if (actualAvatarImage){
    [actionSheet addAction:editAction];
  }
  [actionSheet addAction:takeAction];
  [actionSheet addAction:chooseAction];
  if (actualAvatarImage) {
    [actionSheet addAction:removeAction];
  }
  [actionSheet addAction:cancelAction];
  
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)editHeaderBGAction:(id)sender {
  
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    if (headerPicState == IMAGE_UNTOUCHED) {
      
      NSString *headerUrlString = [NSString stringWithFormat:@"%@?type=large",userDetail.headerPhotoURL];
      SDWebImageManager *manager = [SDWebImageManager sharedManager];
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      [manager downloadImageWithURL:[NSURL URLWithString:headerUrlString]
                            options:0
                           progress:nil
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                              [imageEditor presentImageEditorOnController:self withImage:image isEditingProfilePic:NO];
                            }
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                          }];
    }
    else{
      [imageEditor presentImageEditorOnController:self withImage:actualHeaderImage isEditingProfilePic:NO];
    }
  }];
  
  UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      
      imageEditor = [[LCProfileImageEditor alloc] init];
      imageEditor.delegate = self;
      [imageEditor showImagePickerOnController:self withSource:UIImagePickerControllerSourceTypeCamera isEditingProfilePic:NO];
    }
    
  }];
  
  UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    imageEditor = [[LCProfileImageEditor alloc] init];
    imageEditor.delegate = self;
    [imageEditor showImagePickerOnController:self withSource:UIImagePickerControllerSourceTypePhotoLibrary isEditingProfilePic:NO];
    
  }];
  
  UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Header Photo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    headerPicState = IMAGE_REMOVED;
    actualHeaderImage = nil;
    headerBGImage.image = nil;
    [self validateFields];
  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  
  if (actualHeaderImage){
    [actionSheet addAction:editAction];
  }
  [actionSheet addAction:takeAction];
  [actionSheet addAction:chooseAction];
  if (actualHeaderImage) {
    [actionSheet addAction:removeAction];
  }
  [actionSheet addAction:cancelAction];
  
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)RSKFinishedPickingProfileImage:(UIImage *)image
{
  avatarPicState = IMAGE_EDITED;
  actualAvatarImage = image;
  profilePic.image = image;
  [self validateFields];
}

- (void)RSKFinishedPickingHeaderImage:(UIImage *)image
{
  headerPicState = IMAGE_EDITED;
  actualHeaderImage = image;
  headerBGImage.image = image;
  [self validateFields];
}



#pragma mark - DOB and Gender setup

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
  datePicker.minimumDate = minDate;
  datePicker.maximumDate = maxDate;
  
  NSDate *defualtDate;
  if(dobTimeStamp) {
    defualtDate = [NSDate dateWithTimeIntervalSince1970:dobTimeStamp.longLongValue/1000];
  }
  else {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:1970];
    [components setMonth:1];
    [components setDay:1];
    defualtDate = [calendar dateFromComponents:components];
  }
  
  datePicker.date = defualtDate;
  
  txt_birthday.inputView = datePicker;
  [txt_birthday addCancelDoneOnKeyboardWithTarget:self
                                     cancelAction:@selector(dismissDatePickerView)
                                       doneAction:@selector(setDateAndDismissDatePickerView)];
}


- (void) setDateAndDismissDatePickerView
{
  [txt_birthday resignFirstResponder];
  dobTimeStamp = [LCUtilityManager getTimeStampStringFromDate:[datePicker date]];
  txt_birthday.text = [LCUtilityManager getDateFromTimeStamp:dobTimeStamp WithFormat:kDOBFormat];
  [self validateFields];
}

- (void)dismissDatePickerView
{
  [txt_birthday resignFirstResponder];
  
  NSDate *defualtDate;
  if(dobTimeStamp) {
    defualtDate = [NSDate dateWithTimeIntervalSince1970:dobTimeStamp.longLongValue/1000];
  }
  else {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:1970];
    [components setMonth:1];
    [components setDay:1];
    defualtDate = [calendar dateFromComponents:components];
  }
  
  datePicker.date = defualtDate;
}


- (void) setGenderPickerTextFieldWithInputView {
  
  genderPicker = [[UIPickerView alloc] init];
  genderPicker.dataSource = self;
  genderPicker.delegate = self;
  
  if([genderTypes containsObject:userDetail.gender]){
    NSInteger selection = [genderTypes indexOfObject:userDetail.gender];
    [genderPicker selectRow:selection inComponent:0 animated:NO];
  }
  txt_gender.inputView = genderPicker;
  [txt_gender addCancelDoneOnKeyboardWithTarget:self cancelAction:@selector(genderSelectionCancelled) doneAction:@selector(genderSelected)];
}

- (void) genderSelected//CC
{
  [txt_gender resignFirstResponder];
  txt_gender.text = genderTypes[[genderPicker selectedRowInComponent:0]];
  [self validateFields];
}

- (void) genderSelectionCancelled {
  [txt_gender resignFirstResponder];
  if([genderTypes containsObject:userDetail.gender]){
    NSInteger selection = [genderTypes indexOfObject:userDetail.gender];
    [genderPicker selectRow:selection inComponent:0 animated:NO];
  }
}

#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return kNumberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return kHeightForHeader;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  NSString *cellIdentifier = kCellIdentifierSection;
  UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (headerView == nil) {
    headerView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
  }
  
  UILabel *sectionLabel = (UILabel *)[headerView viewWithTag:100];
  UILabel *optionalLabel = (UILabel *)[headerView viewWithTag:101];
  
  switch (section) {
      
    case SECTION_NAME:
      sectionLabel.text = @"NAME";
      break;
    case SECTION_LOCATION:
      sectionLabel.text = @"LOCATION";
      optionalLabel.hidden = NO;
      break;
    case SECTION_BIRTHDAY:
      sectionLabel.text = @"BIRHTDAY";
      break;
    case SECTION_GENDER:
      sectionLabel.text = @"GENDER";
      optionalLabel.hidden = NO;
      break;
      
    default:
      break;
  }
  
  return  headerView ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = nil;
  if (indexPath.section == SECTION_NAME)
  {
    cell = [self getNameSectionCellForTableView:tableView];
  }
  else if (indexPath.section == SECTION_LOCATION)
  {
    cell = [self getLocationSectionCellForTableView:tableView];
  }
  else if (indexPath.section == SECTION_BIRTHDAY)
  {
    cell = [self getBirthdaySectionCellForTableView:tableView];
  }
  else if (indexPath.section == SECTION_GENDER)
  {
    cell = [self getGenderSectionCellForTableView:tableView];
  }
  return cell;
}

- (UITableViewCell*)getGenderSectionCellForTableView:(UITableView*)tableView
{
  NSString *cellIdentifier = kCellIdentifierBirthday;
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  
  txt_gender = (UITextField*)[cell viewWithTag:101];
  txt_gender.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.gender];
  [self setGenderPickerTextFieldWithInputView];
  return cell;
}

- (UITableViewCell*)getNameSectionCellForTableView:(UITableView*)tableView
{
  NSString *cellIdentifier = kCellIdentifierName;
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  
  txt_firstName = (UITextField*)[cell viewWithTag:101];
  txt_firstName.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.firstName];
  [txt_firstName addTarget:self
                    action:@selector(validateFields)
          forControlEvents:UIControlEventEditingChanged];
  
  txt_lastName = (UITextField*)[cell viewWithTag:102];
  txt_lastName.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.lastName];
  [txt_lastName addTarget:self
                   action:@selector(validateFields)
         forControlEvents:UIControlEventEditingChanged];
  return cell;
}

- (UITableViewCell*)getLocationSectionCellForTableView:(UITableView*)tableView
{
  NSString *cellIdentifier = kCellIdentifierLocation;
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  
  txt_location = (UITextField*)[cell viewWithTag:101];
  txt_location.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.location];
  [txt_location addTarget:self
                   action:@selector(validateFields)
         forControlEvents:UIControlEventEditingChanged];
  return cell;

}

- (UITableViewCell*)getBirthdaySectionCellForTableView:(UITableView*)tableView
{
  NSString *cellIdentifier = kCellIdentifierBirthday;
  UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  
  txt_birthday = (UITextField*)[cell viewWithTag:101];
  txt_birthday.text = [LCUtilityManager getDateFromTimeStamp:userDetail.dob WithFormat:kDOBFormat];
  
  [self setDobTextFieldWithInputView];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == SECTION_BIRTHDAY){
    
    [txt_birthday becomeFirstResponder];
  }
  else if(indexPath.section == SECTION_GENDER){
    [txt_gender becomeFirstResponder];
  }
}

#pragma mark - Picker View Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return genderTypes.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return genderTypes[row];//CC
}
@end
