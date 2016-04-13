//
//  TrainingSelectTableViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/29/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "TrainingSelectTableViewController.h"

@interface TrainingSelectTableViewController ()
{
    NSArray * pickerArray;
    NSInteger numberOfRows;
    BOOL isPickerVisible;
    NSInteger pickerIndex;
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation TrainingSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pickerArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    numberOfRows = 5;
    isPickerVisible = false;
    pickerIndex = 0;
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

    NSInteger numberOfRowsToReturn = numberOfRows;
    if(isPickerVisible == YES) numberOfRowsToReturn++;
    return numberOfRowsToReturn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isPickerVisible == YES && pickerIndex == indexPath.row)
    {
        return 120;
    }
    else
    {
        return 40;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if(isPickerVisible == YES && pickerIndex == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PickerViewIdentifier" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TrainingSelectCellViewIdentifier" forIndexPath:indexPath];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isPickerVisible == NO)
    {
        pickerIndex = indexPath.row + 1;
        isPickerVisible = YES;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pickerIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        isPickerVisible = NO;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pickerIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        if(pickerIndex == indexPath.row + 1)
        {
            isPickerVisible = NO;
            pickerIndex = -1;
        }
        else if (pickerIndex < indexPath.row)
        {
            isPickerVisible = YES;
            pickerIndex = indexPath.row;
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pickerIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            isPickerVisible = YES;
            pickerIndex = indexPath.row + 1;
            if(pickerIndex == [self.tableView numberOfRowsInSection:0])
            {
                pickerIndex = pickerIndex - 1;
            }
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pickerIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.tableView reloadData];
}


#pragma mark - Picker view source

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}


@end
