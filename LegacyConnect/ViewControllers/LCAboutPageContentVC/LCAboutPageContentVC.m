//
//  LCAboutPageContentVC.m
//  LegacyConnect
//
//  Created by Kaey on 14/03/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCAboutPageContentVC.h"

@interface LCAboutPageContentVC ()

@end

@implementation LCAboutPageContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
  self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
  self.titleLabel.text = NSLocalizedString(self.titleText, nil); ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
