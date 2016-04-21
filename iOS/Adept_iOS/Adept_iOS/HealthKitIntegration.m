//
//  HealthKitIntegration.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/30/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "HealthKitIntegration.h"
#import "HKHealthStore+AAPLExtensions.h"
#import "RDDateTime.h"

typedef enum
{
    HealthKitDateOfBirth,
    HealthKitBiologicalSex,
    HealthKitStepCount,
    HealthKitHeight,
    HealthKitBMI,
    HealthKitBodyMass,
    HealthKitActiveEnergy,
    HealthKitHartRate
} HeathKitDataType;



@implementation HealthKitIntegration

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (void)initialize
{
    self.healthStore = [[HKHealthStore alloc] init];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    
    if(NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable] && [defaults objectForKey:@"HealthKitIsAllowed"] == nil)
    {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        
        // Share body mass, height and body mass index
        NSSet *shareObjectTypes = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   nil];
        
        // Read date of birth, biological sex and step count
        NSSet *readObjectTypes  = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   nil];
        
        // Request access
        [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error) {
                                               if(success == YES)
                                               {
                                                   NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                                                   [notificationCenter postNotificationName:HEALTH_KIT_INITIALIZED object:self];
                                               }
                                               else
                                               {
                                                   NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                                                   [notificationCenter postNotificationName:@"HealthKitNotAvailable" object:self];
                                               }
                                               
                                               
                                           }];
        
    }
    else
    {
        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"HealthKitNotAvailable" object:self];
    }
    
    

}

- (void) updateData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                                                {
                                                    [self updateHeightForToday];
                                                    [self updateBodyMassForToday];
                                                    [self updateHeartRateForToday];
                                                    [self updateStepsForToday];
                                                    _dateOfBirth = self.dateOfBirth;
                                                    _biologicalSex = self.biologicalSex;
                                                    [self updateCaloriesBalance];
                                                    [self updateBMIForToday];
                                                    
                                                    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                                                    [notificationCenter postNotificationName:HEALTH_KIT_DATA_UPDATED object:self];
                                                });
}

#pragma mark - Step Count Data
- (void) updateStepsForToday
{
    self.stepCount = [self getDataForStepCountFrom:[RDDateTime beginingOfToday] to:[RDDateTime endOfToday]];
    if(self.stepCount < 0) self.stepCount = 0;
}

- (NSInteger) getDataForStepCountFrom: (NSDate *) startDate to: (NSDate *) endDate
{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSInteger returnResult = 0;
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    
                                                                    for(HKQuantitySample *sample in results)
                                                                    {
                                                                        returnResult += [sample.quantity doubleValueForUnit: [HKUnit countUnit]];
                                                                    }
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    returnResult = -1;
                                                                }
                                                                
                                                                dispatch_semaphore_signal(semaphore);
                                                                
                                                            }];
    
    [self.healthStore executeQuery:sampleQuery];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return returnResult;
}

#pragma mark - bodyMassIndex

- (void) updateBMIForToday
{
    
//    [self.healthStore aapl_mostRecentQuantitySampleOfType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex] predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
//        if(mostRecentQuantity)
//        {
//            HKUnit * BMIunit = [HKUnit countUnit];
//            self.BMI = [mostRecentQuantity doubleValueForUnit:BMIunit];
//            NSLog(@"BMI Updated notification sent");
//            NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
//            [defaultCenter postNotificationName:BMI_UPDATED object:self];
//        }
//    }];
    self.BMI = self.bodyMass / (self.height * self.height);
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
               [defaultCenter postNotificationName:BMI_UPDATED object:self];
}

- (double) getAverageBMIForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate
{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block double returnResult = 0;
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    
                                                                    for(HKQuantitySample *sample in results)
                                                                    {
                                                                        returnResult += [sample.quantity doubleValueForUnit: [HKUnit countUnit]];
                                                                    }
                                                                    
                                                                    returnResult /= [results count];
                                                                }
                                                                else
                                                                {
                                                                    returnResult = -1;
                                                                }
                                                                
                                                                dispatch_semaphore_signal(semaphore);
                                                                
                                                            }];
    
    [self.healthStore executeQuery:sampleQuery];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return returnResult;
}

