//
//  RDBluetoothLowEnergyDevice.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/11/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothDevice : NSObject

@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) NSString * deviceName;
@property (nonatomic, assign) BOOL available;
@property (nonatomic, strong) CBPeripheral * device;

@end
