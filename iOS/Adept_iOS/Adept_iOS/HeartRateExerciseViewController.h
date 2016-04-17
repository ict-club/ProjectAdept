//
//  HeartRateExerciseViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/16/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDBluetoothLowEnergy.h"
#import "CircleView.h"
#import "BluetoothDeviceList.h"
#import "HealthKitIntegration.h"

@interface HeartRateExerciseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RDBluetoothLowEnergyDelegate>

typedef enum
{
    HRTIME = 0,
    HR_BURNED_CALORIES,
    HR_ZONE_MIN,
    HR_ZONE_MAX
}HeartRateTableDataIndex;

@property (weak, nonatomic) IBOutlet CircleView *MainCircleView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * labels;
@property (strong, nonatomic) NSMutableArray * detailTextLabels;
@property (assign, nonatomic) NSInteger selectedType;
@property (weak, nonatomic) id <RDBluetoothLowEnergyDelegate> bluetoothDelegate;
@property (strong, nonatomic) RDBluetoothLowEnergy * bleCommunication;
@property (strong, nonatomic) BluetoothDeviceList * bluetoothDeviceList;
@property (strong, nonatomic) HealthKitIntegration * heathKit;
@property (strong, nonatomic) CBCharacteristic * heartRateCharacteristic;
@property (assign, nonatomic) NSInteger currentHeartRate;
@property (assign, nonatomic) NSInteger trainingTime;
@property (assign, nonatomic) CGFloat burnedCalories;
@property (assign, nonatomic) NSInteger heartRateZoneMin;
@property (assign, nonatomic) NSInteger heartRateZoneMax;

@property (strong, nonatomic) NSTimer * updateTimer;
@end
