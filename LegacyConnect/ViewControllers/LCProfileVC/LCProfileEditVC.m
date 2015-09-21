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
  profilePic.layer.borderColor = [[UIColor whiteColor]CGColor];
  
  [self loadUserData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



#pragma mark - button actions

- (IBAction)cancelAction:(id)sender {
  
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
  
  NSLog(@"edit picture here...");
}


#pragma mark -

- (void)loadUserData {
  NSLog(@"avatar url - %@", userDetail.avatarURL);
  
//  if (userDetail.avatarURL != nil) {
//    profilePic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userDetail.avatarURL]]];
//  }

  [img_headerBG sd_setImageWithURL:[NSURL URLWithString:userDetail.avatarURL] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  
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
  txt_birthday.inputView = datePicker;
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
  
  static UITableViewCell *cell = nil;
  
  if(indexPath.section == SECTION_NAME){
    
    NSString *cellIdentifier = kCellIdentifierName;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    for (UIView *view in  cell.contentView.subviews){
      
      if ([view isKindOfClass:[UITextField class]]){
        
        UITextField *txtField = (UITextField *)view;
        
        if (txtField.tag == 101) {
          txt_firstName = txtField;
          txt_firstName.text = userDetail.firstName;
        }
        else if (txtField.tag == 102) {
          txt_lastName = txtField;
          txt_lastName.text = userDetail.lastName;
        }
      }
    }
  }
  
  else if(indexPath.section == SECTION_LOCATION){
    
    NSString *cellIdentifier = kCellIdentifierLocation;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    for (UIView *view in  cell.contentView.subviews){
      
      if ([view isKindOfClass:[UITextField class]]){
        
        UITextField *txtField = (UITextField *)view;
        
        if (txtField.tag == 101) {
          txt_location = txtField;
          txt_location.text = userDetail.location;
        }
      }
    }
    
  }
  
  else if(indexPath.section == SECTION_HEADER_BACKGROUND){
    
    NSString *cellIdentifier = kCellIdentifierHeaderBG;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    for (UIView *view in  cell.contentView.subviews){
      
      if ([view isKindOfClass:[UIImageView class]]){
        
        UIImageView *imageView = (UIImageView *)view;
        
        if (imageView.tag == 101) {
          img_headerBG = imageView;
          //img_headerBG.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userDetail.headerPhotoURL]]];
          [img_headerBG sd_setImageWithURL:[NSURL URLWithString:userDetail.headerPhotoURL] placeholderImage:[UIImage imageNamed:@"landscape_valley_sunset_lone_tree_high_resolution_wallpapers-320x568.jpg"]];
        }
      }
    }
  }
  
  else if(indexPath.section == SECTION_BIRTHDAY){
    
    NSString *cellIdentifier = kCellIdentifierBirthday;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    for (UIView *view in  cell.contentView.subviews){
      
      if ([view isKindOfClass:[UITextField class]]){
        
        UITextField *txtField = (UITextField *)view;
        
        if (txtField.tag == 101) {
          txt_birthday = txtField;
          txt_birthday.text = userDetail.dob;
          
          [self setDobTextFieldWithInputView];
        }
      }
    }
    
  }
  
  else if(indexPath.section == SECTION_GENDER){
    
    NSString *cellIdentifier = kCellIdentifierBirthday;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    for (UIView *view in  cell.contentView.subviews){
      
      if ([view isKindOfClass:[UITextField class]]){
        
        UITextField *txtField = (UITextField *)view;
        
        if (txtField.tag == 101) {
          txt_gender = txtField;
          txt_gender.text = userDetail.gender;
        }
      }
    }
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected section-->>>%d", (int)indexPath.section);
  if (indexPath.section == SECTION_BIRTHDAY) {
    
    
  }
  else if (indexPath.section == SECTION_GENDER) {
    
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
