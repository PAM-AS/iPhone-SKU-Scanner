//
//  PAMViewController.m
//  PAMweb
//
//  Created by Thomas Sunde Nielsen on 16.12.13.
//  Copyright (c) 2013 PAM. All rights reserved.
//

#import "PAMViewController.h"

@interface PAMViewController ()

@end

@implementation PAMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self home:nil];
}

#pragma mark - IBActions
- (IBAction)back:(id)sender
{
    [self checkButtons];
    if (self.webView.canGoBack)
        [self.webView goBack];
}

- (IBAction)forward:(id)sender
{
    [self checkButtons];
    if (self.webView.canGoForward)
        [self.webView goForward];
}

- (IBAction)home:(id)sender
{
    [self checkButtons];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://emberjs.jsbin.com/iVoxUYip/8"]]];
}

- (void)checkButtons
{
    if (self.webView.canGoForward)
        [self.forwardButton setEnabled:YES];
    else
        [self.forwardButton setEnabled:NO];
    if (self.webView.canGoBack)
        [self.backButton setEnabled:YES];
    else
        [self.backButton setEnabled:NO];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self checkButtons];
    NSString *js = @"$('input[type=sku]').focus(function(){window.open('http://scanbarcode.pam', '_self')});";
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self checkButtons];
    NSString *url = [[request URL] absoluteString];
    NSString *scanString = @"http://scanbarcode.pam";
    
    NSLog(@"Opening %@, comparing with %@", [url substringToIndex:scanString.length], scanString);
    if (url.length >= scanString.length && [[url substringToIndex:scanString.length] isEqualToString:scanString])
    {
        [self scan];
        return NO;
    }
    return YES;
}

- (void)scan
{
    ZXingWidgetController *wc = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO showLicense:NO];
    
    QRCodeReader *qRCodeReader = [[QRCodeReader alloc] init];
    MultiFormatOneDReader *oneDReader = [[MultiFormatOneDReader alloc] init];
    NSSet *readers = [[NSSet alloc] initWithObjects:qRCodeReader, oneDReader,nil];
    wc.readers = readers;
    
    [self presentViewController:wc animated:YES completion:nil];
}

#pragma mark - ZXingDelegate
- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    NSLog(@"Scanned %@", result);
    NSString *js = [NSString stringWithFormat:@"$('input[type=sku]').val(%@);", result];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
