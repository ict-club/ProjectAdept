//
//  HeartRateExerciseViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/16/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "HeartRateExerciseViewController.h"

@implementation HeartRateExerciseViewController

- (void) viewDidLoad
{
    self.bluetoothDelegate = self;
    self.bluetoothDeviceList = [BluetoothDeviceList sharedInstance];
    
    CBPeripheral * aPeripheral = [[self.bluetoothDeviceList objectAtIndex:3] device];
    for(CBService * aService in aPeripheral.services)
    {
        for(CBCharacteristic * aCharacteristic in aService.characteristics)
        {
            if(aCharacteristic.UUID == [CBUUID UUIDWithString:@"2A37"])
            {
                [self.bluetoothDeviceList.heartRateDevice.device setNotifyValue:YES forCharacteristic:aCharacteristic];
                break;
            }
        }
    }
    //[self.bluetoothDeviceList.heartRateDevice.device setNotifyValue:YES forCharacteristic:<#(nonnull CBCharacteristic *)#>]
}

- (void) viewWillAppear:(BOOL)animated
{
    
}

- (void) didReceiveMemoryWarning
{
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"HRCell"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

#pragma mark - Bluetooth Low Energy Delegate

- (void) didUpdateValueForCharacteristic: (RDBluetoothLowEnergy *) bluetoothLowEnergy andData: (NSData *) data
{
    
}
- (void) didWriteValueForCharacteristic: (RDBluetoothLowEnergy *) bluetoothLowEnergy
{
    
}


@end