- (void) updateBMIinHealthKit
{
    
    double BMI = self.bodyMass / (self.height * self.height);
    if(BMI > 0 && isnan(BMI) == NO)
    {
        HKQuantity *BMIquantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:BMI];
        HKQuantityType * BMIquantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
        NSDate * now = [NSDate date];
        
        HKQuantitySample *BMISample = [HKQuantitySample quantitySampleWithType:BMIquantityType quantity:BMIquantity startDate:now endDate:now];
        
        [self.healthStore saveObject:BMISample withCompletion:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error while saving BMI (%f) to Health Store: %@.", BMI, error);
            }
        }];
        self.BMI = BMI;
    }
    
}


#pragma mark - Body Mass

- (void) updateBodyMassForToday
{
    [self.healthStore aapl_mostRecentQuantitySampleOfType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass] predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if(mostRecentQuantity)
        {
            HKUnit * BodyMassUnit = [HKUnit gramUnit];
            self.bodyMass = ((double)[mostRecentQuantity doubleValueForUnit:BodyMassUnit]/(double)1000);
        }
    }];
    
}

- (double) getAverageBodyMassForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate
{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block double returnResult = 0;
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    
                                                                    for(HKQuantitySample *sample in results)
                                                                    {
                                                                        returnResult += [sample.quantity doubleValueForUnit: [HKUnit gramUnit]];
                                                                    }
                                                                    
                                                                    returnResult /= [results count];
                                                                    returnResult /= 1000;
                                                                }
                                                                else
                                                                {
                                                                    returnResult = -1;
                                                                }
                                                                
                                                                dispatch_semaphore_signal(semaphore);
                                                                
                                                            }];
    
    [self.healthStore executeQuery:sampleQuery];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return returnResult;
}

- (void) writeBodyMassToHealthKit: (double) bodyMass
{
    
    HKQuantity *BMquantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:bodyMass];
    HKQuantityType * BMquantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSDate * now = [NSDate date];
    
    HKQuantitySample *BMSample = [HKQuantitySample quantitySampleWithType:BMquantityType quantity:BMquantity startDate:now endDate:now];
    
    [self.healthStore saveObject:BMSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error while saving BMI (%f) to Health Store: %@.", bodyMass, error);
        }
    }];
    self.bodyMass = bodyMass;
}

#pragma mark - Height

- (void) updateHeightForToday
{
    [self.healthStore aapl_mostRecentQuantitySampleOfType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight] predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if(mostRecentQuantity)
        {
            HKUnit * heightUnit = [HKUnit meterUnit];
            self.height = [mostRecentQuantity doubleValueForUnit:heightUnit];
        }
    }];
    
}

- (double) getAverageHeightForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate
{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block double returnResult = 0;
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    
                                                                    for(HKQuantitySample *sample in results)
                                                                    {
                                                                        returnResult += [sample.quantity doubleValueForUnit: [HKUnit meterUnit]];
                                                                    }
                                                                    
                                                                    returnResult /= [results count];
                                                                }
                                                                else
                                                                {
                                                                    returnResult = -1;
                                                                }
                                                                
                                                                dispatch_semaphore_signal(semaphore);
                                                                
                                                            }];
    
    [self.healthStore executeQuery:sampleQuery];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return returnResult;
}

#pragma mark Heart Rate

- (void) updateHeartRateForToday
{
    self.heartRate = [self getAverageHeartRateForPeriodFrom: [RDDateTime beginingOfToday] to:[RDDateTime endOfToday]];
    
    if(self.heartRate < 1)
    {
        [self.healthStore aapl_mostRecentQuantitySampleOfType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate] predicate:nil completion:^(HKQuantity *mostRecentQuantity, NSError *error) {
            if(mostRecentQuantity)
            {
                HKUnit * HRUnit = [[HKUnit countUnit]unitDividedByUnit:[HKUnit minuteUnit]];
                self.heartRate = [mostRecentQuantity doubleValueForUnit:HRUnit];
            }
        }];

    }
}

