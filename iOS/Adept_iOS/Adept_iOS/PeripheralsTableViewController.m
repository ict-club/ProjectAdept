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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
