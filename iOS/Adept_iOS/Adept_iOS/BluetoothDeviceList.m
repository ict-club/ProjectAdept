//
//  BluetoothDeviceList.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/12/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "BluetoothDeviceList.h"

@implementation BluetoothDeviceList

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (instancetype) init
{

    if(self)
    {
        self.taoDevice = [[BluetoothDevice alloc] init];
        self.taoDevice.displayName = @"Tao-Wellshell 01";
        self.taoDevice.deviceName = @"TAO-AA-0246";
        
        self.taoDevice2 = [[BluetoothDevice alloc] init];
        self.taoDevice2.deviceName = @"TAO-AA-0375";
        self.taoDevice2.displayName = @"Tao-Wellshell 02";
        
        
        self.moovDevice = [[BluetoothDevice alloc] init];
        self.moovDevice.displayName = @"Moov";
        self.moovDevice.deviceName = @"Moov";
        
        self.heartRateDevice = [[BluetoothDevice alloc] init];
        self.heartRateDevice.displayName = @"Heart Rate Sensor";
        self.heartRateDevice.deviceName = @"Heart Rate Sensor";
        
        self.adeptDevice = [[BluetoothDevice alloc] init];
        self.adeptDevice.displayName = @"Adept Stick";
        self.adeptDevice.deviceName = @"AdeptStick";
        
        self.appleWatch = [[BluetoothDevice alloc] init];
        self.appleWatch.displayName = @"Apple watch";
        self.appleWatch.deviceName = @"AppleFukinWatch";
        self = [super init];
        self = (BluetoothDeviceList *)[NSArray arrayWithObjects:self.adeptDevice, self.moovDevice, self.taoDevice, self.taoDevice2, self.heartRateDevice, self.appleWatch, nil];
        
    }
    return self;
}

@end