- (NSInteger) getAverageHeartRateForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate
{
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block double returnResult = 0;
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    
                                                                    for(HKQuantitySample *sample in results)
                                                                    {
                                                                        returnResult += [sample.quantity doubleValueForUnit: [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]]];
                                                                    }
                                                                    
                                                                    returnResult /= [results count];
                                                                }
                                                                else
                                                                {
                                                                    returnResult = -1;
                                                                }
                                                                
                                                                dispatch_semaphore_signal(semaphore);
                                                                
                                                            }];
    
    [self.healthStore executeQuery:sampleQuery];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return returnResult;
}

- (void) writeHeartRatetoHealthKit: (NSInteger) heartRateValue
{
    HKQuantity *HRQuantity = [HKQuantity quantityWithUnit:[[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]] doubleValue:(double)heartRateValue];
    
    HKQuantityType * HRQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    NSDate * now = [NSDate date];
    
    HKQuantitySample *HRSample = [HKQuantitySample quantitySampleWithType:HRQuantityType quantity:HRQuantity startDate:now endDate:now];
    
    [self.healthStore saveObject:HRSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error while saving heart rate (%ld) to Health Store: %@.", heartRateValue, error);
        }
    }];
}

- (double) getCaloriesForHeartRate: (NSInteger) heartRate andTime: (NSInteger) time
{
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self.dateOfBirth toDate:now options:NSCalendarWrapComponents];
    NSUInteger ageInYears = ageComponents.year;
    
    if([self.biologicalSex biologicalSex] == HKBiologicalSexMale)
    {
        //Male = ((-55.0969 + (0.6309 × HR) + (0.1988 × W) + (0.2017 × A)) / 4.184) × 60 × T
        return ((-55.0969f + 0.6309f * heartRate + 0.1988f * self.bodyMass + 0.2017f * ageInYears)/4.184f) * (double)(time / 60.0f);
    }
    else
    {
        //Female = ((-20.4022 + (0.4472 × HR) - (0.1263 × W) + (0.074 × A)) / 4.184) × 60 × T
        return ((-20.4022f + 0.4472f * heartRate + 0.1988f * self.bodyMass + 0.2017f * ageInYears)/4.184f) * (double)(time/60.0f);
    }
}

- (double) getCaloriesForIsometricsForce: (NSInteger) isometricForce andTime:(float) time
{
    NSInteger heartRate = isometricForce/25 + 90;
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self.dateOfBirth toDate:now options:NSCalendarWrapComponents];
    NSUInteger ageInYears = ageComponents.year;
    
    if([self.biologicalSex biologicalSex] == HKBiologicalSexMale)
    {
        //Male = ((-55.0969 + (0.6309 × HR) + (0.1988 × W) + (0.2017 × A)) / 4.184) × 60 × T
        return ((-55.0969f + 0.6309f * heartRate + 0.1988f * self.bodyMass + 0.2017f * ageInYears)/4.184f) * (double)(time / 60.0f);
    }
    else
    {
        //Female = ((-20.4022 + (0.4472 × HR) - (0.1263 × W) + (0.074 × A)) / 4.184) × 60 × T
        return ((-20.4022f + 0.4472f * heartRate + 0.1988f * self.bodyMass + 0.2017f * ageInYears)/4.184f) * (double)(time/60.0f);
    }
}

#pragma mark - Actve energy burned

- (double) getActiveEnergyForPeriodFrom: (NSDate *) startDate toData: (NSDate *) endDate
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block double returnResult = 0;
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                 predicate:predicate
                                                                     limit:HKObjectQueryNoLimit
                                                           sortDescriptors:@[sortDescriptor]
                                                            resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                
                                                                if(!error && results)
                                                                {
                                                                    
                                                                    for(HKQuantitySample *sample in results)
                                                                    {
                                                                        returnResult += [sample.quantity doubleValueForUnit: [HKUnit calorieUnit]];
                                                                    }
                                                                    
                                                                }
                                                                else
                                                                {
                                                                    returnResult = -1;
                                                                }
                                                                
                                                                dispatch_semaphore_signal(semaphore);
                                                                
                                                            }];
    
    [self.healthStore executeQuery:sampleQuery];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return returnResult;

}

