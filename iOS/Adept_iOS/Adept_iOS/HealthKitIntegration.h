//
//  HealthKitIntegration.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/30/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

#define HEALTH_KIT_DATA_UPDATED @"HKDATAUPDATED"
#define BMI_UPDATED @"BMI_UPDATED"
#define CALORIE_BALANCE_UPDATED @"CALORIE_BALANCE_UPDATED"
#define HEALTH_KIT_INITIALIZED @"HEALTH_KIT_INITIALIZED"

@interface HealthKitIntegration : NSObject

@property (nonatomic, strong) HKHealthStore * healthStore;
@property (nonatomic, assign) double bodyMass;
@property (nonatomic, assign) double BMI;
@property (nonatomic, assign) NSInteger exerciseTime;
@property (nonatomic, assign) NSInteger heartRate;
@property (nonatomic, strong) NSDate * dateOfBirth;
@property (nonatomic, strong) HKBiologicalSexObject * biologicalSex;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) double restingEnergyBurned;
@property (nonatomic, assign) double activeEnergyBurned;
@property (nonatomic, assign) double energyConsumed;
@property (nonatomic, assign) double netEnergy;

- (void) initialize;
+ (id) sharedInstance;
- (void) updateData;
- (void) updateStepsForToday;
- (NSInteger) getDataForStepCountFrom: (NSDate *) startDate to: (NSDate *) endDate;
- (void) updateBMIForToday;
- (double) getAverageBMIForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate;
- (void) updateBMIinHealthKit;
- (void) updateBodyMassForToday;
- (double) getAverageBodyMassForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate;
- (void) writeBodyMassToHealthKit: (double) bodyMass;
- (void) updateHeightForToday;
- (double) getAverageHeightForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate;
- (void) updateHeartRateForToday;
- (NSInteger) getAverageHeartRateForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate;
- (void) writeHeartRatetoHealthKit: (NSInteger) heartRateValue;
- (NSDate *) dateOfBirth;
- (HKBiologicalSexObject*) biologicalSex;


@end
