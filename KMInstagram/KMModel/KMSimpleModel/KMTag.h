//
//  KMTag.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMTag : NSObject
@property (readonly, nonatomic, strong) NSString *tagName;
- (id)initWithString:(NSString *)tagName;
@end

/*
"tags": [
         "watches",
         "swisswatches",
         "swissmade"
        ],
*/