//
//  HealthKitIntegration.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/30/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "HealthKitIntegration.h"
#import "RDDateTime.h"

#define HEALTH_KIT_DATA_UPDATED @"HKDATAUPDATED"

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
    if(NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable])
    {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        
        // Share body mass, height and body mass index
        NSSet *shareObjectTypes = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
                                   nil];
        
        // Read date of birth, biological sex and step count
        NSSet *readObjectTypes  = [NSSet setWithObjects:
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   nil];
        
        // Request access
        [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error) {
                                               
                                               if(success == YES || [HKHealthStore isHealthDataAvailable] == YES)
                                               {
                                                   // ...
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
    
    [self updateStepsForToday];

}

- (void) updateData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                                                {
                                                    [self updateStepsForToday];
                                                    [self updateBMIForToday];
                                                    [self updateHeightForToday];
                                                    [self updateBodyMassForToday];
                                                    [self updateHeartRateForToday];
                                                    
                                                    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
                                                    [notificationCenter postNotificationName:HEALTH_KIT_DATA_UPDATED object:self];
                                                });
}

#pragma mark - Step Count Data
- (void) updateStepsForToday
{
    self.stepCount = [self getDataForStepCountFrom:[RDDateTime beginingOfToday] to:[RDDateTime endOfToday]];
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
    self.BMI = [self getAverageBMIForPeriodFrom: [RDDateTime beginingOfToday] to:[RDDateTime endOfToday]];
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


#pragma mark - Body Mass

- (void) updateBodyMassForToday
{
    self.bodyMass = [self getAverageBodyMassForPeriodFrom: [RDDateTime beginingOfToday] to:[RDDateTime endOfToday]];
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

#pragma mark - Height

- (void) updateHeightForToday
{
    self.height = [self getAverageHeightForPeriodFrom: [RDDateTime beginingOfToday] to:[RDDateTime endOfToday]];
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
    self.bodyMass = [self getAverageBodyMassForPeriodFrom: [RDDateTime beginingOfToday] to:[RDDateTime endOfToday]];
}

- (double) getAverageHeartRateForPeriodFrom: (NSDate *) startDate to: (NSDate *) endDate
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

- (void) writeHeartRatetoHealthKit: (NSInteger) heartRateValue
{
    HKQuantity *BMIquantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:(double)heartRateValue];
    HKQuantityType * BMIquantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    NSDate * now = [NSDate date];
    
    HKQuantitySample *BMISample = [HKQuantitySample quantitySampleWithType:BMIquantityType quantity:BMIquantity startDate:now endDate:now];
    
    [self.healthStore saveObject:BMISample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error while saving heart rate (%ld) to Health Store: %@.", heartRateValue, error);
        }
    }];
}



- (NSDate *) dateOfBirth
{
    NSError * error;
    return [self.healthStore dateOfBirthWithError:&error];
}

- (HKBiologicalSexObject*) biologicalSex
{
     NSError *error;
    return [self.healthStore biologicalSexWithError:&error];

}

@end
