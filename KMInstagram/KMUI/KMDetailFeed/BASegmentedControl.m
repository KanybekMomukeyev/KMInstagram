//
//  BASegmentedControl.m
//  BankAsiya
//
//  Created by Kanybek Momukeev on 10/15/12.
//  Copyright (c) 2012 Kanybek Momukeev. All rights reserved.
//

#import "BASegmentedControl.h"
@interface BASegmentedControl()
@end

@implementation BASegmentedControl

- (void)dealloc {
    self.buttonPressHanfler = NULL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)segmentedControlSelected:(UISegmentedControl *)sender {
    if (self.buttonPressHanfler) {
        self.buttonPressHanfler(@(sender.selectedSegmentIndex));
    }
}

@end
