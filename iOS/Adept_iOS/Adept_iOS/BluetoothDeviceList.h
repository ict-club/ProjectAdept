//
//  BluetoothDeviceList.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/12/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BluetoothDevice.h"

@interface BluetoothDeviceList : NSArray

+(id) sharedInstance;

@property (nonatomic, strong) BluetoothDevice * taoDevice;
@property (nonatomic, strong) BluetoothDevice * moovDevice;
@property (nonatomic, strong) BluetoothDevice * heartRateDevice;
@property (nonatomic, strong) BluetoothDevice * adeptDevice;
@property (nonatomic, strong) BluetoothDevice * appleWatch;

@end
