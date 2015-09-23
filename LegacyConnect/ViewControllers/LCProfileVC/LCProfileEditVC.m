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


@implementation LCProfileEditVC

@synthesize userDetail;

- (void)viewDidLoad {
  
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  NSLog(@"user deatils in editvc - %@",self.userDetail);
  
  profilePic.layer.cornerRadius = profilePic.frame.size.width / 2.0;
  profilePic.layer.borderWidth = 3.0f;
  profilePic.layer.borderColor = [[UIColor colorWithRed:235.0f/255.0 green:236.0f/255.0 blue:235.0f/255.0 alpha:1.0] CGColor];
  
  self.navigationController.navigationBarHidden = YES;
  [self loadUserData];
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
  
  NSLog(@"full name - %@ %@",txt_firstName.text,txt_lastName.text);
  NSLog(@"location - %@",txt_location.text);
  NSLog(@"header background - %@",img_headerBG.image);
  NSLog(@"birthday - %@",txt_birthday.text);
  NSLog(@"gender - %@",txt_gender.text);
  
}

- (IBAction)editPictureAction:(id)sender {

  isEditingProfilePic = YES;
  [self showEditingPictureOptions];
}


#pragma mark -

- (void)loadUserData {
  
  [img_headerBG sd_setImageWithURL:[NSURL URLWithString:userDetail.avatarURL]
                  placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
}


#pragma mark -

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
  [self updateTextFieldWithDate:self];
}

- (void)dismissDatePickerView:(id)sender
{
  [txt_birthday resignFirstResponder];
}

-(void) updateTextFieldWithDate:(id) picker
{
  dobTimeStamp = [LCUtilityManager getTimeStampStringFromDate:[datePicker date]];
  txt_birthday.text = [LCUtilityManager getDateFromTimeStamp:dobTimeStamp WithFormat:@"MM/dd/yyyy"];
}


#pragma mark -

- (void)validateFields:(id)sender
{
  
  if (txt_firstName.text.length != 0 && txt_lastName.text.length != 0 && txt_birthday.text.length != 0) {
    
    buttonSave.enabled = YES;
  }
  else {
    buttonSave.enabled = NO;
  }
}


- (void) showGenderSelection {
  
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"Male" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    txt_gender.text = @"Male";
    [self performSelector:@selector(validateFields:) withObject:nil afterDelay:0];
  }];
  [actionSheet addAction:maleAction];
  
  UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    txt_gender.text = @"Female";
    [self performSelector:@selector(validateFields:) withObject:nil afterDelay:0];
  }];
  [actionSheet addAction:femaleAction];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  
  [self presentViewController:actionSheet animated:YES completion:nil];
  
}


