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
  LCDLog(@"%@",[_formTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]]);
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
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"website_validation_error_message", nil)];
  }
}

- (IBAction)cancelAction
{
  [delegate cancelAction];
}

- (IBAction)deleteAction:(id)sender
{
  [delegate deleteActionEvent];
}

- (void)dateSelection
{
  [self.formTableView endEditing:YES];
  UIStoryboard*  actionsSB = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
  LCActionsDateSelection *dateSelectorVC = [actionsSB instantiateViewControllerWithIdentifier:@"LCActionsDateSelection"];
  dateSelectorVC.startDate = self.startDate;
  dateSelectorVC.endDate = self.endDate;
  dateSelectorVC.delegate = self;
  [self presentViewController:dateSelectorVC animated:YES completion:nil];
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
  
  UIAlertAction *eventAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_type_event", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    self.actionTypeField.text = action.title;
    [self validateFields];
  }];
  UIAlertAction *challengeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_type_challenge", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    self.actionTypeField.text = action.title;
    [self validateFields];
  }];
  UIAlertAction *pollAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_type_poll", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    self.actionTypeField.text = action.title;
    [self validateFields];
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
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
  [self validateFields];
}

- (void)validateFields
{
  self.nextButton.enabled = YES;
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
  [self validateFields];
}

- (NSString *)getActionFormatedDateString :(NSDate *)date
{
  NSDateFormatter *format = [[NSDateFormatter alloc] init];
  [format setDateFormat:@"EEEE, MMM dd, yyyy    hh:mm aa"];
  NSString *dateString = [format stringFromDate:date];
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

- (void)setTableViewSectionLabelsInHeaderView :(UIView *)headerView forSection:(NSInteger)section
{
  UILabel *sectionLabel = (UILabel *)[headerView viewWithTag:100];
  UILabel *optionalLabel = (UILabel *)[headerView viewWithTag:101];
  UIView *topLine = [headerView viewWithTag:111];
  switch (section) {
    case SECTION_NAME:
      sectionLabel.text = NSLocalizedString(@"action_form_name", nil);
      optionalLabel.text = @"";
      [topLine removeFromSuperview];
      break;
    case SECTION_ACTIONTYPE:
      sectionLabel.text = NSLocalizedString(@"action_form_action_type", nil);
      optionalLabel.text = @"";
      break;
    case SECTION_DATE:
      sectionLabel.text = NSLocalizedString(@"action_form_date_time", nil);
      optionalLabel.text = NSLocalizedString(@"action_form_optional", nil);
      break;
    case SECTION_WEBSITE:
      sectionLabel.text = NSLocalizedString(@"action_form_website", nil);
      optionalLabel.text = NSLocalizedString(@"action_form_optional", nil);
      break;
    case SECTION_HEADER:
      sectionLabel.text = NSLocalizedString(@"action_form_header_photo", nil);
      optionalLabel.text = NSLocalizedString(@"action_form_optional", nil);
      break;
    case SECTION_ABOUT:
      sectionLabel.text = NSLocalizedString(@"action_form_about", nil);
      optionalLabel.text = @"";
      break;
      
    default:
      break;
  }
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
  [self setTableViewSectionLabelsInHeaderView:headerView forSection:section];
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


