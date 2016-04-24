//
//  RestingHeartRateMeasurementViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/24/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "RestingHeartRateViewController.h"
#import "CircleView.h"
#import "BluetoothDeviceList.h"
#import "RDBluetoothLowEnergy.h"
#import "HealthKitIntegration.h"


@interface RestingHeartRateViewController () <RDBluetoothLowEnergyDelegate>
@property (weak, nonatomic) IBOutlet CircleView *mainCircleView;
@property (strong, nonatomic) RDBluetoothLowEnergy * bleCommunication;
@property (strong, nonatomic) BluetoothDeviceList * bluetoothDeviceList;
@property (strong, nonatomic) HealthKitIntegration * heathKit;
@property (strong, nonatomic) CBCharacteristic * heartRateCharacteristic;
@property (assign, nonatomic) NSInteger currentHeartRate;
@end

@implementation RestingHeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleCommunication = [RDBluetoothLowEnergy sharedInstance];
    self.heathKit = [HealthKitIntegration sharedInstance];
    self.bluetoothDeviceList = [BluetoothDeviceList sharedInstance];
    self.currentHeartRate = 0;
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    self.bleCommunication.delegate = self;
    [self subscribeToHRCharacteristic];
}

- (void) viewWillDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)recordButtonAction:(id)sender {
#warning Implement adding data to data base
    if(self.currentHeartRate > 0)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Resting Heart Rate data has been added to data base" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }

    
}

- (void) didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic ofDevice:(CBPeripheral *)peripheral andData:(NSData *)data
{
    
    if([peripheral.name isEqualToString:@"Heart Rate Sensor"] == NO) return;
    
    uint8_t *currentHeartRate = (uint8_t *) data.bytes;
    
    if(currentHeartRate)
    {
        self.currentHeartRate = currentHeartRate[1];
        
        self.mainCircleView.textString = [NSString stringWithFormat:@"\u2665 %ld bpm",self.currentHeartRate];
        
        [self.heathKit writeHeartRatetoHealthKit:self.currentHeartRate];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            double red = 51.0f/255.0f;
            double green = 204.0f/255.0f;
            double blue = 204.0f/255.0f;
            
            if(self.currentHeartRate > 80)
            {
                green = 51.0f/255.0f;
                blue = 204.0f/255.0f;
                red = 128.0f + (self.currentHeartRate - 80)*5;
                
                if(red > 255.0f) red = 255.0f;
                red /= 255.0f;
            }
            
            self.mainCircleView.strokeColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
            
            [self.mainCircleView setNeedsDisplay];
        });
        
    }
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
