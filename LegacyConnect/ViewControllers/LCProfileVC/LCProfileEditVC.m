//
//  LCProfileEditVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 9/16/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCProfileEditVC.h"
#import "RSKImageCropViewController.h"

@interface LCProfileEditVC ()

@end

static NSString * const kCellIdentifierName = @"LCProfileNameCell";
static NSString * const kCellIdentifierLocation = @"LCProfileLocationCell";
static NSString * const kCellIdentifierHeaderBG = @"LCProfileHeaderBGCell";
static NSString * const kCellIdentifierBirthday = @"LCProfileBirthdayCell";
static NSString * const kCellIdentifierSection = @"LCProfileSectionHeader";

static NSString * const kDOBFormat = @"MMMM dd, yyyy";

@implementation LCProfileEditVC

@synthesize userDetail;

- (void)viewDidLoad {
  
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  NSLog(@"user deatils in editvc - %@",self.userDetail);
  
  profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
  profilePicBorderView.layer.cornerRadius = profilePicBorderView.frame.size.width/2;
  
  genderTypes = @[@"Male",@"Female"];
  
  self.navigationController.navigationBarHidden = YES;
  
  profilePicPlaceholder = [UIImage imageNamed:@"userProfilePic"];
  profilePic.image = profilePicPlaceholder;
  
  avatarPicState = IMAGE_UNTOUCHED;
  headerPicState = IMAGE_UNTOUCHED;
  
  NSString *profileUrlString = [NSString stringWithFormat:@"%@?type=normal",userDetail.avatarURL];

  [profilePic sd_setImageWithURL:[NSURL URLWithString:profileUrlString]
                placeholderImage:profilePicPlaceholder
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         actualAvatarImage = image;
                       }];
  NSString *headerUrlString = [NSString stringWithFormat:@"%@?type=normal",userDetail.headerPhotoURL];
  
  [headerBGImage sd_setImageWithURL:[NSURL URLWithString:headerUrlString]
                   placeholderImage:nil
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            actualHeaderImage = image;
                          }];
  dobTimeStamp = userDetail.dob;
}


- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



#pragma mark - button actions

- (IBAction)cancelAction:(id)sender {
  
  [self.view endEditing:YES];
  [self dismissViewControllerAnimated:YES completion:nil];
}

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
  [LCAPIManager updateProfile:userDetail havingHeaderPhoto:headerToPass removedState:isHeaderRemoved andAvtarImage:avatarToPass removedState:isAvatarRemoved withSuccess:^(NSArray *response) {
    NSLog(@"ress-->>>%@",response);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
      [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileUpdateNotification object:nil userInfo:nil];
    }];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"%@",error);
  }];
}

- (IBAction)editProfilePicAction:(id)sender {

  isEditingProfilePic = YES;
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    [self showImageCropViewWithImage:actualAvatarImage];
    
  }];
  
  UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      
      UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
      imagePicker.delegate = self;
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
      imagePicker.allowsEditing = NO;
      
      [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
  }];
  
  UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
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
  
  isEditingProfilePic = NO;
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    [self showImageCropViewWithImage:actualHeaderImage];
    [self validateFields];
  }];
  
  UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      
      UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
      imagePicker.delegate = self;
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
      imagePicker.allowsEditing = NO;
      
      [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
  }];
  
  UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
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


#pragma mark -

- (void) setDobTextFieldWithInputView
{
  
  datePicker = [[UIDatePicker alloc] init];
  datePicker.datePickerMode = UIDatePickerModeDate;
  [datePicker setMaximumDate:[NSDate date]];
  NSString *str = kDOBFormat;
  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  [formatter setDateFormat:kDefaultDateFormat];
  NSDate *date = [formatter dateFromString:str];
  [datePicker setMinimumDate:date];

  datePicker.date = [NSDate dateWithTimeIntervalSince1970:dobTimeStamp.longLongValue/1000];
  txt_birthday.inputView = datePicker;
  [self createDatePickerInputAccessoryView];
}


-(void)createDatePickerInputAccessoryView
{
  UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
  accessoryView.barStyle = UIBarStyleDefault;
  UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setDateAndDismissDatePickerView:)];
  [doneButton setTintColor:[UIColor blackColor]];
  UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDatePickerView:)];
  [cancelButton setTintColor:[UIColor blackColor]];
  [accessoryView setItems:[NSArray arrayWithObjects:cancelButton,flexSpace, doneButton, nil] animated:NO];
  [txt_birthday setInputAccessoryView:accessoryView];
}


- (void) setDateAndDismissDatePickerView:(id)sender
{
  [txt_birthday resignFirstResponder];
  dobTimeStamp = [LCUtilityManager getTimeStampStringFromDate:[datePicker date]];
  txt_birthday.text = [LCUtilityManager getDateFromTimeStamp:dobTimeStamp WithFormat:kDOBFormat];
  [self validateFields];
}

- (void)dismissDatePickerView:(id)sender
{
  [txt_birthday resignFirstResponder];
  datePicker.date = [NSDate dateWithTimeIntervalSince1970:dobTimeStamp.longLongValue/1000];
}


#pragma mark -

- (void)validateFields
{
  
  if (txt_firstName.text.length != 0 && txt_lastName.text.length != 0 && txt_birthday.text.length != 0) {
    
    buttonSave.enabled = YES;
  }
  else {
    buttonSave.enabled = NO;
  }
}


- (void) showImageCropViewWithImage:(UIImage *)image {
  
  RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
  imageCropVC.delegate = self;
  
  if (!isEditingProfilePic) {
    
    imageCropVC.cropMode = RSKImageCropModeCustom;
    imageCropVC.dataSource = self;
  }
  
  //[self.navigationController pushViewController:imageCropVC animated:YES];
  [self presentViewController:imageCropVC animated:YES completion:nil];
  [self customizeCropViewUI:imageCropVC];
}



