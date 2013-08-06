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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonDidPressed:(id)sender
{
    KMInstagramAuthVC *instagramAuthVC = [[KMInstagramAuthVC alloc] initWithIphoneFromNib];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:instagramAuthVC];
    [self presentViewController:navController animated:YES completion:nil];
    
    
    __weak KMLoginVC *self_ = self;
    instagramAuthVC.accessTokenHandler = ^(NSString *acessToken, NSError *error) {
        [navController dismissViewControllerAnimated:YES completion:^(){
            if (acessToken) {
                KMUserFeedTVC *userFeedTVC = [[KMUserFeedTVC alloc] initWithIphoneFromNib];
                [[[KMAPIController sharedInstance] userAuthManager] setAccessToke:acessToken];
                [self_.navigationController setViewControllers:@[userFeedTVC] animated:YES];
            }else {
                [self_ showAlertWithError:error];
            }
        }];
    };
}


@end
