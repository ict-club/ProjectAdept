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
