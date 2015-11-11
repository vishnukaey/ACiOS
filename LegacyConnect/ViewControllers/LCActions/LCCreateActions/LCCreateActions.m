//
//  LCCreateActions.m
//  LegacyConnect
//
//  Created by Jijo on 11/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCCreateActions.h"
#import "LCInviteToActions.h"

@interface LCCreateActions ()

@end

@implementation LCCreateActions
@synthesize actionForm, selectedInterest;

- (void)delegatedViewDidLoad {
    // Do any additional setup after loading the view.
  actionForm.nextButton.enabled = NO;
  actionForm.cancelButton.hidden = true;
  actionForm.imageLoadingIndicator.hidden = true;
}

- (void)nextButtonAction
{
  LCEvent *com = [[LCEvent alloc] init];
  com.name = actionForm.actionNameField.text;
  com.interestID = self.selectedInterest.interestID;
  com.website = actionForm.actionWebsiteField.text;
  com.eventDescription = actionForm.actionAboutField.text;
//  com.time = @"";
  [MBProgressHUD showHUDAddedTo:actionForm.view animated:YES];
  [LCAPIManager createEvent:com havingHeaderPhoto:actionForm.headerPhotoImageView.image withSuccess:^(id response) {
    com.eventID = response[@"data"][@"id"];
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
    LCInviteToActions *vc = [sb instantiateViewControllerWithIdentifier:@"LCInviteToActions"];
    vc.eventToInvite = com;
    [actionForm.navigationController pushViewController:vc animated:YES];
    [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
  }];
  
}

-  (void)selectHeaderPhoto
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      
      UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
      imagePicker.delegate = self;
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
      imagePicker.allowsEditing = NO;
      
      [actionForm presentViewController:imagePicker animated:YES completion:nil];
    }
    
  }];
  UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    
    [actionForm presentViewController:imagePicker animated:YES completion:nil];
    
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  
  [actionSheet addAction:takeAction];
  [actionSheet addAction:chooseAction];
  [actionSheet addAction:cancelAction];
  [actionForm presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:NULL];
  UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
  [actionForm setHeaderImage:chosenImage];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - tableview delegate
- (UITableViewCell *)tableview:(UITableView *)tableview cellForRowAtIndexPathDelegate:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = nil;
  
  if(indexPath.section == SECTION_NAME){
    
    NSString *cellIdentifier = kCellIdentifierName;
    cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    if (!actionForm.actionNameField) {
      actionForm.actionNameField = (UITextField*)[cell viewWithTag:100];
      [actionForm.actionNameField addTarget:actionForm
                                     action:@selector(validateFields)
                           forControlEvents:UIControlEventEditingChanged];
    }
  }
  
  else if(indexPath.section == SECTION_ACTIONTYPE){
    
    NSString *cellIdentifier = kCellIdentifierType;
    cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (!actionForm.actionTypeField) {
      actionForm.actionTypeField = (UITextField*)[cell viewWithTag:100];
    }
  }
  
  else if(indexPath.section == SECTION_DATE){
    
    NSString *cellIdentifier = kCellIdentifierDate;
    cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (!actionForm.actionDateField) {
      actionForm.actionDateField = (UITextField*)[cell viewWithTag:100];
    }
  }
  
  else if(indexPath.section == SECTION_WEBSITE){
    
    NSString *cellIdentifier = kCellIdentifierWebsite;
    cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    if (!actionForm.actionWebsiteField) {
      actionForm.actionWebsiteField = (UITextField*)[cell viewWithTag:100];
    }
  }
  else if(indexPath.section == SECTION_HEADER){
    
    NSString *cellIdentifier = kCellIdentifierHeaderBG;
    cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (!actionForm.headerImagePlaceholder) {
      actionForm.headerImagePlaceholder = (UITextField*)[cell viewWithTag:100];
      actionForm.headerPhotoImageView = (UIImageView*)[cell viewWithTag:101];
      actionForm.imageLoadingIndicator = (UIActivityIndicatorView *)[cell viewWithTag:103];
    }
    if (actionForm.isImageLoading) {
      [actionForm.imageLoadingIndicator startAnimating];
    }
    else
    {
      actionForm.imageLoadingIndicator.hidden = true;
    }
  }
  else if(indexPath.section == SECTION_ABOUT){
    
    NSString *cellIdentifier = kCellIdentifierAbout;
    cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
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
    }
  }
  return cell;
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