- (void) showEditingPictureOptions {
  
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    UIImage *originalImage;
    
    if (isEditingProfilePic) {
      originalImage = profilePic.image;
    }
    else {
      originalImage = img_headerBG.image;
    }
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:originalImage];
    imageCropVC.delegate = self;
    
    if (!isEditingProfilePic) {
      
      imageCropVC.cropMode = RSKImageCropModeCustom;
      imageCropVC.dataSource = self;
    }
    
    //[self.navigationController pushViewController:imageCropVC animated:YES];
    [self presentViewController:imageCropVC animated:YES completion:nil];
    
    [self customizeCropViewUI:imageCropVC];
  }];
  [actionSheet addAction:editAction];
  
  
  UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      
      UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
      imagePicker.delegate = self;
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
      imagePicker.allowsEditing = NO;
      
      [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
  }];
  [actionSheet addAction:takeAction];
  
  
  UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
  }];
  [actionSheet addAction:chooseAction];
  
  
  UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Photo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    
    if (isEditingProfilePic) {
      profilePic.image = [UIImage imageNamed:@"manplaceholder.jpg"];
    }
    else {
      img_headerBG.image = [UIImage imageNamed:@"headerImage"];
    }
    
  }];
  [actionSheet addAction:removeAction];
  
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  
  [self presentViewController:actionSheet animated:YES completion:nil];
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
  return 5;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == SECTION_HEADER_BACKGROUND) {
    
    return 88;
  }
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
    case SECTION_HEADER_BACKGROUND:
      sectionLabel.text = @"HEADER BACKGROUND";
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
    txt_firstName.text = userDetail.firstName;
    [txt_firstName addTarget:self
                      action:@selector(validateFields:)
            forControlEvents:UIControlEventEditingChanged];
    
    txt_lastName = (UITextField*)[cell viewWithTag:102];
    txt_lastName.text = userDetail.lastName;
    [txt_lastName addTarget:self
                     action:@selector(validateFields:)
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
    txt_location.text = userDetail.location;
    [txt_location addTarget:self
                      action:@selector(validateFields:)
            forControlEvents:UIControlEventEditingChanged];
    
  }
  
  else if(indexPath.section == SECTION_HEADER_BACKGROUND){
    
    NSString *cellIdentifier = kCellIdentifierHeaderBG;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    img_headerBG = (UIImageView*)[cell viewWithTag:101];
    [img_headerBG sd_setImageWithURL:[NSURL URLWithString:userDetail.headerPhotoURL] placeholderImage:[UIImage imageNamed:@"headerImage"]];
  }
  
  else if(indexPath.section == SECTION_BIRTHDAY){
    
    NSString *cellIdentifier = kCellIdentifierBirthday;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    txt_birthday = (UITextField*)[cell viewWithTag:101];
    txt_birthday.text = userDetail.dob;
    [txt_birthday addTarget:self
                     action:@selector(validateFields:)
           forControlEvents:UIControlEventEditingChanged];
    
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
    txt_gender.text = userDetail.gender;
    [txt_gender addTarget:self
                      action:@selector(validateFields:)
            forControlEvents:UIControlEventEditingChanged];
    txt_gender.enabled = NO;

  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (indexPath.section == SECTION_HEADER_BACKGROUND) {
    
    [self.view endEditing:YES];
    isEditingProfilePic = NO;
    [self showEditingPictureOptions];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
  
  else if (indexPath.section == SECTION_GENDER) {
    
    [self.view endEditing:YES];
    [self performSelector:@selector(showGenderSelection) withObject:nil afterDelay:0];
  }
}


#pragma mark - ImagePicker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:^{
    UIImage * originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:originalImage];
    imageCropVC.delegate = self;
    
    if (!isEditingProfilePic) {
      
      imageCropVC.cropMode = RSKImageCropModeCustom;
      imageCropVC.dataSource = self;
    }
    
    //[self.navigationController pushViewController:imageCropVC animated:YES];
    [self presentViewController:imageCropVC animated:YES completion:nil];
    
    [self customizeCropViewUI:imageCropVC];
  }];
}


#pragma mark - RSKImageCropViewControllerDatasource

// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
  CGSize maskSize;
  maskSize = CGSizeMake(350, 250);
  
  
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
  //[self.navigationController popViewControllerAnimated:YES];
  [self dismissViewControllerAnimated:YES completion:nil];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
  //[self.navigationController popViewControllerAnimated:NO];
  //+kc[self invokeUploadImageAPIWithImage:croppedImage];
  [self dismissViewControllerAnimated:YES completion:^{
    if (isEditingProfilePic) {
      
      profilePic.image = croppedImage;
    }
    else {
      
      img_headerBG.image = croppedImage;
    }
    [self performSelector:@selector(validateFields:) withObject:nil afterDelay:0];
  }];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
  //[self.navigationController popViewControllerAnimated:NO];
  //+kc[self invokeUploadImageAPIWithImage:croppedImage];
  
  [self dismissViewControllerAnimated:YES completion:^{
    if (isEditingProfilePic) {
      
      profilePic.image = croppedImage;
    }
    else {
      
      img_headerBG.image = croppedImage;
    }
    [self performSelector:@selector(validateFields:) withObject:nil afterDelay:0];
  }];
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
