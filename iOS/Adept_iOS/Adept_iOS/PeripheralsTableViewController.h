//
//  PeripheralsTableViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/28/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceConnectionStateTableViewCell.h"

@interface PeripheralsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray * deviceNamesArray;
@property (nonatomic, strong) NSArray * deviceIDArray;

@end
