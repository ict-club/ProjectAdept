//
//  HealthKitIntegration.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/30/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface HealthKitIntegration : NSObject

@property (nonatomic, strong) HKHealthStore * healthStore;
@property (nonatomic, strong) NSNumber * bodyMass;
@property (nonatomic, strong) NSNumber * BMI;
@property (nonatomic, strong) NSNumber * activeEnergyBurned;
@property (nonatomic, strong) NSNumber * exerciseTime;
@property (nonatomic, strong) NSNumber * heartRate;
@property (nonatomic, strong) NSNumber * dateOfBirth;
@property (nonatomic, strong) HKBiologicalSexObject * biologicalSex;
@property (nonatomic, strong) NSNumber * stepCount;
@property (nonatomic, strong) NSNumber * height;


- (void) initialize;
+ (id) sharedInstance;
- (void) updateData;

@end
