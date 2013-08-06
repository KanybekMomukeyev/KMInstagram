//
//  KMBaseVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMBaseVC.h"

@interface KMBaseVC ()

@end

@implementation KMBaseVC

- (void)dealloc {
    NSLog(@"[%@ %@];", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (id)initWithIphoneFromNib
{
    self = [self initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
    }
    return self;
}


- (id)initWithIpadFromNib
{
    self = [self initWithNibName:[NSString stringWithFormat:@"%@_Ipad",NSStringFromClass(self.class)] bundle:nil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)currentDeviceIsIphone
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}


- (void)showAlertWithError:(NSError *)error
{
    UIAlertView *alert_ = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:[error localizedDescription]
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
    [alert_ show];
}


- (void)showAlertWithTitle:(NSString *)title
{
    UIAlertView *alert_ = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:title
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
    [alert_ show];
}




@end
