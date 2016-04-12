//
//  PeripheralsTableViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/28/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceConnectionStateTableViewCell.h"
#import "RDBluetoothLowEnergy.h"
#import "BluetoothDevice.h"

@interface PeripheralsTableViewController : UITableViewController <RDBluetoothLowEnergyDelegate>

@property (nonatomic, strong) NSArray * deviceNamesArray;
@property (nonatomic, strong) NSArray * deviceIDArray;
@property (nonatomic, strong) RDBluetoothLowEnergy * bleCommunication;
@property (nonatomic, strong) NSArray * bluetoothDevices;
@property (nonatomic, strong) BluetoothDevice * taoDevice;
@property (nonatomic, strong) BluetoothDevice * moovDevice;
@property (nonatomic, strong) BluetoothDevice * heartRateDevice;
@property (nonatomic, strong) BluetoothDevice * adeptDevice;
@property (nonatomic, strong) BluetoothDevice * appleWatch;

@end
