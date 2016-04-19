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
    NSInteger numberOfRows;
    BOOL isPickerVisible;
    NSInteger pickerIndex;
}

@property (nonatomic, strong) UIPickerView * pickerView;
@property (nonatomic, strong) NSMutableArray * pickerArray;
@end

@implementation TrainingSelectTableViewController

@synthesize detailsLabelData = _detailsLabelData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.trainingData = [[NSMutableDictionary alloc] init];
    self.pickerHardnessData = [[NSMutableArray alloc] init];
    self.pickerMuscleGroupData = [[NSMutableArray alloc] init];
    self.pickerMaxHeartRateData = [[NSMutableArray alloc] init];
    self.pickerMinHeartRateData = [[NSMutableArray alloc] init];
    self.pickerTimeForExerciseData = [[NSMutableArray alloc] init];
    self.detailsLabelData = [[NSMutableArray alloc] init];
    
    self.labelData = [[NSMutableArray alloc] initWithObjects:@"Muscle group", @"Difficulty level", @"Duration", @"Minimum Heart Rate", @"Maximum Heart Rate", nil];

    numberOfRows = 5;
    isPickerVisible = false;
    pickerIndex = 0;
    
    
    
    switch (self.selectedType) {
        case WellshellTraining:
            [self setupTaoTrainingOptions];
            break;
            
        default:
            break;
    }
    
    [self setupPickerValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue destinationViewController] respondsToSelector:@selector(setExerciseInformation:)])
    {
        
    }
}

#pragma mark - Setups for exercise

- (void) setupPickerValues
{
    [self.trainingData setObject:[self.pickerMuscleGroupData objectAtIndex:0] forKey:@"MuscleGroup"];
    [self.trainingData setObject:[self.pickerHardnessData objectAtIndex:0] forKey:@"Hardness"];
    [self.trainingData setObject:[self.pickerTimeForExerciseData objectAtIndex:0] forKey:@"Time"];
    [self.trainingData setObject:[self.pickerMinHeartRateData objectAtIndex:0] forKey:@"HRZMin"];
    [self.trainingData setObject:[self.pickerMaxHeartRateData objectAtIndex:0] forKey:@"HRZMax"];

}
- (void) setupTaoTrainingOptions
{
    for(int i = 0; i < 20; i++)
    {
        [self.pickerHardnessData addObject:[NSNumber numberWithInteger:i*5]];
    }
    
    for(int i = 60; i < 200; i+=5)
    {
        [self.pickerMinHeartRateData addObject:[NSNumber numberWithInteger:i]];
        [self.pickerMaxHeartRateData addObject:[NSNumber numberWithInteger:i]];
        
    }
    
    for(int i = 15; i < 600; i+=5)
    {
        [self.pickerTimeForExerciseData addObject:[NSNumber numberWithInteger:i]];
    }
    
    self.pickerMuscleGroupData = [NSMutableArray arrayWithObjects:@"Recomended",@"Biceps workout", @"Peg workout", @"Sixpack workout", @"Back workout", @"Triceps workout", @"Legs workout", nil];
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
        return 160;
    }
    else
    {
        return 40;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell;
    if(isPickerVisible == YES && pickerIndex == indexPath.row)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PickerViewIdentifier" forIndexPath:indexPath];
        self.pickerView = [cell pickerView];
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:[self getComponentIndexForRow:indexPath.row] inComponent:0 animated:YES];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TrainingSelectCellViewIdentifier" forIndexPath:indexPath];
        
        NSInteger index = indexPath.row;
        if(isPickerVisible == YES && pickerIndex < index)
        {
            index-=1;
        }
        [[cell textLabel] setText:[self.labelData objectAtIndex:index]];
        [[cell detailTextLabel] setText:[self.detailsLabelData objectAtIndex:index]];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isPickerVisible == NO)
    {
        [self setPickerIndex:indexPath.row + 1];
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
            [self setPickerIndex:-1];
        }
        else if (pickerIndex < indexPath.row)
        {
            isPickerVisible = YES;
            [self setPickerIndex:indexPath.row];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pickerIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            isPickerVisible = YES;
            [self setPickerIndex:indexPath.row + 1];
            if(pickerIndex == [self.tableView numberOfRowsInSection:0])
            {
                [self setPickerIndex:pickerIndex - 1];
            }
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pickerIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Picker view source

- (void) setPickerIndex:(NSInteger) newPickerIndex;
{
    pickerIndex = newPickerIndex;
    
    if(pickerIndex <= 0) return;
    
    switch (pickerIndex) {
        case 1:
            self.pickerArray = [NSMutableArray arrayWithArray:self.pickerMuscleGroupData];
            break;
        case 2:
            self.pickerArray = [NSMutableArray arrayWithArray:self.pickerHardnessData];
            break;
        case 3:
            self.pickerArray = [NSMutableArray arrayWithArray:self.pickerTimeForExerciseData];
            break;
        case 4:
            self.pickerArray = [NSMutableArray arrayWithArray:self.pickerMinHeartRateData];
            break;
        case 5:
            self.pickerArray = [NSMutableArray arrayWithArray:self.pickerMaxHeartRateData];
            break;
        default:
            break;
    }
    [self.pickerView reloadAllComponents];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    self.pickerView = pickerView;
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerArray count];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerIndex) {
        case 1:
            [self.trainingData setObject:[self.pickerMuscleGroupData objectAtIndex:row] forKey:@"MuscleGroup"];
            break;
        case 2:
            [self.trainingData setObject:[self.pickerHardnessData objectAtIndex:row] forKey:@"Hardness"];
            break;
        case 3:
            [self.trainingData setObject:[self.pickerTimeForExerciseData objectAtIndex:row] forKey:@"Time"];
            break;
        case 4:
            [self.trainingData setObject:[self.pickerMinHeartRateData objectAtIndex:row] forKey:@"HRZMin"];
            if([[self.trainingData objectForKey:@"HRZMin"] integerValue] > [[self.trainingData objectForKey:@"HRZMax"] integerValue])
               {
                   [self.trainingData setObject:[self.pickerMinHeartRateData objectAtIndex:row] forKey:@"HRZMin"];
               }
            break;
        case 5:
            [self.trainingData setObject:[self.pickerMaxHeartRateData objectAtIndex:row] forKey:@"HRZMax"];
            break;
        default:
            break;
    }

    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:pickerIndex - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([[self.pickerArray objectAtIndex:row] isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%ld", [[self.pickerArray objectAtIndex:row] integerValue]];
    }
    else
    {
        return [self.pickerArray objectAtIndex:row];
    }
}

