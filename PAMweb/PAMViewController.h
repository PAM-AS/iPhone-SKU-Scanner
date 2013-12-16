//
//  PAMViewController.h
//  PAMweb
//
//  Created by Thomas Sunde Nielsen on 16.12.13.
//  Copyright (c) 2013 PAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReader.h"
#import "MultiFormatOneDReader.h"
#import "ZXingWidgetController.h"

@interface PAMViewController : UIViewController <UIWebViewDelegate, ZXingDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIButton *forwardButton;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;

- (IBAction)back:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)home:(id)sender;

@end
