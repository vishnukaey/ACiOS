//
//  LCCreateActions.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCActionsForm.h"
#import "LCInviteToActions.h"

@interface LCActionsForm ()
{
  IBOutlet UITextField *actionNameField;
  IBOutlet UITextView *actionAboutField;
  IBOutlet UITextField *actionWebsiteField;
  IBOutlet UITextField *actionDateField;
  IBOutlet UITextField *actionTypeField;
  IBOutlet UITextField *headerImagePlaceholder;
  IBOutlet UITextField *aboutPlaceholder;
  IBOutlet UIImageView *headerPhotoImageView;
  IBOutlet UITableView *formTableView;
  IBOutlet UIButton *nextButton;
  NSDate *startDate, *endDate;
}

@end

static NSString * const kCellIdentifierName = @"LCActionNameCell";
static NSString * const kCellIdentifierType = @"LCActionTypeCell";
static NSString * const kCellIdentifierDate = @"LCActionDateCell";
static NSString * const kCellIdentifierWebsite = @"LCActionWebsiteCell";
static NSString * const kCellIdentifierHeaderBG = @"LCActionHeaderCell";
static NSString * const kCellIdentifierAbout = @"LCActionAboutCell";
static NSString * const kCellIdentifierSection = @"LCActionSectionHeader";

@implementation LCActionsForm
@synthesize selectedInterest;


#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
   formTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  nextButton.enabled = NO;
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
- (IBAction)nextButtonAction
{
  LCEvent *com = [[LCEvent alloc] init];
  com.name = actionNameField.text;
  com.interestID = self.selectedInterest.interestID;
  com.website = actionWebsiteField.text;
  com.eventDescription = actionAboutField.text;
  com.time = @"";
  [LCAPIManager createEvent:com havingHeaderPhoto:headerPhotoImageView.image withSuccess:^(id response) {
    com.eventID = response[@"data"][@"id"];
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
    LCInviteToActions *vc = [sb instantiateViewControllerWithIdentifier:@"LCInviteToActions"];
    vc.eventToInvite = com;
    [self.navigationController pushViewController:vc animated:YES];
  } andFailure:^(NSString *error) {
  }];

}

- (IBAction)cancelAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)dateSelection
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
  LCActionsDateSelection *vc = [sb instantiateViewControllerWithIdentifier:@"LCActionsDateSelection"];
  vc.startDate = startDate;
  vc.endDate = endDate;
  vc.delegate = self;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerPhotoSelection
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
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
    [self setHeaderImage:nil];
  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  
  [actionSheet addAction:takeAction];
  [actionSheet addAction:chooseAction];
  if (headerPhotoImageView.image) {
    [actionSheet addAction:removeAction];
  }
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)actionTypeSelection
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *eventAction = [UIAlertAction actionWithTitle:@"Event" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    actionTypeField.text = action.title;
  }];
  UIAlertAction *challengeAction = [UIAlertAction actionWithTitle:@"Challenge" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    actionTypeField.text = action.title;
  }];
  UIAlertAction *pollAction = [UIAlertAction actionWithTitle:@"Poll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    actionTypeField.text = action.title;
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:eventAction];
  [actionSheet addAction:challengeAction];
    [actionSheet addAction:pollAction];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)setHeaderImage :(UIImage *)image
{
  if (image)
  {
    headerImagePlaceholder.hidden = true;
  }
  else
  {
    headerImagePlaceholder.hidden = false;
  }
  headerPhotoImageView.image = image;
}

- (void)validateFields
{
  if (actionAboutField.text.length && actionNameField.text.length)
  {
    nextButton.enabled = YES;
  }
  else
  {
    nextButton.enabled = NO;
  }
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""])
  {
    aboutPlaceholder.hidden = false;
  }
  else
  {
    aboutPlaceholder.hidden = true;
  }
  [self validateFields];
}
#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:NULL];
  UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
  [self setHeaderImage:chosenImage];
  [formTableView reloadData];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - date selection delegate
