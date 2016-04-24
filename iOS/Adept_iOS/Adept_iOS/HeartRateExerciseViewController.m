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
    self.bluetoothDeviceList = [BluetoothDeviceList sharedInstance];
    self.bleCommunication = [RDBluetoothLowEnergy sharedInstance];
    self.heathKit = [HealthKitIntegration sharedInstance];
    self.burnedCalories = 0;
    self.trainingTime = 0;
    self.currentHeartRate = 0;
    self.heartRateZoneMin = 120;
    self.heartRateZoneMax = 140;
    
    self.labels = [NSArray arrayWithObjects:@"Training time", @"Burned calories", @"HRZ Min", @"HRZ Max", nil];
    self.detailTextLabels = [NSMutableArray arrayWithObjects:@"00:00",
                           @"0.0 kCal",
                           [NSString stringWithFormat:@"%ld", self.heartRateZoneMin],
                           [NSString stringWithFormat:@"%ld", self.heartRateZoneMax],
                           nil];
}

- (void) subscribeToHRCharacteristic
{
    CBPeripheral * HRPeripheral = (CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:4] device];
    
    for(CBService * aService in [HRPeripheral services])
    {
        for(CBCharacteristic * aCharacteristic in aService.characteristics)
        {
            if([[aCharacteristic.UUID UUIDString]  isEqual: @"2A37"])
            {
                [HRPeripheral setNotifyValue:YES forCharacteristic:aCharacteristic];
                self.heartRateCharacteristic = aCharacteristic;
                [HRPeripheral readValueForCharacteristic:self.heartRateCharacteristic];
                break;
            }
        }
    }

}

- (void) viewWillAppear:(BOOL)animated
{
    self.bleCommunication.delegate = self;
    [self subscribeToHRCharacteristic];
}

- (void) viewDidAppear:(BOOL)animated
{
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                        target:self
                                                      selector:@selector(refreshTrainingData)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.updateTimer invalidate];
    [self.heathKit writeActiveEnergyBurnedToHealthKit:self.burnedCalories];
}

- (void) viewDidDisappear:(BOOL)animated
{
    self.bleCommunication.delegate = nil;
}

- (void) didReceiveMemoryWarning
{
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.heathKit writeActiveEnergyBurnedToHealthKit:self.burnedCalories];
}


- (void) refreshTrainingData
{
    if(self.currentHeartRate)
    {
        self.trainingTime++ ;
        self.burnedCalories += [self.heathKit getCaloriesForHeartRate:self.currentHeartRate
                                                              andTime:1];
        
        [self.detailTextLabels replaceObjectAtIndex:HRTIME
                                         withObject:[NSString stringWithFormat:@"%02ld:%02ld", self.trainingTime/60, self.trainingTime%60]];
        
        [self.detailTextLabels replaceObjectAtIndex:HR_BURNED_CALORIES
                                         withObject:[NSString stringWithFormat:@"%0.2f kCal", self.burnedCalories]];
        
        [self.tableView reloadData];
    }
    
}


#pragma mark - Table View Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"HRCell"];
    cell.textLabel.text = [self.labels objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = [self.detailTextLabels objectAtIndex:indexPath.row];
    
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

- (void) didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic ofDevice:(CBPeripheral *)peripheral andData:(NSData *)data
{
    
    if([peripheral.name isEqualToString:@"Heart Rate Sensor"] == NO) return;
    
    uint8_t *currentHeartRate = (uint8_t *) data.bytes;
    
    if(currentHeartRate)
    {
        self.currentHeartRate = currentHeartRate[1];
        
        self.MainCircleView.textString = [NSString stringWithFormat:@"\u2665 %ld bpm",self.currentHeartRate];
        
        [self.heathKit writeHeartRatetoHealthKit:self.currentHeartRate];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            double red = 51.0f/255.0f;
            double green = 204.0f/255.0f;
            double blue = 204.0f/255.0f;
            
            if(self.currentHeartRate < self.heartRateZoneMin || self.currentHeartRate > self.heartRateZoneMax)
            {
                green = 51.0f/255.0f;
                blue = 204.0f/255.0f;
                
                if(self.currentHeartRate < self.heartRateZoneMin)
                {
                    red = 128.0f + labs(self.heartRateZoneMin - self.currentHeartRate)*5;
                }
                else
                {
                    red = 128.0f + labs(self.heartRateZoneMax - self.currentHeartRate)*5;
                }
                
                if(red > 255.0f) red = 255.0f;
                red /= 255.0f;
            }

            self.MainCircleView.strokeColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
            
            [self.MainCircleView setNeedsDisplay];
        });
        
    }
}
- (void) didWriteValueForCharacteristic: (RDBluetoothLowEnergy *) bluetoothLowEnergy
{
    
}

- (void) didDisconnectDevice:(CBPeripheral *)device
{
    if([device.name isEqualToString: @"Heart Rate Sensor"] == YES)
    {
        [self.bleCommunication connectToDevice:device];
    }
}

- (void) didConnectDevice:(CBPeripheral *)device
{
    if([device.name isEqualToString: @"Heart Rate Sensor"] == YES)
    {
        [device discoverServices:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void)
                       {
                           [self subscribeToHRCharacteristic];
                       });
    }
}

@end
