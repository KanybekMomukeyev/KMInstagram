//
//  KMBaseTableVC.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMBaseTableVC.h"

@interface KMBaseTableVC ()

@end

@implementation KMBaseTableVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)currentDeviceIsIphone {
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

@end
