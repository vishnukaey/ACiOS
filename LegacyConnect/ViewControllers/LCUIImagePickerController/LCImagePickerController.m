//
//  LCImagePickerController.m
//  LegacyConnect
//
//  Created by Jijo on 1/25/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LCImagePickerController ()

@end

@implementation LCImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
  
  if (status != ALAuthorizationStatusAuthorized) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"attention", nil) message:NSLocalizedString(@"access_denied_error_message_photo_library", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"close", nil) otherButtonTitles:nil, nil];
    [alert show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self dismissViewControllerAnimated:YES completion:nil];
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

@end
