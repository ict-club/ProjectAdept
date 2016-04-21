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
    
    self.bluetoothDevices = [BluetoothDeviceList sharedInstance];
    self.bleCommunication = [RDBluetoothLowEnergy sharedInstance];
    [self.bleCommunication searchDevices];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlPulled)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    self.bleCommunication.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}
#pragma mark - Refresh control

- (void) refreshControlPulled
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bleCommunication refreshDeviceList];
        for(int index = 0; index < [self.bluetoothDevices count]; index ++)
        {
            [[self.bluetoothDevices objectAtIndex:index] setAvailable:NO];
            [[self.bluetoothDevices objectAtIndex:index] setDevice:nil];
        }
        
        [self.tableView beginUpdates];
        [self.tableView reloadData];
        [self.tableView endUpdates];
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bluetoothDevices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    double red = 204.0f/255.0f;
    double green = 51.0f/255.0f;
    double blue = 204.0f/255.0f;
    
    DeviceConnectionStateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceConnectionStatusCell" forIndexPath:indexPath];
    cell.StatusCircleView.textString = @"";
    cell.StatusCircleView.strokeWidth = 3;
    cell.deviceLabel.text = [[self.bluetoothDevices objectAtIndex:indexPath.row] displayName];
    cell.deviceLabel.textColor = [UIColor blackColor];
    
    BluetoothDevice * device = [self.bluetoothDevices objectAtIndex:indexPath.row];
    if([device available] == YES)
    {
        red = 51.0f/255.0f;
        green = 204.0f/255.0f;
        blue = 204.0f/255.0f;
    }
    if([device connected] == YES)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.StatusCircleView.strokeColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = cell.StatusCircleView.strokeColor;
    [cell setSelectedBackgroundView:bgColorView];
    
    [cell.StatusCircleView setNeedsDisplay];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral * device = (CBPeripheral *)[[self.bluetoothDevices objectAtIndex:indexPath.row] device];
    if(device)
    {
        if([(BluetoothDevice *)[self.bluetoothDevices objectAtIndex:indexPath.row] connected] == NO)
        {
            [self.bleCommunication connectToDevice:device];
        }
        else
        {
            [self.bleCommunication disconnectDevice:device];
        }
    }
    else
    {
        UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device out of range" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  
                              }];
        [controller addAction:OK];
        [self presentViewController:controller animated:YES completion:nil];
    }
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

- (void) didConnectDevice:(CBPeripheral *)device
{
    for(BluetoothDevice * aDevice in self.bluetoothDevices)
    {
        if(aDevice.device.name == device.name)
        {
            aDevice.connected = YES;
            if([device.name isEqualToString: @"TAO-AA-0051"])
            {
                [aDevice.device discoverServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"5000"]]];
            }
            else
            {
                [aDevice.device discoverServices:nil];
            }
            [self.tableView reloadData];
            break;
        }
    }
}

- (void) didDisconnectDevice:(CBPeripheral *)device
{
    for(BluetoothDevice * aDevice in self.bluetoothDevices)
    {
        if(aDevice.device.name == device.name)
        {
            aDevice.connected = NO;
            [self.tableView reloadData];
            break;
        }
    }
}
@end
