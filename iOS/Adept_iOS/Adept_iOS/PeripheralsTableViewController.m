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
    self.deviceIDArray = [NSArray arrayWithObjects:@"AdeptStick",@"Moov",@"HeartRateMonitor", @"TAO-AA-0051", @"AppleFukingWatch", @"OtherDevice", nil];
    
    self.refreshControl.enabled = YES;
    
    self.bleCommunication = [RDBluetoothLowEnergy sharedInstance];
    self.bleCommunication.delegate = self;
    [self.bleCommunication searchDevices];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh control

- (void) refreshControlPulled
{
    dispatch_async(dispatch_get_main_queue(), ^{[self.bleCommunication refreshDeviceList];});
}

- (void) refreshBLEdevices
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deviceNamesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    double red = 51.0f/255.0f;
    double green = 204.0f/255.0f;
    double blue = 204.0f/255.0f;
    
    DeviceConnectionStateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceConnectionStatusCell" forIndexPath:indexPath];
    cell.StatusCircleView.textString = @"";
    cell.StatusCircleView.strokeWidth = 3;
    cell.deviceLabel.text = [self.deviceNamesArray objectAtIndex:indexPath.row];
    if(indexPath.row > 2)
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
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RDBluetoothLowEnergyDelegate

- (void) newDeviceFound:(RDBluetoothLowEnergy *)bluetoothLowEnergy
{
    [self.tableView reloadData];
}

@end
