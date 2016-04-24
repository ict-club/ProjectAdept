//
//  HomeViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/28/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "HomeViewController.h"
#import "RDWebGet.h"
#import "AdeptDataBaseInteractions.h"


@interface HomeViewController ()
@property AdeptDataBaseInteractions *adb;
@end

@implementation HomeViewController
@synthesize adb;
NSDate * methodStart;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.healthKitObject = [HealthKitIntegration sharedInstance];
    self.dailyTarget = [[DailyTarget alloc] init];
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(healthKitNotAvailableNotificationHandler:)
                               name:@"HealthKitNotAvailable"
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(bmiUpdatedNotificationHandler:)
                               name:BMI_UPDATED
                             object:self.healthKitObject];
    
    [notificationCenter addObserver:self
                           selector:@selector(caloriesBalanceUpdatedNotificationHandler:)
                               name:CALORIE_BALANCE_UPDATED
                             object:self.healthKitObject];
    
    [notificationCenter addObserver:self
                           selector:@selector(dailyRemainingCaloriesToBurnNotificationHandler:)
                               name:DAILY_REMAINING_CALORIES_TO_BURN_UPDATED
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(healthKitInitializedNotificationHandler:)
                               name:HEALTH_KIT_INITIALIZED
                             object:nil];
    
    [self.healthKitObject initialize];
    
    adb = [AdeptDataBaseInteractions sharedInstance];
    [adb updateWeightChartDataForWeek];
    [adb updateMuscleStrengthForWeek];
    [adb updateWristBondeStructureForWeek];
    [adb updateCaloriesBalanceForWeek];
    [adb updateRestingHeartRateForWeek];
    [adb updateOverallCondition];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upadateRedrawMainCircle:) name:@"OverallConditionUpdate" object:nil];

}

- (void) viewDidAppear:(BOOL)animated
{
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(initalizeThreadToUpdateDataOnAnotherThread) userInfo:nil repeats:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) healthKitNotAvailableNotificationHandler: (NSNotification *) notification
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                    message:@"Cannot get information from health kit application. Go to health app and enable services"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action){}]];
    
}

- (void) healthKitInitializedNotificationHandler: (NSNotification *) notification
{
    [self.healthKitObject updateData];
}


- (void) redrawCircles
{
    [self redrawLeftCircle];
    [self redrawCenterCircle];
    [self redrawRightCircle];
    [self redrawCenterCircle];
}

- (void) bmiUpdatedNotificationHandler: (NSNotification *) notification
{
    [self redrawLeftCircle];
}

- (void) caloriesBalanceUpdatedNotificationHandler: (NSNotification *) notification
{
    [self.dailyTarget calculateDailyTargetAndRemainingCaloriesToBurn];
    [self redrawRightCircle];
}

- (void) dailyRemainingCaloriesToBurnNotificationHandler: (NSNotification *) notification
{
    [self redrawCenterCircle];
}

- (void) redrawLeftCircle
{
    
    double currentBMI = self.healthKitObject.BMI;
    self.leftCircleView.textString = [NSString stringWithFormat:@"BMI\n%0.2f", currentBMI];
    double leftRed = 51.0f/255.0f;
    double leftGreen = 204.0f/255.0f;
    double leftBlue = 204.0f/255.0f;
    
    if(currentBMI < 18.5 || currentBMI > 25)
    {
        leftGreen = 51.0f/255.0f;
        leftBlue = 204.0f/255.0f;
        if(currentBMI < 18.5)
        {
            leftRed = 128.0f + fabs(currentBMI - 18.5f)*50.0f;
        }
        else
        {
            leftRed = 128.f + fabs(currentBMI - 25.0f) * 25.0f;
        }
        if(leftRed > 255.0f) leftRed = 255.0f;
        leftRed /= 255.0f;
        
    }
    
    self.leftCircleView.strokeColor = [UIColor colorWithRed:leftRed green:leftGreen blue:leftBlue alpha:1];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.leftCircleView setNeedsDisplay];
    });
}

- (void) redrawCenterCircle
{
    double remainingCaloriesToBurn = self.dailyTarget.exerciseRemainingCaloriesToBurn;
    
    self.centerCircleView.textString = [NSString stringWithFormat:@"To Burn\n%0.1f kCal", (-1 * remainingCaloriesToBurn)];
    double leftRed = 51.0f/255.0f;
    double leftGreen = 204.0f/255.0f;
    double leftBlue = 204.0f/255.0f;
    
    if(remainingCaloriesToBurn < 0)
    {
        leftGreen = 51.0f/255.0f;
        leftBlue = 204.0f/255.0f;
        leftRed = 128.0f + (-1 * remainingCaloriesToBurn/10);
        
        if(leftRed > 255.0f) leftRed = 255.0f;
        leftRed /= 255.0f;
        
    }
    
    self.centerCircleView.strokeColor = [UIColor colorWithRed:leftRed green:leftGreen blue:leftBlue alpha:1];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.centerCircleView setNeedsDisplay];
    });

}

- (void) redrawRightCircle
{
    double netEnergy = self.healthKitObject.netEnergy/(4186.8);
    self.rightCircleView.textString = [NSString stringWithFormat:@"Balance\n%0.1f kCal", netEnergy];
    double leftRed = 51.0f/255.0f;
    double leftGreen = 204.0f/255.0f;
    double leftBlue = 204.0f/255.0f;
    
    if(netEnergy < -500 || netEnergy > 500)
    {
        leftGreen = 51.0f/255.0f;
        leftBlue = 204.0f/255.0f;
        
        leftRed = 128.0f + (fabs(netEnergy) - 500.0f)/10.0f;
        
        if(leftRed > 255.0f) leftRed = 255.0f;
        leftRed /= 255.0f;
    }
    
    self.rightCircleView.strokeColor = [UIColor colorWithRed:leftRed green:leftGreen blue:leftBlue alpha:1];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.rightCircleView setNeedsDisplay];
    });
}

- (void) redrawMainCircle
{
    
}
- (void) upadateRedrawMainCircle:(NSNotification *) notification
{
//    NSArray * dataArray = [NSArray arrayWithArray:[notification object]];
    NSNumber* number = [notification object];
    
    NSInteger integer = [number integerValue];
        switch (integer) {
        case -2:
            self.mainCircleView.textString = [NSString stringWithFormat:@"Very Bad"];
            break;
        case -1:
            self.mainCircleView.textString = [NSString stringWithFormat:@"Bad"];
            break;
        case 0:
            self.mainCircleView.textString = [NSString stringWithFormat:@"Normal"];
            break;
        case 1:
            self.mainCircleView.textString = [NSString stringWithFormat:@"Good"];
            break;
        case 2:
            self.mainCircleView.textString = [NSString stringWithFormat:@"Very Good"];
            break;

            
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainCircleView setNeedsDisplay];
    });}
- (void) initalizeThreadToUpdateDataOnAnotherThread
{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       [self.healthKitObject updateData];
                       [self.dailyTarget calculateDailyTargetAndRemainingCaloriesToBurn];
                   });
}
- (IBAction)addFoodLongPress:(id)sender {

    if([sender state] == UIGestureRecognizerStateRecognized)
    {
        [self performSegueWithIdentifier:@"AddFoodSegue" sender:nil];
    }
}

@end
