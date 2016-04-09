//
//  BLECommunication.m
//  BLE Moov Color Test
//
//  Created by Martin Kuvandzhiev on 10/17/15.
//  Copyright © 2015 Martin Kuvandzhiev. All rights reserved.
//

#import "RDBluetoothLowEnergy.h"

@implementation RDBluetoothLowEnergy
@synthesize lastReadData, timeLastRead, serviceUUIDtoLookFor;

- (void) initialize
{
    
    self.characteristic = [CBCharacteristic alloc];
    self.myCentralMaganer = [[CBCentralManager alloc] init];
    self.connected = false;
    self.deviceList = [[NSMutableArray alloc] init];
    self.characteristicsList = [[NSMutableArray alloc]init];
    self.servicesList = [[NSMutableArray alloc] init];
    self.serviceUUIDtoLookFor = nil;
}

- (void) searchDevices
{
    //[self.deviceList removeAllObjects];
    
    
    self.myCentralMaganer = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

- (void) stopSearchingForDevices
{
    [self.myCentralMaganer stopScan];
}


- (void) waitForDeviceWithName:(NSString *)name
{
    while (1) {
    for(CBPeripheral * device in self.deviceList)
    {
        if([device.name isEqualToString:name])
        {
            //[self performSelectorInBackground:@selector(connectToDevice:device) withObject:NULL];
            
            //[self connectToDevice:device];
            return;
        }
    }
    }
}

- (void) connectToDevice: (CBPeripheral *) peripheral
{
    [self.myCentralMaganer connectPeripheral:peripheral options:nil];
    //self.connected = CONNECTING;
    self.desiredPeripheral = peripheral;
}

- (void) disconnect
{
    [self.myCentralMaganer cancelPeripheralConnection:self.desiredPeripheral];
}

- (void) discoverServices
{
    [self.servicesList removeAllObjects];
    [self.characteristicsList removeAllObjects];
    //[self.desiredPeripheral discoverServices:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSThread* myThread = [[NSThread alloc] initWithTarget:self.desiredPeripheral
                                                 selector:@selector(discoverServices:)
                                                   object:nil];
    [myThread start];  // Actually create the thread
    });

    
}


- (void) writeValue: (NSData *) data forCharacteristic:(nonnull CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type
{
    [self.desiredPeripheral writeValue:data forCharacteristic:characteristic type:type];
}

- (void) readValueForCharacteristic: (CBCharacteristic *) characteristic
{
    [self.desiredPeripheral readValueForCharacteristic:characteristic];
    
}



- (void) connectToDeviceWithName: (NSString*) name
{
    for(CBPeripheral * device in self.deviceList)
    {
        if([device.name isEqualToString:name])
        {
            //[self connectToDevice:device];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                             selector:@selector(connectToDevice:)
                                                               object:device];
                [myThread start];  // Actually create the thread
                NSLog(@"New thread started for connecting the device");
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    // 3
                });
            });
            
            return;
        }
    }
}

- (void) subscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    [self.desiredPeripheral setNotifyValue:YES forCharacteristic:characteristic];
}

- (void) unsubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    [self.desiredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
}



- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    // Here check for device UUID if the same as scanned in the QR code
    //NSLog(@"Discovered %@", peripheral.identifier.UUIDString);
    NSLog(@"NAME %@", peripheral.name);
    if([peripheral.name length] > 0) [self.deviceList addObject: peripheral];
    //NSLog(@"%@", [self.deviceList lastObject]);
    
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // You should test all scenarios
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    NSDictionary *scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                            forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [self.myCentralMaganer scanForPeripheralsWithServices:self.serviceUUIDtoLookFor options:scanOptions];
        NSLog(@"Scanning started");
        
    }
}


- (void) setDeviceServicesArrayToLookFor:(NSArray *)deviceServicesArray
{
    NSMutableArray * arrayWithServicesUUIDs = [[NSMutableArray alloc] init];
    for(NSString * str in deviceServicesArray)
    {
        [arrayWithServicesUUIDs addObject:[CBUUID UUIDWithString:str]];
    }
    self.serviceUUIDtoLookFor = arrayWithServicesUUIDs;
}

- (void) clearDeviceServicesArrayToLookFor
{
    self.serviceUUIDtoLookFor = nil;
}


- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    NSLog(@"Peripheral %@ connected", peripheral.name);
    self.connected = CONNECTED;
    
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        //NSLog(@"Discovered service %@", service);
        [self.servicesList addObject:service];
        [peripheral discoverCharacteristics:nil forService:service];
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    
    
    // Check the characteristic UUID, that we are usng and place it there
    for (CBCharacteristic *characteristics in service.characteristics) {
        //NSLog(@"Discovered characteristic %@", characteristics);
        [self.characteristicsList addObject:characteristics];
        
    }
}


- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    self.lastReadData = characteristic.value;
    NSLog(@"%@", characteristic.value);
    self.timeLastRead = [NSDate date];
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
    }
}



@end
