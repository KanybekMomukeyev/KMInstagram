//
//  KMFeedDetailContainerVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMFeedDetailContainerVC.h"
#import "BASegmentedControl.h"
#import "UIView+NIB.h"
#import "KMFeedLikesTVC.h"
#import "KMFeedCommentsTVC.h"

@interface KMFeedDetailContainerVC ()
@property (nonatomic, strong) BASegmentedControl *segMentedControl;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) IBOutlet UIView *navcontrollerView;

@property (nonatomic, strong) KMFeedLikesTVC *likesTVC;
@property (nonatomic, strong) KMFeedCommentsTVC *commentsTVC;
@end

@implementation KMFeedDetailContainerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navController = [UINavigationController new];
    self.navController.navigationBarHidden = YES;
    self.navController.view.frame = self.navcontrollerView.frame;
    [self addChildViewController:self.navController];
    [self.view addSubview:self.navController.view];
    
    self.likesTVC = [[KMFeedLikesTVC alloc] initWithIphoneFromNib];
    self.commentsTVC = [[KMFeedCommentsTVC alloc] initWithIphoneFromNib];
    [self.navController setViewControllers:@[self.likesTVC] animated:YES];
    
    __weak KMFeedDetailContainerVC *self_ = self;
    self.segMentedControl = [BASegmentedControl loadFromNIB];
    self.segMentedControl.buttonPressHanfler = ^(NSNumber *senderTag) {
        if ([senderTag integerValue] == 0) {
            [self_.navController setViewControllers:@[self_.likesTVC] animated:YES];
        }else {
            [self_.navController setViewControllers:@[self_.commentsTVC] animated:YES];
        }
    };
    UIBarButtonItem *segmentBarItem3 = [[UIBarButtonItem alloc] initWithCustomView:self.segMentedControl];
    self.navigationItem.rightBarButtonItem = segmentBarItem3;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
