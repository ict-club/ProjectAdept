//
//  DailyTarget.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/9/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "DailyTarget.h"
#import "HKHealthStore+AAPLExtensions.h"
#import "HealthKitIntegration.h"

@implementation DailyTarget

- (instancetype) init
{
    if (self)
    {
        self.healthKit = [HealthKitIntegration sharedInstance];
        return [super init];
        
    }
    return nil;
}

- (void) calculateDailyTargetAndRemainingCaloriesToBurn
{
    self.dailyTarget = 2000;
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:DAILY_TAGET_UPDATED object:self];
    [self calculateRemainingExerciseCaloriesToBurn];
    
}

- (void) calculateRemainingExerciseCaloriesToBurn
{
    double currentlyBurnedCaloriesForToday = (self.healthKit.activeEnergyBurned / 4186.8);
    self.exerciseRemainingCaloriesToBurn = currentlyBurnedCaloriesForToday - self.dailyTarget;
    
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:DAILY_REMAINING_CALORIES_TO_BURN_UPDATED object:self];

}


@end
