//
//  LCFeedDetailBC.m
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

/* notifications to be handled
 1: liked a post
 2: unliked post
 3: commented a post - comment should be added to table and count should be increased
 4: Updated a post
 5: deleted a post - not included now as it will affect the navigation flow
 6: user profile updated
 7: remove milestone - if milestone icon is shown in feed detail
 */

#import "LCFeedDetailBC.h"

@interface LCFeedDetailBC ()

@end

@implementation LCFeedDetailBC

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
