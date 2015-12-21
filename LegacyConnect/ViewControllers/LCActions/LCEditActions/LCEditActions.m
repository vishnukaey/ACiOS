//
//  LCEditActionController.m
//  LegacyConnect
//
//  Created by Jijo on 11/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCEditActions.h"
#import "LCEventAPImanager.h"

@implementation LCEditActions
@synthesize actionForm, eventToEdit;
- (void)delegatedViewDidLoad {
  actionForm.backButton.hidden = true;
  actionForm.deleteActionBut.layer.cornerRadius = 5;
  [actionForm.nextButton setTitle:NSLocalizedString(@"save", @"next button title") forState:UIControlStateNormal];
  actionForm.nextButton.enabled = NO;
  
  if ([eventToEdit.startDate integerValue] != 0) {
    actionForm.startDate = [NSDate dateWithTimeIntervalSince1970:eventToEdit.startDate.longLongValue/1000];
  }
  if ([eventToEdit.endDate integerValue] != 0) {
    actionForm.endDate = [NSDate dateWithTimeIntervalSince1970:eventToEdit.endDate.longLongValue/1000];
  }
    // Do any additional setup after loading the view.
  
}

- (void)deleteActionEvent
{
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"delete_action", nil) message:NSLocalizedString(@"delete_action_message", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deletePostActionFinal = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [MBProgressHUD showHUDAddedTo:actionForm.view animated:YES];
      
      [LCEventAPImanager deleteEvent:eventToEdit withSuccess:^(id response) {
        [actionForm dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
      } andFailure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
      }];

    }];
    [deleteAlert addAction:deletePostActionFinal];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [deleteAlert addAction:cancelAction];
    [actionForm presentViewController:deleteAlert animated:YES completion:nil];  
}

- (void)nextButtonAction
{
  eventToEdit.name = [LCUtilityManager getSpaceTrimmedStringFromString:actionForm.actionNameField.text];
  eventToEdit.type = actionForm.actionTypeField.text;
  eventToEdit.startDate = [LCUtilityManager getTimeStampStringFromDate:actionForm.startDate];
  eventToEdit.endDate = [LCUtilityManager getTimeStampStringFromDate:actionForm.endDate];
  eventToEdit.website = actionForm.actionWebsiteField.text;
  eventToEdit.eventDescription = [LCUtilityManager getSpaceTrimmedStringFromString:actionForm.actionAboutField.text];
  [MBProgressHUD showHUDAddedTo:actionForm.view animated:YES];
  
  UIImage *imagetoUpload = actionForm.headerPhotoImageView.image;
  BOOL statusRemoved = NO;
  if (!imagetoUpload) {
    statusRemoved = YES;
  }
  if (!headerImageEdited) {
    imagetoUpload = nil;
  }
  [LCEventAPImanager updateEvent:eventToEdit havingHeaderPhoto:imagetoUpload andImageStatus:statusRemoved withSuccess:^(id response) {
    [actionForm dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
  }];
  
}

- (void)cancelAction
{
  [actionForm dismissViewControllerAnimated:YES completion:nil];
}

-  (void)selectHeaderPhoto
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *editAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"edit_photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    if (headerImageEdited) {
        [self startImageEditing:actionForm.headerPhotoImageView.image];
    }
    else
    {
        NSString *headerUrlString = eventToEdit.headerPhoto;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [MBProgressHUD showHUDAddedTo:actionForm.view animated:YES];
        [manager downloadImageWithURL:[NSURL URLWithString:headerUrlString]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                              if (image) {
                                [self startImageEditing:image];
                              }
                              [MBProgressHUD hideHUDForView:actionForm.view animated:YES];
         }];
    }
  }];
  
  UIAlertAction *takeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"take_photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      
      UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
      imagePicker.delegate = self;
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
      imagePicker.allowsEditing = NO;
      [actionForm presentViewController:imagePicker animated:YES completion:nil];
    }
    
  }];
  
  UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"choose_from_library", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    [actionForm presentViewController:imagePicker animated:YES completion:nil];
    
  }];
  
  UIAlertAction *removeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"remove_header_photo", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    headerImageEdited = YES;
    [actionForm setHeaderImage:nil];
  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  
  if (actionForm.headerPhotoImageView.image){
    [actionSheet addAction:editAction];
    [actionSheet addAction:removeAction];
  }
  [actionSheet addAction:takeAction];
  [actionSheet addAction:chooseAction];
  [actionSheet addAction:cancelAction];
  
  [actionForm presentViewController:actionSheet animated:YES completion:nil];
}

- (void)startImageEditing :(UIImage *)image
{
  imageCroper = [[LCActionsImageEditer alloc] init];
  imageCroper.delegate = self;
  [imageCroper presentImageEditorOnController:actionForm witImage:image];
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:NULL];
  UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
  [self startImageEditing:chosenImage];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:NULL];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)RSKFinishedPickingImage:(UIImage *)image
{
  headerImageEdited = YES;
  [actionForm setHeaderImage:image];
}

#pragma mark - TableView delegates

