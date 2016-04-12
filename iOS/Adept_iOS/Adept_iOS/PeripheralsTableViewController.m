//
//  PeripheralsTableViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/28/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "PeripheralsTableViewController.h"

@interface PeripheralsTableViewController ()

@end

@implementation PeripheralsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deviceNamesArray = [NSArray arrayWithObjects:@"Adept Stick", @"Moov",@"Heart rate monitor", @"Tao-Wellshell", @"Apple Watch", @"Some other device", nil];
    self.deviceIDArray = [NSArray arrayWithObjects:@"AdeptStick",@"Moov",@"Heart Rate Sensor", @"TAO-AA-0051", @"AppleFukingWatch", @"OtherDevice", nil];
    
    self.taoDevice = [[BluetoothDevice alloc] init];
    self.taoDevice.displayName = @"Tao-Wellshell";
    self.taoDevice.deviceName = @"TAO-AA-0051";
    
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
    
    self.bluetoothDevices = [NSArray arrayWithObjects:self.adeptDevice, self.moovDevice, self.taoDevice, self.heartRateDevice, self.appleWatch, nil];
    
    self.bleCommunication = [RDBluetoothLowEnergy sharedInstance];
    self.bleCommunication.delegate = self;
    [self.bleCommunication searchDevices];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlPulled)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh control

- (void) refreshControlPulled
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bleCommunication refreshDeviceList];
        [self.refreshControl endRefreshing];
    });
}

- (void) refreshBLEdevices
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bluetoothDevices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    double red = 51.0f/255.0f;
    double green = 204.0f/255.0f;
    double blue = 204.0f/255.0f;
    
    DeviceConnectionStateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceConnectionStatusCell" forIndexPath:indexPath];
    cell.StatusCircleView.textString = @"";
    cell.StatusCircleView.strokeWidth = 3;
    cell.deviceLabel.text = [[self.bluetoothDevices objectAtIndex:indexPath.row] displayName];
    
    
    if([[self.bluetoothDevices objectAtIndex:indexPath.row] available] == YES)
    {
        red = 204.0f/255.0f;
        green = 51.0f/255.0f;
        blue = 204.0f/255.0f;
        cell.StatusCircleView.strokeColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    }
    
    cell.deviceLabel.textColor = [UIColor blackColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
    [cell setSelectedBackgroundView:bgColorView];
    [cell.StatusCircleView setNeedsDisplay];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RDBluetoothLowEnergyDelegate

- (void) newDeviceFound:(RDBluetoothLowEnergy *)bluetoothLowEnergy
{
    for(CBPeripheral * device in self.bleCommunication.deviceList)
    {
        for(int index = 0; index < [self.bluetoothDevices count]; index ++)
        {
            if([device.name isEqualToString:[[self.bluetoothDevices objectAtIndex:index] deviceName]] == YES)
            {
                [[self.bluetoothDevices objectAtIndex:index] setAvailable:YES];
                [[self.bluetoothDevices objectAtIndex:index] setDevice:device];
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]
                                      withRowAnimation: UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                
                break;
            }
        }
    }
}

@end