- (void) writeActiveEnergyBurnedToHealthKit: (double) caloriesBurned
{
    HKQuantity *activeEnergyBurnedQuantity = [HKQuantity quantityWithUnit:[HKUnit calorieUnit] doubleValue:(caloriesBurned * 1000)];
    
    HKQuantityType * activeEnergyQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    NSDate * now = [NSDate date];
    
    HKQuantitySample *activeCaloriesSample = [HKQuantitySample quantitySampleWithType:activeEnergyQuantityType quantity:activeEnergyBurnedQuantity startDate:now endDate:now];
    
    [self.healthStore saveObject:activeCaloriesSample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error while saving heart rate (%lf) to Health Store: %@.", caloriesBurned, error);
        }
    }];

}

#pragma mark - Intake and Burned Calories

- (void) updateCaloriesBalance {
    
    HKQuantityType *energyConsumedType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    // First, fetch the sum of energy consumed samples from HealthKit. Populate this by creating your
    // own food logging app or using the food journal view controller.
    [self fetchSumOfSamplesTodayForType:energyConsumedType unit:[HKUnit jouleUnit] completion:^(double totalJoulesConsumed, NSError *error) {
        
        // Next, fetch the sum of active energy burned from HealthKit. Populate this by creating your
        // own calorie tracking app or the Health app.
        [self fetchSumOfSamplesTodayForType:activeEnergyBurnType unit:[HKUnit jouleUnit] completion:^(double activeEnergyBurned, NSError *error) {
            
            // Last, calculate the user's basal energy burn so far today.
            [self fetchTotalBasalBurn:^(HKQuantity *basalEnergyBurn, NSError *error) {
                
                if (!basalEnergyBurn) {
                    NSLog(@"An error occurred trying to compute the basal energy burn. In your app, handle this gracefully. Error: %@", error);
                }
                
                // Update the UI with all of the fetched values.
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.activeEnergyBurned = activeEnergyBurned;
                    
                    self.restingEnergyBurned = [basalEnergyBurn doubleValueForUnit:[HKUnit jouleUnit]];
                    
                    self.energyConsumed = totalJoulesConsumed;
                    
                    self.netEnergy = self.energyConsumed - self.activeEnergyBurned - self.restingEnergyBurned;
                    
                    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:CALORIE_BALANCE_UPDATED object:self];
                    
                });
            }];
        }];
    }];
}

- (void)fetchTotalBasalBurn:(void(^)(HKQuantity *basalEnergyBurn, NSError *error))completion {
    NSPredicate *todayPredicate = [self predicateForSamplesToday];
    
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *weight, NSError *error) {
        if (!weight) {
            completion(nil, error);
            
            return;
        }
        
        [self.healthStore aapl_mostRecentQuantitySampleOfType:heightType predicate:todayPredicate completion:^(HKQuantity *height, NSError *error) {
            if (!height) {
                completion(nil, error);
                
                return;
            }
            
            NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
            if (!dateOfBirth) {
                completion(nil, error);
                
                return;
            }
            
            HKBiologicalSexObject *biologicalSexObject = [self.healthStore biologicalSexWithError:&error];
            if (!biologicalSexObject) {
                completion(nil, error);
                
                return;
            }
            
            // Once we have pulled all of the information without errors, calculate the user's total basal energy burn
            HKQuantity *basalEnergyBurn = [self calculateBasalBurnTodayFromWeight:weight height:height dateOfBirth:dateOfBirth biologicalSex:biologicalSexObject];
            
            completion(basalEnergyBurn, nil);
        }];
    }];
}


- (NSDate *) dateOfBirth
{
    NSError * error;
    _dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    return _dateOfBirth;
}

- (HKBiologicalSexObject*) biologicalSex
{
     NSError *error;
    _biologicalSex = [self.healthStore biologicalSexWithError:&error];
    return _biologicalSex;

}

