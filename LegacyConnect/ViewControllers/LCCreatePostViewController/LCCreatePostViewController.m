//
//  LCCreatePostViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCreatePostViewController.h"
#import "LCListFriendsToTagViewController.h"
#import "LCListLocationsToTagVC.h"

@interface LCCreatePostViewController ()
{
  LCListFriendsToTagViewController *contactListVC;
}
@end

@implementation LCCreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
  
  _popUpView.layer.cornerRadius = 5;
  
  [_postTextView becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - button actions
- (IBAction)closeButtonClicked:(id)sender
{
  [self.delegate dismissView];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addFriendsToPostButtonClicked:(id)sender
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"CreatePost" bundle:nil];
  contactListVC = [sb instantiateViewControllerWithIdentifier:@"LCListFriendsToTagViewController"];
  [self presentViewController:contactListVC animated:YES completion:nil];
  
}

- (IBAction)addLocationToPostButtonClicked:(id)sender
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"CreatePost" bundle:nil];
  LCListLocationsToTagVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCListLocationsToTagVC"];
  [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)postPhotoButtonClicked
{
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library", @"From Camera", nil];
  [sheet showInView:self.view];
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{

}


#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex < 2)
  {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    switch (buttonIndex)
    {
      case 0:
        type = UIImagePickerControllerSourceTypePhotoLibrary;
        break;
      case 1:
        type = UIImagePickerControllerSourceTypeCamera;
        break;
        
      default:
        break;
    }
    imagePicker.sourceType = type;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{ }];
  }
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:NULL];
  UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
  NSLog(@"image picked-->>%@", chosenImage);
}

@end
