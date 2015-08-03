//
//  LCCreateCommunity.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCreateCommunity.h"
#import "LCInviteToCommunity.h"
#import "LCCommunityDateSelection.h"


@implementation LCCreateCommunity

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonAction)];
  self.navigationItem.rightBarButtonItem = anotherButton;
  
  float topSpace = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
  //name
  UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  nameLabel.text = @"Name";
  [self.view addSubview:nameLabel];
  topSpace += nameLabel.frame.size.height;
  
  UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  nameField.layer.borderWidth = 1;
  nameField.placeholder = @"Enter the name of your community";
  [self.view addSubview:nameField];
  topSpace += nameField.frame.size.height;
  //about
  UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  aboutLabel.text = @"About";
  [self.view addSubview:aboutLabel];
  topSpace += aboutLabel.frame.size.height;
  
  UITextField *aboutField = [[UITextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  aboutField.layer.borderWidth = 1;
  aboutField.placeholder = @"Few words about your community";
  [self.view addSubview:aboutField];
  topSpace += aboutField.frame.size.height;
  //date
  UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  dateLabel.text = @"Date&Time(optional)";
  [self.view addSubview:dateLabel];
  topSpace += dateLabel.frame.size.height;
  
  UIButton *dateSelection = [[UIButton alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  [dateSelection setTitle:@"Select date and time" forState:UIControlStateNormal];
  [self.view addSubview:dateSelection];
  dateSelection.layer.borderWidth = 1;
  [dateSelection setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [dateSelection addTarget:self action:@selector(dateSelection) forControlEvents:UIControlEventTouchUpInside];
  topSpace += dateSelection.frame.size.height;
  //website
  UILabel *websiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  websiteLabel.text = @"Website(optional)";
  [self.view addSubview:websiteLabel];
  topSpace += websiteLabel.frame.size.height;
  
  UITextField *websiteField = [[UITextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  websiteField.layer.borderWidth = 1;
  websiteField.placeholder = @"Enter the community website";
  [self.view addSubview:websiteField];
  topSpace += websiteField.frame.size.height;
  //headerphoto
  UILabel *headerphotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  headerphotoLabel.text = @"Header photo(optional)";
  [self.view addSubview:headerphotoLabel];
  topSpace += headerphotoLabel.frame.size.height;
  
  UIButton *headerphotoSelection = [[UIButton alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 20)];
  [headerphotoSelection setTitle:@"Select a header photo" forState:UIControlStateNormal];
  [self.view addSubview:headerphotoSelection];
  headerphotoSelection.layer.borderWidth = 1;
  [headerphotoSelection setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [headerphotoSelection addTarget:self action:@selector(headerPhotoSelection) forControlEvents:UIControlEventTouchUpInside];
  topSpace += headerphotoSelection.frame.size.height;
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = false;
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
- (void)nextButtonAction
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCInviteToCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCInviteToCommunity"];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)dateSelection
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCCommunityDateSelection *vc = [sb instantiateViewControllerWithIdentifier:@"LCCommunityDateSelection"];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerPhotoSelection
{
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library", @"From Camera", nil];
  [sheet showInView:self.view];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
