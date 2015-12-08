//
//  WebViewVC.h
//  STTwitterDemoIOS
//
//  Created by Nicolas Seriot on 06/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TWItterWebViewDelegate <NSObject>

- (void)webViewCancelledTwitterAuth;

@end

@interface LCTWWebViewVC : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, weak)id delegate;

- (IBAction)cancel:(id)sender;

@end
