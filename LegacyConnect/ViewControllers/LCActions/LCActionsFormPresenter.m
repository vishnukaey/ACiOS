//
//  LCActionsFormPresenter.m
//  LegacyConnect
//
//  Created by Jijo on 11/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCActionsFormPresenter.h"
#import "LCCreateActions.h"
#import "LCEditActions.h"

@implementation LCActionsFormPresenter

+ (LCActionsForm *)getCreateActionsControllerWithInterest :(LCInterest *)interest
{
  UIStoryboard*  s_board = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
  LCActionsForm *controller = [s_board instantiateViewControllerWithIdentifier:@"LCActionsForm"];
  
  LCCreateActions *obj = [[LCCreateActions alloc] init];
  controller.delegate = obj;
  obj.actionForm = controller;
  obj.selectedInterest = interest;
  return controller;
}

+ (LCActionsForm *)getEditActionsControllerWithEvent :(LCEvent *)event
{
  UIStoryboard*  s_board = [UIStoryboard storyboardWithName:@"Actions" bundle:nil];
  LCActionsForm *controller = [s_board instantiateViewControllerWithIdentifier:@"LCActionsForm"];
  
  LCEditActions *obj = [[LCEditActions alloc] init];
  controller.delegate = obj;
  obj.actionForm = controller;
  obj.eventToEdit = event;
  return controller;
}

@end
