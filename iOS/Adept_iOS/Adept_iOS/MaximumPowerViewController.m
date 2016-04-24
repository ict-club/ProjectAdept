//
//  MaximumPowerViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/23/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "MaximumPowerViewController.h"
#import "CircleView.h"
#import "BluetoothDevice.h"
#import "BluetoothDeviceList.h"
#import "HealthKitIntegration.h"
#import "RDBluetoothLowEnergy.h"


@interface MaximumPowerViewController () <RDBluetoothLowEnergyDelegate>
{
    NSInteger maximumPower;
}
@property (weak, nonatomic) IBOutlet CircleView *mainCircleView;
@property (weak, nonatomic) IBOutlet UILabel *MaximumPowerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postureImage;

@property (nonatomic, strong) RDBluetoothLowEnergy * bleCommunication;
@property (strong, nonatomic) BluetoothDeviceList * bluetoothDeviceList;
@property (strong, nonatomic) HealthKitIntegration * heathKit;
@property (assign, nonatomic) NSInteger currentIsometricData;
@property (strong, nonatomic) CBCharacteristic * isometricCaracteristic;

@end

@implementation MaximumPowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleCommunication = [RDBluetoothLowEnergy sharedInstance];
    self.bluetoothDeviceList = [BluetoothDeviceList sharedInstance];
    self.heathKit = [HealthKitIntegration sharedInstance];
    
    self.postureImage.layer.borderColor = [UIColor blackColor].CGColor;
    self.postureImage.layer.borderWidth = 1.0f;
    self.postureImage.layer.cornerRadius = 15;
    self.postureImage.layer.masksToBounds = YES;
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    self.bleCommunication.delegate = self;
    [self subscribeToIsometricCharacteristic];
    maximumPower = 0;
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.bleCommunication.delegate = nil;
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


#pragma mark - Bluetooth characteristic updated delegate implementation

- (void) didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic ofDevice:(CBPeripheral *)peripheral andData:(NSData *)data
{
    if([peripheral.name isEqualToString:@"TAO-AA-0246"] == YES || [peripheral.name isEqualToString: @"TAO-AA-0375"] == YES)
    {
        NSString * isometricData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", isometricData);
        
        self.currentIsometricData = [isometricData integerValue];
        
        double red = 51.0f/255.0f;
        double green = 204.0f/255.0f;
        double blue = 204.0f/255.0f;
        
        if(self.currentIsometricData < 500)
        {
            green = 51.0f/255.0f;
            blue = 204.0f/255.0f;
            
            red = 128.0f + (500 - self.currentIsometricData)/5;
            
            if(red > 255.0f) red = 255.0f;
            red /= 255.0f;

        }
        
        self.mainCircleView.strokeColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        
        self.mainCircleView.textString = [NSString stringWithFormat:@"%ld N", self.currentIsometricData];
        
        if(self.currentIsometricData > maximumPower) maximumPower = self.currentIsometricData;
        
        self.MaximumPowerLabel.text = [NSString stringWithFormat:@"Max power: %ld N", maximumPower];
        
        [self.mainCircleView setNeedsDisplay];
    }
}


#pragma mark - Private methods
- (void) subscribeToIsometricCharacteristic
{
    CBPeripheral * TAOPeripheral;
    
    if([(CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:2] device] state] == CBPeripheralStateConnected)
    {
        TAOPeripheral = (CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:2] device];
    }
    else if([(CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:3] device] state] == CBPeripheralStateConnected)
    {
        TAOPeripheral = (CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:3] device];
    }
    else
    {
        return;
    }
    for(NSInteger i = [[TAOPeripheral services] count] - 1; i >= 0; i--)
    {
        CBService * aService = [[TAOPeripheral services] objectAtIndex:i];
        for(CBMutableCharacteristic * aCharacteristic in aService.characteristics)
        {
            if([aCharacteristic.UUID  isEqual: [CBUUID UUIDWithString:@"5A01"]] == YES)
            {
                [TAOPeripheral setNotifyValue:YES forCharacteristic:aCharacteristic];
                self.isometricCaracteristic = aCharacteristic;
                break;
            }
        }
    }
}

- (void) didDisconnectDevice:(CBPeripheral *)device
{
    if([device.name isEqualToString: @"ТАО-АА-0246"] == YES || [device.name isEqualToString: @"ТАО-АА-0375"] == YES)
    {
        [self.bleCommunication connectToDevice:device];
    }
}

- (void) didConnectDevice:(CBPeripheral *)device
{
    if([device.name isEqualToString: @"ТАО-АА-0246"] == YES || [device.name isEqualToString: @"ТАО-АА-0375"] == YES)
    {
        [device discoverServices:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void)
                       {
                           [self subscribeToIsometricCharacteristic];
                       });
    }
}




@end
