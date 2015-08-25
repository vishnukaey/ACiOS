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


- (IBAction)closeButtonClicked:(id)sender
{
  [self.delegate dismissView];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
  if (textView.text.length>0)
  {
    _placeHolderText.hidden = YES;
  }
  else
  {
    _placeHolderText.hidden = NO;
  }
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

@end