#pragma mark - Private methods
                                       
- (NSString *) getTitleForRow:(NSInteger) row
{
    if([[self.pickerArray objectAtIndex:row] isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%ld", [[self.pickerArray objectAtIndex:row] integerValue]];
    }
    else
    {
        return [self.pickerArray objectAtIndex:row];
    }
    
}
- (NSInteger) getComponentIndexForRow: (NSInteger) row
{
    switch (row) {
        case 1:
            return [self getComponentNumberInPickerForObjectWithKey:@"MuscleGroup"];
            break;
        case 2:
            return [self getComponentNumberInPickerForObjectWithKey:@"Hardness"];
            break;
        case 3:
            return [self getComponentNumberInPickerForObjectWithKey:@"Time"];
            break;
        case 4:
            return [self getComponentNumberInPickerForObjectWithKey:@"HRZMin"];
            break;
        case 5:
            return [self getComponentNumberInPickerForObjectWithKey:@"HRZMax"];
            break;
        default:
            break;
    }
    
    return 0;
}
- (NSInteger) getComponentNumberInPickerForObjectWithKey: (NSString *) key
{
    int switchValue = 0;
    id object = [self.trainingData objectForKey:key];
    if([key isEqualToString:@"MuscleGroup"]) switchValue = 1;
    else if([key isEqualToString:@"Hardness"]) switchValue = 2;
    else if([key isEqualToString:@"Time"]) switchValue = 3;
    else if([key isEqualToString:@"HRZMin"]) switchValue = 4;
    else if([key isEqualToString:@"HRZMax"]) switchValue = 5;
    
    
    switch (switchValue) {
        case 1:
            for(NSInteger index = 0; index < self.pickerMuscleGroupData.count; index++)
            {
                if([[self.pickerMuscleGroupData objectAtIndex:index] isEqualToString:object])
                {
                    return index;
                }
            }
            break;
        case 2:
            for(NSInteger index = 0; index < self.pickerHardnessData.count; index++)
            {
                if([[self.pickerHardnessData objectAtIndex:index] integerValue] == [object integerValue])
                {
                    return index;
                }
            }
            break;
        case 3:
            for(NSInteger index = 0; index < self.pickerTimeForExerciseData.count; index++)
            {
                if([[self.pickerTimeForExerciseData objectAtIndex:index] integerValue] == [object integerValue])
                {
                    return index;
                }
            }
            break;
        case 4:
            for(NSInteger index = 0; index < self.pickerMinHeartRateData.count; index++)
            {
                if([[self.pickerMinHeartRateData objectAtIndex:index] integerValue] == [object integerValue])
                {
                    return index;
                }
            }
            break;
        case 5:
            for(NSInteger index = 0; index < self.pickerMaxHeartRateData.count; index++)
            {
                if([[self.pickerMaxHeartRateData objectAtIndex:index] integerValue] == [object integerValue])
                {
                    return index;
                }
            }
            break;
        default:
            break;
    }
    
    return 0;

}

- (NSMutableArray *) detailsLabelData
{
    NSMutableArray * arrayToReturn = [NSMutableArray arrayWithObjects:[self.trainingData objectForKey:@"MuscleGroup"],
                               [[self.trainingData objectForKey:@"Hardness"] stringValue],
                               [[self.trainingData objectForKey:@"Time"] stringValue],
                               [[self.trainingData objectForKey:@"HRZMin"] stringValue],
                               [[self.trainingData objectForKey:@"HRZMax"] stringValue],
                               nil];
    _detailsLabelData = arrayToReturn;
    
    return _detailsLabelData;
}


@end
