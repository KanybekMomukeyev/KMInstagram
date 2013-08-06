//
//  KMInstagramAuthVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMInstagramAuthVC.h"
#import "NSString+KMQueryString.h"
#import "NSError+KMAdditions.h"
#import "KMInstagramSettings.h"


static NSString* const kInstagramAuthorizeUrl = @"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&display=touch";

@interface KMInstagramAuthVC ()<UIWebViewDelegate>
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end


@implementation KMInstagramAuthVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* authenticateURLString = [NSString stringWithFormat:kInstagramAuthorizeUrl, [KMInstagramSettings clientId],
                                       [KMInstagramSettings callbackUrl], [[KMInstagramSettings scopes] componentsJoinedByString:@"+"]];
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    [self.webView loadRequest:request];
    
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                   target:self
                                                                                   action:@selector(cancelButtonDidPressed:)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
    
    
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cancelButtonDidPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)startActivity
{
    [(UIActivityIndicatorView *)self.navigationItem.leftBarButtonItem.customView startAnimating];
}

- (void)stopActivity
{
    [(UIActivityIndicatorView *)self.navigationItem.leftBarButtonItem.customView stopAnimating];
}



#pragma mark - Web view delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    [self startActivity];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopActivity];
    NSString *URLString = [[self.webView.request URL] absoluteString];
    if ([[URLString lowercaseString] hasPrefix:[[KMInstagramSettings callbackUrl] lowercaseString]])
    {
        NSRange tokenRange = [[URLString lowercaseString] rangeOfString:@"#access_token="];
        if (tokenRange.location != NSNotFound)
        {
            NSString* token = [URLString substringFromIndex:tokenRange.location + tokenRange.length];
            if (self.accessTokenHandler) {
                self.accessTokenHandler(token, nil);
            }
        }
        else {
            // Error, should be something like:
            // error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request
            NSDictionary* params = [URLString dictionaryFromQueryComponents];
            if (self.accessTokenHandler) {
                self.accessTokenHandler(nil, [NSError errorWithString:[params objectForKey:@"error_description"]]);
            }
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopActivity];
    if (self.accessTokenHandler) {
        self.accessTokenHandler(nil, error);
    }
}


@end
