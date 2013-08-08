//
//  KMLoginVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMLoginVC.h"
#import "KMInstagramAuthVC.h"
#import "KMUserFeedTVC.h"
#import "KMAPIController.h"
#import "KMUserAuthManager.h"

@interface KMLoginVC ()
@end

@implementation KMLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[[KMAPIController sharedInstance] userAuthManager] getAcessToken]) {
        [self moveToMainUserFriendsTVC];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonDidPressed:(id)sender
{
    
    KMInstagramAuthVC *instagramAuthVC = nil;
    if (self.currentDeviceIsIphone)
        instagramAuthVC = [[KMInstagramAuthVC alloc] initWithIphoneFromNib];
    else
        instagramAuthVC = [[KMInstagramAuthVC alloc] initWithIpadFromNib];
    
    __weak KMLoginVC *self_ = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:instagramAuthVC];
    instagramAuthVC.accessTokenHandler = ^(NSString *acessToken, NSError *error) {
        [navController dismissViewControllerAnimated:YES completion:^(){
            if (acessToken) {
                [[[KMAPIController sharedInstance] userAuthManager] setAccessToke:acessToken];
                [self_ moveToMainUserFriendsTVC];
            }else {
                [self_ showAlertWithError:error];
            }
        }];
    };
    
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)moveToMainUserFriendsTVC
{
    KMUserFeedTVC *userFeedTVC = [[KMUserFeedTVC alloc] initWithIphoneFromNib];
    [self.navigationController setViewControllers:@[userFeedTVC] animated:YES];
}



@end