- (UITableViewCell *)tableview:(UITableView *)tableview cellForRowAtIndexPathDelegate:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = nil;
  
  if(indexPath.section == SECTION_NAME){
    cell = [self getNameSectionCellForTableView:tableview];
  }
  else if(indexPath.section == SECTION_ACTIONTYPE){
    cell = [self getActionTypeCellForTableView:tableview];
  }
  else if(indexPath.section == SECTION_DATE){
    cell = [self getDateSectionCellForTableView:tableview];
  }
  else if(indexPath.section == SECTION_WEBSITE){
    cell = [self getWebSiteSectionCellForTableView:tableview];
  }
  else if(indexPath.section == SECTION_HEADER){
    cell = [self getHeaderImageSectionCellForTableView:tableview];
  }
  else if(indexPath.section == SECTION_ABOUT){
    cell = [self getAboutSectionCellForTableView:tableview];
  }
  return cell;
}

- (UITableViewCell*)getAboutSectionCellForTableView:(UITableView*)tabelView
{
  NSString *cellIdentifier = kCellIdentifierAbout;
  UITableViewCell * cell = [tabelView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  if (!actionForm.aboutPlaceholder) {
    actionForm.aboutPlaceholder = (UITextField*)[cell viewWithTag:100];
  }
  if (!actionForm.actionAboutField) {
    actionForm.actionAboutField = (UITextView*)[cell viewWithTag:101];
    actionForm.actionAboutField.delegate = actionForm;
    actionForm.actionAboutField.text = eventToEdit.eventDescription;
    if (eventToEdit.eventDescription.length) {
      actionForm.aboutPlaceholder.hidden = true;
    }
  }
  return cell;
}

- (UITableViewCell*)getHeaderImageSectionCellForTableView:(UITableView*)tabelView
{
  NSString *cellIdentifier = kCellIdentifierHeaderBG;
  UITableViewCell * cell = [tabelView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  if (!actionForm.headerImagePlaceholder) {
    actionForm.headerImagePlaceholder = (UITextField*)[cell viewWithTag:100];
    actionForm.headerPhotoImageView = (UIImageView*)[cell viewWithTag:101];
    actionForm.imageLoadingIndicator = (UIActivityIndicatorView *)[cell viewWithTag:103];
    [self loadCoverImage];
  }
  
  if (actionForm.isImageLoading) {
    [actionForm.imageLoadingIndicator startAnimating];
  }
  else
  {
    actionForm.imageLoadingIndicator.hidden = true;
  }
  return cell;
}

- (UITableViewCell*)getDateSectionCellForTableView:(UITableView*)tableView
{
  NSString *cellIdentifier = kCellIdentifierDate;
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  if (!actionForm.actionDateField) {
    actionForm.actionDateField = (UITextField*)[cell viewWithTag:100];
    actionForm.actionDateField.text = [actionForm getActionFormatedDateString:actionForm.startDate];
  }
  return cell;
}

- (UITableViewCell*)getNameSectionCellForTableView:(UITableView*)tableView
{
  NSString *cellIdentifier = kCellIdentifierName;
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  if (!actionForm.actionNameField) {
    actionForm.actionNameField = (UITextField*)[cell viewWithTag:100];
    actionForm.actionNameField.text = eventToEdit.name;
    [actionForm.actionNameField addTarget:actionForm
                                   action:@selector(validateFields)
                         forControlEvents:UIControlEventEditingChanged];
  }
  
  return cell;
}

- (UITableViewCell*)getActionTypeCellForTableView:(UITableView*)tableView
{
  NSString *cellIdentifier = kCellIdentifierType;
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  if (!actionForm.actionTypeField) {
    actionForm.actionTypeField = (UITextField*)[cell viewWithTag:100];
    actionForm.actionTypeField.text = eventToEdit.type;
  }
  return cell;
}

- (UITableViewCell*)getWebSiteSectionCellForTableView:(UITableView*)tableView
{
  NSString *cellIdentifier = kCellIdentifierWebsite;
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
  }
  if (!actionForm.actionWebsiteField) {
    actionForm.actionWebsiteField = (UITextField*)[cell viewWithTag:100];
    actionForm.actionWebsiteField.text = eventToEdit.website;
    [actionForm.actionWebsiteField addTarget:actionForm
                                      action:@selector(validateFields)
                            forControlEvents:UIControlEventEditingChanged];
  }
  return cell;
}

- (void)loadCoverImage
{
  if (eventToEdit.headerPhoto.length) {
    actionForm.isImageLoading = true;
    actionForm.headerImagePlaceholder.hidden = true;
    actionForm.imageLoadingIndicator.hidden = false;
    [actionForm.imageLoadingIndicator startAnimating];
    [actionForm.headerPhotoImageView sd_setImageWithURL:[NSURL URLWithString:eventToEdit.headerPhoto] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
       dispatch_async(dispatch_get_main_queue(), ^{
         [actionForm.imageLoadingIndicator stopAnimating];
         actionForm.imageLoadingIndicator.hidden = true;
         actionForm.isImageLoading = false;
         if (image && !actionForm.headerPhotoImageView.image)
         {
           [actionForm setHeaderImage:image];
         }
         [actionForm.formTableView reloadData];
       });
       
     }];
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
