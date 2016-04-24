//
//  ResearchTableViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/23/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "ResearchTableViewController.h"
#import "ResearchKit/ResearchKit/ResearchKit.h"
#import "HealthKitIntegration.h"

NS_ENUM(NSInteger, ResearchTableViewCellTypeEnum)
{
    RKTV_ADD_HEALTH_DATA = 0,
    RKTV_ADD_FOOD,
    RKTV_MEASURE_MAX_STRENGTH,
    RKTV_MEASURE_REST_HR,
    RKTV_PHYCO_DIAGNOZE,
    RKTV_ILLNESS_SYMPTOMS
};
@interface ResearchTableViewController () <ORKTaskViewControllerDelegate>
{
    NSInteger selectedTest;
}
@property ORKTaskViewController * PollViewController;
@end
@implementation ResearchTableViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    selectedTest = 0;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResearchKitCellIdentifier" forIndexPath:indexPath];
    if(indexPath.row == RKTV_ADD_HEALTH_DATA)
    {
        cell.textLabel.text = @"Add health data";
    }
    else if(indexPath.row == RKTV_ADD_FOOD)
    {
        cell.textLabel.text = @"Add food data";
    }
    else if(indexPath.row == RKTV_MEASURE_MAX_STRENGTH)
    {
        cell.textLabel.text = @"Measure max strength";
    }
    else if(indexPath.row == RKTV_MEASURE_REST_HR)
    {
        cell.textLabel.text = @"Measure resting heart rate";
    }
    else if(indexPath.row == RKTV_ILLNESS_SYMPTOMS)
    {
        cell.textLabel.text = @"Record illness condition";
    }

    else if(indexPath.row == RKTV_PHYCO_DIAGNOZE)
    {
        cell.textLabel.text = @"Record phyco data";
    }
    
    double red = 51.0f/255.0f;
    double green = 204.0f/255.0f;
    double blue = 204.0f/255.0f;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.4f];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == RKTV_ADD_HEALTH_DATA)
    {
        [self addBodyDataInfo];
        selectedTest = RKTV_ADD_HEALTH_DATA;
    }
    else if(indexPath.row == RKTV_ADD_FOOD)
    {
        [self performSegueWithIdentifier:@"AddFoodSegue" sender:nil];
    }
    else if(indexPath.row == RKTV_MEASURE_MAX_STRENGTH)
    {
        [self performSegueWithIdentifier:@"MeasureMaxPowerSegue" sender:nil];
    }
    else if(indexPath.row == RKTV_MEASURE_REST_HR)
    {
        [self performSegueWithIdentifier:@"MeasureRestingHRSegue" sender:nil];
    }
    else if(indexPath.row == RKTV_ILLNESS_SYMPTOMS)
    {
        [self illnessTest];
        selectedTest = RKTV_ILLNESS_SYMPTOMS;
    }
    else if(indexPath.row == RKTV_PHYCO_DIAGNOZE)
    {
        [self psycoTest];
        selectedTest = RKTV_PHYCO_DIAGNOZE;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)taskViewController:(ORKTaskViewController *)taskViewController shouldPresentStep:(ORKStep *)step
{
    return YES;
}

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error
{
    [taskViewController dismissViewControllerAnimated:YES completion:nil];
    
    switch (reason) {
        case ORKTaskViewControllerFinishReasonCompleted:
            
        {
            if(selectedTest == RKTV_ADD_HEALTH_DATA)
            {
            NSNumber * weight = [(ORKNumericQuestionResult *)[[[taskViewController.result stepResultForStepIdentifier:@"weightIdentificator"] results] objectAtIndex:0] numericAnswer];
            NSNumber * height = [(ORKNumericQuestionResult *)[[[taskViewController.result stepResultForStepIdentifier:@"heightIdentificator"] results] objectAtIndex:0] numericAnswer];
            NSNumber * writeSize = [(ORKNumericQuestionResult *)[[[taskViewController.result stepResultForStepIdentifier:@"wristSizeIdentificator"] results] objectAtIndex:0] numericAnswer];
            [[HealthKitIntegration sharedInstance] writeHeightToHealthKit:((double)[height integerValue]/100.0f)];
            [[HealthKitIntegration sharedInstance] writeBodyMassToHealthKit:(double)([weight doubleValue])];
#warning must add this data to internet;
            }
            else if(selectedTest == RKTV_PHYCO_DIAGNOZE)
            {
                
            }
            else if(selectedTest == RKTV_ILLNESS_SYMPTOMS)
            {
                
            }
        }

            break;
            
        default:
            break;
    }
    
    selectedTest = 0;
}

