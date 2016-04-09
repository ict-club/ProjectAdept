//
//  DeviceConnectionStateTableViewCell.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/10/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"

@interface DeviceConnectionStateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CircleView *StatusCircleView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;


@end
