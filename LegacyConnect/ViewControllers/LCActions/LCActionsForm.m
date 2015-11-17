//
//  LCCreateActions.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCActionsForm.h"
#import "LCInviteToActions.h"



@implementation LCActionsForm
@synthesize delegate;


#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
   self.formTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.formTableView reloadData];
  if ([delegate respondsToSelector:@selector(delegatedViewDidLoad)]) {
      [delegate delegatedViewDidLoad];
  }
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
  UITableViewCell *cell = [_formTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]];
  LCDLog(@"%@",cell);
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

- (IBAction)nextButtonOutletAction
{
  if ([LCUtilityManager isaValidWebsiteLink:self.actionWebsiteField.text] || !self.actionWebsiteField.text.length) {
    [self.formTableView endEditing:YES];
    [delegate nextButtonAction];
  }
  else
  {
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Please enter a valid website URL"];
  }
}

- (IBAction)cancelAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteAction:(id)sender
{
  [delegate deleteActionEvent];
}

- (void)dateSelection
{
  [self.formTableView endEditing:YES];
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
  LCActionsDateSelection *vc = [sb instantiateViewControllerWithIdentifier:@"LCActionsDateSelection"];
  vc.startDate = self.startDate;
  vc.endDate = self.endDate;
  vc.delegate = self;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)headerPhotoSelection
{
  [self.formTableView endEditing:YES];
  [delegate selectHeaderPhoto];
}

- (void)actionTypeSelection
{
  [self.formTableView endEditing:YES];
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *eventAction = [UIAlertAction actionWithTitle:@"Event" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    self.actionTypeField.text = action.title;
  }];
  UIAlertAction *challengeAction = [UIAlertAction actionWithTitle:@"Challenge" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    self.actionTypeField.text = action.title;
  }];
  UIAlertAction *pollAction = [UIAlertAction actionWithTitle:@"Poll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    self.actionTypeField.text = action.title;
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
    self.headerImagePlaceholder.hidden = true;
  }
  else
  {
    self.headerImagePlaceholder.hidden = false;
  }
  self.headerPhotoImageView.image = image;
  [self.formTableView reloadData];
}

- (void)validateFields
{
  if (![LCUtilityManager isEmptyString:self.actionAboutField.text] && ![LCUtilityManager isEmptyString:self.actionNameField.text] )
  {
    self.nextButton.enabled = YES;
  }
  else
  {
    self.nextButton.enabled = NO;
  }
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""])
  {
    self.aboutPlaceholder.hidden = false;
  }
  else
  {
    self.aboutPlaceholder.hidden = true;
  }
  [self validateFields];
}


#pragma mark - date selection delegate
- (void)actionDateSelected:(NSDate *)start :(NSDate *)end
{
  self.startDate = start;
  self.endDate = end;
  self.actionDateField.text = [self getActionFormatedDateString:self.startDate];
}

- (NSString *)getActionFormatedDateString :(NSDate *)date
{
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setDateFormat:@"EEEE, MMM dd, yyyy    hh:mm aa"];
  NSString *dateString = [format stringFromDate:self.startDate];
  return dateString;
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
  if (indexPath.section == SECTION_HEADER && self.headerPhotoImageView.image)
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
  return  [delegate tableview:tableView cellForRowAtIndexPathDelegate:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
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


