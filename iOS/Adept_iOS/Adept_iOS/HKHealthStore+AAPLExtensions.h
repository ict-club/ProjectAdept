//
//  HKHealthStore+AAPLExtensions.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/7/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

@import HealthKit;

@interface HKHealthStore (AAPLExtensions)

// Fetches the single most recent quantity of the specified type.
- (void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(HKQuantity *mostRecentQuantity, NSError *error))completion;

@end