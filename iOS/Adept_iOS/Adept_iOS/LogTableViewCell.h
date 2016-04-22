//
//  LogTableViewCell.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/22/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *logTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@end
