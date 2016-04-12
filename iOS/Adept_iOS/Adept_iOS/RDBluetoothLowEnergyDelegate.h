//
//  IRDBluetoothLowEnergy.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/10/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.

#import "RDBluetoothLowEnergy.h"

@class RDBluetoothLowEnergy;

@protocol RDBluetoothLowEnergyDelegate <NSObject>

@optional

- (void) newDeviceFound: (RDBluetoothLowEnergy *) bluetoothLowEnergy;
- (void) didConnectDevice: (CBPeripheral *) device;
- (void) didDiscoverServices: (RDBluetoothLowEnergy *) bluetoothLowEnergy;
- (void) didDiscoverCharacteristics: (RDBluetoothLowEnergy *) bluetoothLowEnergy;
- (void) didUpdateValueForCharacteristic: (RDBluetoothLowEnergy *) bluetoothLowEnergy andData: (NSData *) data;
- (void) didWriteValueForCharacteristic: (RDBluetoothLowEnergy *) bluetoothLowEnergy;

@end

