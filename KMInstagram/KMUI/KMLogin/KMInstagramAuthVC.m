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

static NSString* const kInstagramClientId = @"c22e560ed1a74621af40ca67e136639f";
static NSString* const kInstagramCallbackUrl = @"http://mail.ru";
static NSString* const kInstagramAuthorizeUrl = @"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&display=touch";

@interface KMInstagramAuthVC ()<UIWebViewDelegate>
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end


@implementation KMInstagramAuthVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *scopes = [NSArray arrayWithObjects:@"likes", @"relationships", @"comments", nil];
    NSString* authenticateURLString = [NSString stringWithFormat:kInstagramAuthorizeUrl, kInstagramClientId, kInstagramCallbackUrl,
                     [scopes componentsJoinedByString:@"+"]];
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    [self.webView loadRequest:request];
    
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                   target:self
                                                                                   action:@selector(cancelButtonDidPressed:)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cancelButtonDidPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *URLString = [[self.webView.request URL] absoluteString];
    if ([[URLString lowercaseString] hasPrefix:[kInstagramCallbackUrl lowercaseString]])
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
    if (self.accessTokenHandler) {
        self.accessTokenHandler(nil, error);
    }
}


@end
