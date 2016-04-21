//
//  ExerciseExecutionViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/29/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDBluetoothLowEnergy.h"
#import "HealthKitIntegration.h"
#import "BluetoothDeviceList.h"


@interface ExerciseExecutionViewController : UIViewController <RDBluetoothLowEnergyDelegate>

@property NSMutableDictionary * exerciseInformation;
@property (nonatomic, strong) NSArray * dataPoints;
@property (nonatomic, strong) RDBluetoothLowEnergy * bleCommunication;
@property (strong, nonatomic) BluetoothDeviceList * bluetoothDeviceList;
@property (strong, nonatomic) HealthKitIntegration * heathKit;
@property (strong, nonatomic) CBCharacteristic * isometricCaracteristic;
@property (assign, nonatomic) NSInteger currentIsometricData;
@property (assign, nonatomic) NSInteger trainingTime;
@property (assign, nonatomic) CGFloat burnedCalories;
@property (assign, nonatomic) NSInteger heartRateZoneMin;
@property (assign, nonatomic) NSInteger heartRateZoneMax;

@property (assign, nonatomic) CBCharacteristic * isometricCharacteristic;


@end
