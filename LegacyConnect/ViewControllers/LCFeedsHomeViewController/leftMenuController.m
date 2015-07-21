//
//  leftMenuController.m
//  LegacyConnect
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "leftMenuController.h"

@interface leftMenuController ()

@end

@implementation leftMenuController

@synthesize P_menuwidth, delegate_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor lightTextColor]];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, P_menuwidth, 50)];
    but.backgroundColor = [UIColor blueColor];
    [self.view addSubview:but];
    but.tag = 1;
    [but addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

-(void)buttonActions :(UIButton *)sender
{
    [delegate_ leftMenuButtonActions:sender];
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
