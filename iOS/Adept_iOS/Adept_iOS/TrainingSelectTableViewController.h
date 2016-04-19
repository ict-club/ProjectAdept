//
//  TrainingSelectTableViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/29/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerTableCell.h"

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

@property (nonatomic, strong) NSMutableArray * pickerTimeForExerciseData;
@property (nonatomic, strong) NSMutableArray * pickerHardnessData;
@property (nonatomic, strong) NSMutableArray * pickerMuscleGroupData;
@property (nonatomic, strong) NSMutableArray * pickerMinHeartRateData;
@property (nonatomic, strong) NSMutableArray * pickerMaxHeartRateData;

@property (nonatomic, strong) NSMutableDictionary * trainingData;

@property (nonatomic, strong) NSMutableArray * labelData;
@property (nonatomic, strong, getter=detailsLabelData) NSMutableArray * detailsLabelData;

@end