- (void)actionDateSelected:(NSDate *)start :(NSDate *)end
{
  startDate = start;
  endDate = end;
  
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setDateFormat:@"EEEE, MMM dd, yyyy    HH:mm aa"];
  NSString *dateString = [format stringFromDate:startDate];
  actionDateField.text = dateString;
}
#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  if (indexPath.section == SECTION_HEADER && headerPhotoImageView.image)
  {
    return 88;
  }
  if (indexPath.section == SECTION_ABOUT) {
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
  UIView *topLine = [headerView viewWithTag:111];
  UIView *botLine = [headerView viewWithTag:112];
  [topLine removeFromSuperview];
  [botLine removeFromSuperview];
  
  topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
  [topLine setBackgroundColor:[UIColor colorWithRed:128.0f/255 green:128.0f/255 blue:128.0f/255 alpha:0.5]];
  [headerView addSubview:topLine];
  topLine.tag = 111;
  
  botLine = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, tableView.frame.size.width, 1)];
  [botLine setBackgroundColor:[UIColor colorWithRed:128.0f/255 green:128.0f/255 blue:128.0f/255 alpha:0.5]];
  [headerView addSubview:botLine];
  botLine.tag = 111;
  
  UILabel *sectionLabel = (UILabel *)[headerView viewWithTag:100];
  UILabel *optionalLabel = (UILabel *)[headerView viewWithTag:101];
  switch (section) {
    case SECTION_NAME:
      sectionLabel.text = @"NAME";
      optionalLabel.text = @"";
      [topLine removeFromSuperview];
      break;
    case SECTION_ACTIONTYPE:
      sectionLabel.text = @"TYPE OF ACTION";
      optionalLabel.text = @"";
      break;
    case SECTION_DATE:
      sectionLabel.text = @"DATE & TIME";
      optionalLabel.text = @"(Optional)";
      break;
    case SECTION_WEBSITE:
      sectionLabel.text = @"WEBSITE";
      optionalLabel.text = @"(Optional)";
      break;
    case SECTION_HEADER:
      sectionLabel.text = @"HEADER PHOTO";
      optionalLabel.text = @"(Optional)";
      break;
    case SECTION_ABOUT:
      sectionLabel.text = @"ABOUT";
      optionalLabel.text = @"";
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
    
    actionNameField = (UITextField*)[cell viewWithTag:100];
    [actionNameField addTarget:self
                            action:@selector(validateFields)
                  forControlEvents:UIControlEventEditingChanged];
  }
  
  else if(indexPath.section == SECTION_ACTIONTYPE){
    
    NSString *cellIdentifier = kCellIdentifierType;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    actionTypeField = (UITextField*)[cell viewWithTag:100];
  }
  
  else if(indexPath.section == SECTION_DATE){
    
    NSString *cellIdentifier = kCellIdentifierDate;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    actionDateField = (UITextField*)[cell viewWithTag:100];
  }
  
  else if(indexPath.section == SECTION_WEBSITE){
    
    NSString *cellIdentifier = kCellIdentifierWebsite;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    actionWebsiteField = (UITextField*)[cell viewWithTag:100];
  }
  else if(indexPath.section == SECTION_HEADER){
    
    NSString *cellIdentifier = kCellIdentifierHeaderBG;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    headerImagePlaceholder = (UITextField*)[cell viewWithTag:100];
    headerPhotoImageView = (UIImageView*)[cell viewWithTag:101];
  }
  else if(indexPath.section == SECTION_ABOUT){
    
    NSString *cellIdentifier = kCellIdentifierAbout;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    
    aboutPlaceholder = (UITextField*)[cell viewWithTag:100];
    actionAboutField = (UITextView*)[cell viewWithTag:101];
    actionAboutField.delegate = self;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == SECTION_ACTIONTYPE){
    [self actionTypeSelection];
  }
  else if(indexPath.section == SECTION_DATE){
    [self dateSelection];
  }
  else if(indexPath.section == SECTION_HEADER){
    [self headerPhotoSelection];
  }
}

@end


