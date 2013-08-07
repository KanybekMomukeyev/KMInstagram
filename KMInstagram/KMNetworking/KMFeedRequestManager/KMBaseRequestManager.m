//
//  KMBaseRequestManager.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMBaseRequestManager.h"
#import "KMAPIController.h"
#import "KMUserAuthManager.h"
@interface KMBaseRequestManager()
@property (nonatomic, strong) NSDate *lastUpdateDate;
@end

@implementation KMBaseRequestManager

- (NSMutableDictionary *)baseParams
{
    NSString *acessToken = [[[KMAPIController sharedInstance] userAuthManager] getAcessToken];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:acessToken, @"access_token", nil];
    return parameters;
}

@end
