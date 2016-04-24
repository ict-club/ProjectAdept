//
//  AdeptDataBaseInteractions.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/24/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdeptDataBaseInteractions : NSObject

@property (nonatomic, strong) NSDictionary * userdataInfo; // Holds the userdata info (Look at the communication document at tab MISC
@property (nonatomic, assign) NSInteger overallCondition; // returns the overall condition of the current user from userinfo.
@property (nonatomic, assign) NSInteger userId; // holds the current user id. Will be used for requests

@property (nonatomic, strong) NSArray * caloriesTableArray; // array that holds information from calories table in the data base. Low priority for implementation.

@property (nonatomic, strong) NSArray * muscleStrengthArray; // hold information about muscle strength table.
@property (nonatomic, strong) NSDictionary * muscleStrength; // hold dictionary with data for all the 6 muscle groups power from the last log in the service.
@property (nonatomic, strong) NSArray * restingHeartRateArray; // hold information about the resting heart rate logs in the data base

// @property (nonatomic, strong) NSArray * exerciseLogArray; // hold the information about the exercise log -- will keep that locally

@property (nonatomic, strong) NSArray * exerciseRecommendedExerciseArray; // hold information about recommended exercises

+ (id)sharedInstance;

@property (nonatomic, strong) NSMutableArray * weightChartDataForWeek; // holds information about 7 logs for weight in the database for the last week

@property (nonatomic, strong) NSMutableArray * muscleStrengthChartForWeek;

@property (nonatomic, strong) NSMutableArray * wristBoneStructureForWeek;

@property (nonatomic, strong) NSMutableArray * caloriesBalanceForWeek;

@property (nonatomic, strong) NSMutableArray * restingHeartRateForWeek;


- (void) updateUserDataInfo;

- (void) updateOverallCondition;

- (void) updateCaloriesTableArray;

- (void) updateMuscleStrengthArray;

- (void) updateMuscleStrength;

- (void) updateRestingHeartRateArray;

//- (void) updateExerciseLogArray; -- Will keep that locally in user defaults

- (void) updateExerciseRecommendedExerciseArray;

- (void) updateWeightChartDataForWeek;

- (void) updateMuscleStrengthForWeek;

- (void) updateWristBondeStructureForWeek;

- (void) updateCaloriesBalanceForWeek;

- (void) updateRestingHeartRateForWeek;


- (void) insertMuscleStrengthInfo; // add parameters for the insert

- (void) insertRestingHeartRateInfo; // add parameters for the insert

- (void) insertWeightInfo;

- (void) insertWristBoneStructureInfo;

- (void) insertCaloriesBalance: (NSNumber *) balance andRemainingCalories: (NSNumber *) remainingCalories;



@end
