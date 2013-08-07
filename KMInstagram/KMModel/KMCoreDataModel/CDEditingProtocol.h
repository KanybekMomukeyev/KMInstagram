//
//  CDEditingProtocol.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CDEditingProtocol <NSObject>
@required
- (void)setWithDictionary:(NSDictionary *)dict;
@end