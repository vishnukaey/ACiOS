//
//  LCActionsImageEditer.h
//  LegacyConnect
//
//  Created by Jijo on 11/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSKImageCropViewController.h"

@protocol LCActionsImageEditerDelegate <NSObject>

- (void)RSKFinishedPickingImage :(UIImage *)image;

@end

@interface LCActionsImageEditer : NSObject<RSKImageCropViewControllerDataSource, RSKImageCropViewControllerDelegate>
{
  UIViewController *presentingController;
}

@property(nonatomic, retain)id delegate;

- (void)presentImageEditorOnController :(UIViewController *)controller witImage:(UIImage *)image;

@end
