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

@interface HeartRateExerciseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RDBluetoothLowEnergyDelegate>

@property (weak, nonatomic) IBOutlet CircleView *MainCircleView;
@property (assign, nonatomic) NSInteger selectedType;
@property (weak, nonatomic) id <RDBluetoothLowEnergyDelegate> bluetoothDelegate;
@property (strong, nonatomic) RDBluetoothLowEnergy * bleCommunication;
@property (strong, nonatomic) BluetoothDeviceList * bluetoothDeviceList;

@end
