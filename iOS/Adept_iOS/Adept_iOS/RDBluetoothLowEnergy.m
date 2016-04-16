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

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        self.characteristic = [CBCharacteristic alloc];
        self.myCentralMaganer = [[CBCentralManager alloc] init];
        self.connected = false;
        self.deviceList = [[NSMutableArray alloc] init];
        self.characteristicsList = [[NSMutableArray alloc]init];
        self.servicesList = [[NSMutableArray alloc] init];
        self.serviceUUIDtoLookFor = nil;
        
        return self;
    }
    return nil;
}

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
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
        [self.desiredPeripheral discoverServices:nil];
    });

    
}

- (void) discoverSevicesForPeriheral:(CBPeripheral *) peripheral
{
    [self.servicesList removeAllObjects];
    [self.characteristicsList removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [peripheral discoverServices:nil];
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [self connectToDevice:device];
            });
            break;
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
    NSLog(@"NAME %@", peripheral.name);
    if([peripheral.name length] > 0) [self.deviceList addObject: peripheral];
    if([self.delegate respondsToSelector:@selector(newDeviceFound:)]) {
        [self.delegate newDeviceFound:self];
    }
    
    
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

- (void) refreshDeviceList
{
    [self stopSearchingForDevices];
    [self.deviceList removeAllObjects];
    [self searchDevices];
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    NSLog(@"Peripheral %@ connected", peripheral.name);
    self.connected = CONNECTED;
    
    if([self.delegate respondsToSelector:@selector(didConnectDevice:)]) {
        [self.delegate didConnectDevice:peripheral];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        //NSLog(@"Discovered service %@", service);
        [self.servicesList addObject:service];
        [peripheral discoverCharacteristics:nil forService:service];
        
    }
    
    if([self.delegate respondsToSelector:@selector(didDiscoverServices:)]) {
        [self.delegate didDiscoverServices:self];
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
    
    if([self.delegate respondsToSelector:@selector(didDiscoverCharacteristics:)]) {
        [self.delegate didDiscoverCharacteristics:self];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    self.lastReadData = characteristic.value;
    //NSLog(@"%@", characteristic.value);
    self.timeLastRead = [NSDate date];
    
    if([self.delegate respondsToSelector:@selector(didUpdateValueForCharacteristic:andData:)]) {
        [self.delegate didUpdateValueForCharacteristic:self andData:characteristic.value];
    }
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
    if([self.delegate respondsToSelector:@selector(didWriteValueForCharacteristic:)]) {
        [self.delegate didWriteValueForCharacteristic:self];
    }
    
}



@end
