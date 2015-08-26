//
//  LCSearchViewController.m
//  LegacyConnect
//
//  Created by qbuser on 8/26/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSearchViewController.h"

@interface LCSearchViewController ()

@end

@implementation LCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self.searchBar becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchCancelButtonClicked:(UIButton *)cancelButton
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
