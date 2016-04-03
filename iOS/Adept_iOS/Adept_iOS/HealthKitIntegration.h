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
@property (nonatomic, assign) NSInteger exerciseTime;
@property (nonatomic, assign) NSInteger * heartRate;
@property (nonatomic, strong) NSDate * dateOfBirth;
@property (nonatomic, strong) HKBiologicalSexObject * biologicalSex;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, assign) NSInteger height;


- (void) initialize;
+ (id) sharedInstance;
- (void) updateData;

@end
