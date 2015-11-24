//
//  LCProfileViewBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

/* notifications to be handled
 1: created a post - impacts count for self profile
 2: deleted a post - impacts count for self profile
 2: unfriend - friends count for self profile and add friend button state for friend
 3: Add friend - add friend button state for others profile
 4: cancel friend request
 5: Edit profile - for self profile
 */

#import "LCProfileViewBC.h"

@interface LCProfileViewBC ()

@end

@implementation LCProfileViewBC

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
