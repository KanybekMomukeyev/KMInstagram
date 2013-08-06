//
//  KMUserAuthManager.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMUserAuthManager : NSObject

- (void)setAccessToke:(NSString *)acessToken;
- (NSString *)getAcessToken;
- (void)logOut;

@end
