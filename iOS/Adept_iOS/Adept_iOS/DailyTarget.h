//
//  DailyTarget.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/9/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKHealthStore+AAPLExtensions.h"
#import "HealthKitIntegration.h"

#define DAILY_TAGET_UPDATED @"daylyTargetUpdated"
#define DAILY_REMAINING_CALORIES_TO_BURN_UPDATED @"dailyRemainingCaloriesToBurnUpdated"

@interface DailyTarget : NSObject

@property (nonatomic, assign) double dailyTarget;
@property (nonatomic, assign) double exerciseRemainingCaloriesToBurn;
@property (nonatomic, strong) HealthKitIntegration * healthKit;

- (void) calculateDailyTargetAndRemainingCaloriesToBurn;
- (void) calculateRemainingExerciseCaloriesToBurn;


@end
