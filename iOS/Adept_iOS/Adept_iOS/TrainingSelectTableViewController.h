//
//  TrainingSelectTableViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/29/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TrainingSelectEnum) {
    MoovTraining,
    WellshellTraining,
    UniversalTraining,
    AppleWatchTraining,
    AdeptStickTraining,
    OtherTraining
};

@interface TrainingSelectTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) NSInteger selectedType;

@end
