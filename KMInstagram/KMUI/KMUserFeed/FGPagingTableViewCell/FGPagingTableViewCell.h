//
//  FGPagingTableViewCell.h
//  FGPagedTableViewController
//
//  Copyright (c) 2012 Fern Glow, LLC (http://fernglow.com) All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
	FGPagingCellTypeNone		= 300,
	FGPagingCellTypeContinue	= 301,
	FGPagingCellTypeRetrieving	= 302
} FGPagingCellType;

@interface FGPagingTableViewCell : UITableViewCell

/** @name Manging Text as Cell Content */

/**
 Returns the label used for the main textual content of the paging table view cell. (read-only)
 */
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;


/**
 Returns the secondary label of the paging table view cell. (read-only)
 */
@property (nonatomic, strong) IBOutlet UILabel *detailsLabel;


/**
 Returns the activity indicator view the table view cell. (read-only)
 */
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinnerView;


/**
 The type of paging table view cell.
 */
@property (nonatomic, assign) FGPagingCellType cellType;

@end