- (void)customizeCropViewUI:(RSKImageCropViewController*)imageCropVC {
  
  [imageCropVC.view setAlpha:1];
  [imageCropVC.cancelButton setHidden:true];
  [imageCropVC.chooseButton setHidden:true];
  [imageCropVC.moveAndScaleLabel setHidden:true];
  
  
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  UIView * topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height)];
  [topBar setBackgroundColor:[UIColor colorWithRed:40.0f/255 green:40.0f/255 blue:40.0f/255 alpha:.9]];
  
  [topBar setUserInteractionEnabled:true];
  
  
  
  CGFloat btnWidth = 75;
  
  CGFloat btnY = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height -38;
  
  
  UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, btnY, btnWidth, 30)];
  [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
  [cancelBtn.titleLabel setTextColor:[UIColor whiteColor]];
  [cancelBtn.titleLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:17.0f]];
  
  for (id target in imageCropVC.cancelButton.allTargets) {
    NSArray *actions = [imageCropVC.cancelButton actionsForTarget:target
                                                  forControlEvent:UIControlEventTouchUpInside];
    for (NSString *action in actions) {
      [cancelBtn addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  
  UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(topBar.frame) - btnWidth, btnY, btnWidth, 30)];
  [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
  [doneBtn.titleLabel setTextColor:[UIColor whiteColor]];
  [doneBtn.titleLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:17.0f]];
  
  
  for (id target in imageCropVC.chooseButton.allTargets) {
    NSArray *actions = [imageCropVC.chooseButton actionsForTarget:target
                                                  forControlEvent:UIControlEventTouchUpInside];
    for (NSString *action in actions) {
      [doneBtn addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  
  CGFloat screenWidth = CGRectGetWidth(topBar.frame);
  UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, btnY, screenWidth, 30)];
  [titleLabel setTextAlignment:NSTextAlignmentCenter];
  [titleLabel setTextColor:[UIColor whiteColor]];
  [titleLabel setText:@"MOVE AND SCALE"];
  [titleLabel setFont:[UIFont fontWithName:@"Gotham-Bold" size:12.0f]];
  [titleLabel setUserInteractionEnabled:NO];
  
  
  [topBar addSubview:cancelBtn];
  [topBar addSubview:doneBtn];
  [topBar addSubview:titleLabel];
  [imageCropVC.view addSubview:topBar];
}


#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return 44;
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
  
  if(indexPath.section == SECTION_NAME){
    
    NSString *cellIdentifier = kCellIdentifierName;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
  }
  
  else if(indexPath.section == SECTION_LOCATION){
    
    NSString *cellIdentifier = kCellIdentifierLocation;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    txt_location = (UITextField*)[cell viewWithTag:101];
    txt_location.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.location];
    [txt_location addTarget:self
                      action:@selector(validateFields)
            forControlEvents:UIControlEventEditingChanged];
    
  }
  
  else if(indexPath.section == SECTION_BIRTHDAY){
    
    NSString *cellIdentifier = kCellIdentifierBirthday;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    txt_birthday = (UITextField*)[cell viewWithTag:101];
    txt_birthday.text = [LCUtilityManager getDateFromTimeStamp:userDetail.dob WithFormat:kDOBFormat];
    
    [self setDobTextFieldWithInputView];
  }
  
  else if(indexPath.section == SECTION_GENDER){
    
    NSString *cellIdentifier = kCellIdentifierBirthday;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    txt_gender = (UITextField*)[cell viewWithTag:101];
    txt_gender.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.gender];
    
    genderPicker = [[UIPickerView alloc] init];
    genderPicker.dataSource = self;
    genderPicker.delegate = self;
    
    if([genderTypes containsObject:userDetail.gender]){
      NSInteger selection = [genderTypes indexOfObject:userDetail.gender];
      [genderPicker selectRow:selection inComponent:0 animated:NO];
    }
    txt_gender.inputView = genderPicker;


  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}


#pragma mark - ImagePicker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:^{
    UIImage * originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self showImageCropViewWithImage:originalImage];
  }];
}


#pragma mark - RSKImageCropViewControllerDatasource

// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
  CGSize maskSize;
  maskSize = CGSizeMake(self.view.frame.size.width, 165);
  
  
  CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
  CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
  
  CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                               (viewHeight - maskSize.height) * 0.5f,
                               maskSize.width,
                               maskSize.height);
  return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
  CGRect rect = controller.maskRect;
  UIBezierPath *rectangle = [UIBezierPath bezierPathWithRect:rect];
  
  return rectangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
  // If the image is not rotated, then the movement rect coincides with the mask rect.
  return controller.maskRect;
}




#pragma mark - RSKImageCropViewControllerDelegate
// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
  [self dismissViewControllerAnimated:YES completion:^{
    if (isEditingProfilePic) {
      avatarPicState = IMAGE_EDITED;
      actualAvatarImage = croppedImage;
      profilePic.image = croppedImage;
    }
    else {
      headerPicState = IMAGE_EDITED;
      actualHeaderImage = croppedImage;
      headerBGImage.image = croppedImage;
    }
    [self validateFields];
  }];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
  [self dismissViewControllerAnimated:YES completion:^{
    
    if (isEditingProfilePic) {
      avatarPicState = IMAGE_EDITED;
      actualAvatarImage = croppedImage;
      profilePic.image = croppedImage;
    }
    else {
      headerPicState = IMAGE_EDITED;
      actualHeaderImage = croppedImage;
      headerBGImage.image = croppedImage;
    }
    [self validateFields];
  }];
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
  return [genderTypes objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  txt_gender.text = [genderTypes objectAtIndex:row];
  [self validateFields];
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