#pragma mark - NSEnergyFormatter

- (NSEnergyFormatter *)energyFormatter {
    static NSEnergyFormatter *energyFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        energyFormatter = [[NSEnergyFormatter alloc] init];
        energyFormatter.unitStyle = NSFormattingUnitStyleLong;
        energyFormatter.forFoodEnergyUse = YES;
        energyFormatter.numberFormatter.maximumFractionDigits = 2;
    });
    
    return energyFormatter;
}

- (HKQuantity *) calculateBasalBurnToday
{
    HKQuantity * bodyMass = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:self.bodyMass*1000];
    HKQuantity * height = [HKQuantity quantityWithUnit:[HKUnit meterUnit] doubleValue:self.height];
    
    return [self calculateBasalBurnTodayFromWeight:bodyMass height:height dateOfBirth:self.dateOfBirth biologicalSex:self.biologicalSex];
}

#pragma mark - Private methods

- (HKQuantity *)calculateBasalBurnTodayFromWeight:(HKQuantity *)weight height:(HKQuantity *)height dateOfBirth:(NSDate *)dateOfBirth biologicalSex:(HKBiologicalSexObject *)biologicalSex {
    // Only calculate Basal Metabolic Rate (BMR) if we have enough information about the user
    if (!weight || !height || !dateOfBirth || !biologicalSex) {
        return nil;
    }
    
    // Note the difference between calling +unitFromString: vs creating a unit from a string with
    // a given prefix. Both of these are equally valid, however one may be more convenient for a given
    // use case.
    double heightInCentimeters = [height doubleValueForUnit:[HKUnit unitFromString:@"cm"]];
    double weightInKilograms = [weight doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo]];
    
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
    NSUInteger ageInYears = ageComponents.year;
    
    // BMR is calculated in kilocalories per day.
    double BMR = [self calculateBMRFromWeight:weightInKilograms height:heightInCentimeters age:ageInYears biologicalSex:[biologicalSex biologicalSex]];
    
    // Figure out how much of today has completed so we know how many kilocalories the user has burned.
    NSDate *startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:now];
    NSDate *endOfToday = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startOfToday options:0];
    
    NSTimeInterval secondsInDay = [endOfToday timeIntervalSinceDate:startOfToday];
    double percentOfDayComplete = [now timeIntervalSinceDate:startOfToday] / secondsInDay;
    
    double kilocaloriesBurned = BMR * percentOfDayComplete;
    
    return [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:kilocaloriesBurned];
}


- (double)calculateBMRFromWeight:(double)weightInKilograms height:(double)heightInCentimeters age:(NSUInteger)ageInYears biologicalSex:(HKBiologicalSex )biologicalSex {
    double BMR;
    
    // The BMR equation is different between males and females.
    if (biologicalSex == HKBiologicalSexMale) {
        BMR = 66.0 + (13.8 * weightInKilograms) + (5 * heightInCentimeters) - (6.8 * ageInYears);
    }
    else {
        BMR = 655 + (9.6 * weightInKilograms) + (1.8 * heightInCentimeters) - (4.7 * ageInYears);
    }
    
    return BMR;
}


- (void)fetchSumOfSamplesTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double, NSError *))completionHandler {
    NSPredicate *predicate = [self predicateForSamplesToday];
    
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        
        if (completionHandler) {
            double value = [sum doubleValueForUnit:unit];
            
            completionHandler(value, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDate *startDate = [calendar startOfDayForDate:now];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
}

#pragma mark - Setter Overrides

- (void)setActiveEnergyBurned:(double)activeEnergyBurned {
    _activeEnergyBurned = activeEnergyBurned;
}

- (void)setEnergyConsumed:(double)energyConsumed {
    _energyConsumed = energyConsumed;
}

- (void)setRestingEnergyBurned:(double)restingEnergyBurned {
    _restingEnergyBurned = restingEnergyBurned;
}

- (void)setNetEnergy:(double)netEnergy {
    _netEnergy = netEnergy;
    
}



@end
