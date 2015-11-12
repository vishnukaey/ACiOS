//
//  LCEditActionController.m
//  LegacyConnect
//
//  Created by Jijo on 11/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCEditActions.h"

@implementation LCEditActions
@synthesize actionForm, eventToEdit;
- (void)delegatedViewDidLoad {
  actionForm.backButton.hidden = true;
  actionForm.deleteActionBut.layer.cornerRadius = 5;
  [actionForm.nextButton setTitle:@"Save" forState:UIControlStateNormal];
  
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
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"Delete Action" message:@"Are you sure you want to permanently remove this action from LegacyConnect?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deletePostActionFinal = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [MBProgressHUD showHUDAddedTo:actionForm.view animated:YES];
      
      [LCAPIManager deleteEvent:eventToEdit withSuccess:^(id response) {
        [actionForm.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
      } andFailure:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
      }];

    }];
    [deleteAlert addAction:deletePostActionFinal];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [deleteAlert addAction:cancelAction];
    [actionForm presentViewController:deleteAlert animated:YES completion:nil];  
}

- (void)nextButtonAction
{
  eventToEdit.name = actionForm.actionNameField.text;
  eventToEdit.type = actionForm.actionTypeField.text;
  eventToEdit.startDate = [LCUtilityManager getTimeStampStringFromDate:actionForm.startDate];
  eventToEdit.endDate = [LCUtilityManager getTimeStampStringFromDate:actionForm.endDate];
  eventToEdit.website = actionForm.actionWebsiteField.text;
  eventToEdit.eventDescription = actionForm.actionAboutField.text;
  [MBProgressHUD showHUDAddedTo:actionForm.view animated:YES];
  
  UIImage *imagetoUpload = actionForm.headerPhotoImageView.image;
  if (!headerImageEdited) {
    imagetoUpload = nil;
  }
  [LCAPIManager updateEvent:eventToEdit havingHeaderPhoto:imagetoUpload andImageStatus:headerImageEdited withSuccess:^(id response) {
    [actionForm.navigationController popViewControllerAnimated:YES];
    [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:actionForm.view animated:YES];
  }];
  
}

-  (void)selectHeaderPhoto
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"Edit Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
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
                          [MBProgressHUD hideHUDForView:actionForm.view animated:YES];                      }];
  }];
  
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
  
  UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Header Photo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    headerImageEdited = YES;
    [actionForm setHeaderImage:nil];
  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  
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
    
    NSString *cellIdentifier = kCellIdentifierName;
    cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
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
      actionForm.actionTypeField.text = eventToEdit.type;
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
      actionForm.actionDateField.text = [actionForm getActionFormatedDateString:actionForm.startDate];
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
      actionForm.actionWebsiteField.text = eventToEdit.website;
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
      [self loadCoverImage];
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
      actionForm.actionAboutField.text = eventToEdit.eventDescription;
      if (eventToEdit.eventDescription.length) {
        actionForm.aboutPlaceholder.hidden = true;
      }
    }
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