- (void) psycoTest
{
    ORKScaleAnswerFormat * feelingAnswer = [ORKScaleAnswerFormat scaleAnswerFormatWithMaximumValue:10 minimumValue:0 defaultValue:5 step:1 vertical:NO maximumValueDescription:@"Perfect" minimumValueDescription:@"Very bad"];
    ORKQuestionStep * feelingStep = [ORKQuestionStep questionStepWithIdentifier:@"feelingIdentifier" title:@"How do you feel today from the scale of 1 to 10" answer:feelingAnswer];
    
    
    ORKNumericAnswerFormat * sleepHours = [ORKNumericAnswerFormat decimalAnswerFormatWithUnit:@"Hours"];
    sleepHours.minimum = @(0);
    sleepHours.maximum = @(20);
    ORKQuestionStep * sleepQuestion = [ORKQuestionStep questionStepWithIdentifier:@"sleepIdentifier" title:@"How many hours did you sleep last night" answer:sleepHours];
    
    
    ORKScaleAnswerFormat * sleepQuality = [ORKScaleAnswerFormat scaleAnswerFormatWithMaximumValue:10 minimumValue:0 defaultValue:5 step:1 vertical:NO maximumValueDescription:@"Perfect" minimumValueDescription:@"Very bad"];
    ORKQuestionStep * sleepQualityStep = [ORKQuestionStep questionStepWithIdentifier:@"sleepQualityIdentifier" title:@"Evaluate your last night sleep on the scale from 1 to 10" answer:sleepQuality];
    
    
    ORKScaleAnswerFormat * agressionAnswer = [ORKScaleAnswerFormat scaleAnswerFormatWithMaximumValue:10 minimumValue:0 defaultValue:5 step:1 vertical:NO maximumValueDescription:@"Very Agressive" minimumValueDescription:@"Not agressive"];
     ORKQuestionStep * agressionStep = [ORKQuestionStep questionStepWithIdentifier:@"agressionIdentifier" title:@"How agressive do you feel on the scale from 0 to 10" answer:agressionAnswer];
    
    
    ORKOrderedTask *task =
    [[ORKOrderedTask alloc] initWithIdentifier:@"Identifier"
                                         steps:@[feelingStep, sleepQuestion ,sleepQualityStep, agressionStep]];
    
    ORKTaskViewController *taskViewController =
    [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    taskViewController.delegate = self;
    
    // Present the task view controller.
    [self presentViewController:taskViewController animated:YES completion:nil];

}

- (void) illnessTest
{
    ORKScaleAnswerFormat * illnessIndicator = [ORKScaleAnswerFormat scaleAnswerFormatWithMaximumValue:10 minimumValue:0 defaultValue:5 step:1 vertical:NO maximumValueDescription:@"Perfect" minimumValueDescription:@"Very bad"];
    ORKQuestionStep * feelingStep = [ORKQuestionStep questionStepWithIdentifier:@"feelingIdentifier" title:@"Evaluate you current condition on the scale from 0 to 10" answer:illnessIndicator];
    
    
    ORKNumericAnswerFormat * sleepHours = [ORKNumericAnswerFormat decimalAnswerFormatWithUnit:@"Hours"];
    sleepHours.minimum = @(0);
    sleepHours.maximum = @(20);
    ORKQuestionStep * sleepQuestion = [ORKQuestionStep questionStepWithIdentifier:@"sleepIdentifier" title:@"How many hours did you sleep last night" answer:sleepHours];
    
    ORKScaleAnswerFormat * sleepQuality = [ORKScaleAnswerFormat scaleAnswerFormatWithMaximumValue:10 minimumValue:0 defaultValue:5 step:1 vertical:NO maximumValueDescription:@"Perfect" minimumValueDescription:@"Very bad"];
    ORKQuestionStep * sleepQualityStep = [ORKQuestionStep questionStepWithIdentifier:@"sleepQualityIdentifier" title:@"Evaluate you current condition on the scale from 0 to 10" answer:sleepQuality];
    
    
    ORKTextAnswerFormat * symptoms = [ORKTextAnswerFormat textAnswerFormat];
    ORKQuestionStep * symptomsQuestion = [ORKQuestionStep questionStepWithIdentifier:@"symptoms" title:@"Describe your symptoms" answer:symptoms];
    
    ORKOrderedTask *task =
    [[ORKOrderedTask alloc] initWithIdentifier:@"Identifier"
                                         steps:@[feelingStep, sleepQuestion, sleepQualityStep, symptomsQuestion]];
    
    
    ORKTaskViewController *taskViewController =
    [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    taskViewController.delegate = self;
    
    // Present the task view controller.
    [self presentViewController:taskViewController animated:YES completion:nil];

    

}
- (void) addBodyDataInfo
{
    
    ORKNumericAnswerFormat *wristFormat =
    [ORKNumericAnswerFormat decimalAnswerFormatWithUnit:@"cm"];
    wristFormat.minimum = @(12);
    wristFormat.maximum = @(40);
    ORKQuestionStep *wristStep =
    [ORKQuestionStep questionStepWithIdentifier:@"wristSizeIdentificator"
                                          title:@"What is your wrist size?"
                                         answer:wristFormat];
    
    ORKNumericAnswerFormat *weightFormat = [ORKNumericAnswerFormat decimalAnswerFormatWithUnit:@"kg"];
    weightFormat.minimum = @(20);
    weightFormat.maximum = @(180);
    ORKQuestionStep * weightStep = [ORKQuestionStep questionStepWithIdentifier:@"weightIdentificator" title:@"Please write down your weight" answer:weightFormat];
    
    ORKNumericAnswerFormat * heightFormat = [ORKNumericAnswerFormat decimalAnswerFormatWithUnit:@"cm"];
    heightFormat.minimum = @(100);
    heightFormat.maximum = @(300);
    ORKQuestionStep * heightStep = [ORKQuestionStep questionStepWithIdentifier:@"heightIdentificator" title:@"Please write down your height" answer:heightFormat];
    
    ORKOrderedTask *task =
    [[ORKOrderedTask alloc] initWithIdentifier:@"Identifier"
                                         steps:@[weightStep, heightStep ,wristStep]];
    
    ORKTaskViewController *taskViewController =
    [[ORKTaskViewController alloc] initWithTask:task taskRunUUID:nil];
    taskViewController.delegate = self;
    
    // Present the task view controller.
    [self presentViewController:taskViewController animated:YES completion:nil];
    
    
}

@end
