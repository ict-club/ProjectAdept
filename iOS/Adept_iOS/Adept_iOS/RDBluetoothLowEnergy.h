//
//  BLECommunication.h
//  BLE Moov Color Test
//
//  Created by Martin Kuvandzhiev on 10/17/15.
//  Copyright © 2015 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "RDBluetoothLowEnergyDelegate.h"

enum
{
    NOT_CONNECTED,
    CONNECTING,
    CONNECTED
};

@interface RDBluetoothLowEnergy : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate, RDBluetoothLowEnergyDelegate>
+ (id) sharedInstance;
- (void) searchDevices;
- (void) stopSearchingForDevices;
- (void) setDeviceServicesArrayToLookFor: (NSArray *) deviceServicesArray;
- (void) refreshDeviceList;
- (void) clearDeviceServicesArrayToLookFor;
- (void) waitForDeviceWithName: (NSString *) name;
- (void) connectToDevice: (CBPeripheral * ) peripheral;
- (void) discoverServices;
- (void) writeValue: (NSData *) data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type;
- (void) readValueForCharacteristic: (CBCharacteristic *) characteristic;
- (void) connectToDeviceWithName: (NSString *) name;
- (void) subscribeToCharacteristic: (CBCharacteristic *) characteristic;
- (void) unsubscribeToCharacteristic: (CBCharacteristic  *) characteristic;
- (void) disconnect;
- (void) disconnectDevice:(CBPeripheral *)peripheral;

@property NSData * lastReadData;
@property NSDate * timeLastRead;
@property CBPeripheral * desiredPeripheral;
@property CBCharacteristic * characteristic;
@property CBCentralManager * myCentralMaganer;
@property NSMutableArray * deviceList;
@property NSMutableArray * servicesList;
@property NSMutableArray * characteristicsList;
@property NSString * scanServices;
@property NSArray * serviceUUIDtoLookFor;
@property (nonatomic, weak) id <RDBluetoothLowEnergyDelegate> delegate;

@property int connected;


@end

