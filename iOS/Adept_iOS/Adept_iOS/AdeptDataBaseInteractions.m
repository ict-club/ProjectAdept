//
//  AdeptDataBaseInteractions.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/24/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "AdeptDataBaseInteractions.h"
#import "RDWebGet.h"
#import "RDWebPost.h"

@implementation AdeptDataBaseInteractions

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        // TODO: init timer to refresh the information
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weightDataUpdatedNotification:) name:@"WeightChartDataForWeek" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(muscleDataUpdatedNotification:) name:@"MuscleStrengthForWeek" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boneDataUpdatedNotification:) name:@"BondeStructureForWeek" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(caloriesDataUpdatedNotification:) name:@"CaloriesBalanceForWeek" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heartRateDataUpdatedNotification:) name:@"HeartRateForWeek" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OveralConditionDataUpdatedNotification:) name:@"OveralCondition" object:nil];

        
    }
    return self;
}

- (void) updateUserDataInfo
{
    
}

- (void) updateOverallCondition
{
    NSMutableDictionary* valueDictionary = [[NSMutableDictionary alloc] init];
    [valueDictionary setObject:[NSNumber numberWithInteger:1] forKey:@"UserId"];
    
    NSArray* valueArray = [NSArray arrayWithObject:valueDictionary];
    NSDictionary* dataDictionary = [NSDictionary dictionaryWithObject:valueArray forKey:@"parameters"];
    NSMutableArray * arrayForData = [[NSMutableArray alloc] init];
    [RDWebGet executeGetRequestWithURL:[NSURL URLWithString:@"http://adept-adeptserver.rhcloud.com/userData"] andHeaders:dataDictionary andWriteDataTo:arrayForData onCompletePostNotificationWithName:@"OveralCondition"];
    NSLog(@"%@", arrayForData);
}
-(void)OveralConditionDataUpdatedNotification:(NSNotification *) notification
{
    NSArray * dataArray = [NSArray arrayWithArray:[notification object]];
    self.weightChartDataForWeek = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dataArray) {
        self.overallCondition = [[dictionary objectForKey:@"OverallCondition"] integerValue];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OverallConditionUpdate" object:[NSNumber numberWithInteger:self.overallCondition]];

}
- (void) updateCaloriesTableArray
{
    
}

- (void) updateMuscleStrengthArray
{
    
}

- (void) updateMuscleStrength;
{
    
}

- (void) updateRestingHeartRateArray;
{
    
}
- (void) updateExerciseRecommendedExerciseArray
{
    
}
- (void) updateWeightChartDataForWeek
{
//    NSDictionary* valueDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:1] forKey:@"UserId"];
    
    NSDate* currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"]; // Date formater
    NSString *dateNow = [dateformate stringFromDate:[NSDate date]]; // Convert date to string
    NSString *dateWeekAgo = [dateformate stringFromDate:sevenDaysAgo]; // Convert date to string
    
    
    NSMutableDictionary* valueDictionary = [[NSMutableDictionary alloc] init];
    [valueDictionary setObject:[NSNumber numberWithInteger:1] forKey:@"UserId"];
    [valueDictionary setObject:[NSNumber numberWithInteger:7] forKey:@"Points"];
    [valueDictionary setObject:dateWeekAgo forKey:@"FromDate"];
    [valueDictionary setObject:dateNow forKey:@"ToDate"];
    
    NSArray* valueArray = [NSArray arrayWithObject:valueDictionary];
    NSDictionary* dataDictionary = [NSDictionary dictionaryWithObject:valueArray forKey:@"parameters"];
    NSMutableArray * arrayForData = [[NSMutableArray alloc] init];
    [RDWebGet executeGetRequestWithURL:[NSURL URLWithString:@"http://adept-adeptserver.rhcloud.com/weightChart"] andHeaders:dataDictionary andWriteDataTo:arrayForData onCompletePostNotificationWithName:@"WeightChartDataForWeek"];
    NSLog(@"%@", arrayForData);
}
- (void)weightDataUpdatedNotification:(NSNotification *) notification
{
    NSArray * dataArray = [NSArray arrayWithArray:[notification object]];
    self.weightChartDataForWeek = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dataArray) {
        [self.weightChartDataForWeek addObject:[dictionary objectForKey:@"Weight"]];
    }
}
- (void) updateMuscleStrengthForWeek
{
    NSDate* currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"]; // Date formater
    NSString *dateNow = [dateformate stringFromDate:[NSDate date]]; // Convert date to string
    NSString *dateWeekAgo = [dateformate stringFromDate:sevenDaysAgo]; // Convert date to string
    
    
    NSMutableDictionary* valueDictionary = [[NSMutableDictionary alloc] init];
    [valueDictionary setObject:[NSNumber numberWithInteger:1] forKey:@"UserId"];
    [valueDictionary setObject:[NSNumber numberWithInteger:7] forKey:@"Points"];
    [valueDictionary setObject:dateWeekAgo forKey:@"FromDate"];
    [valueDictionary setObject:dateNow forKey:@"ToDate"];
    
    NSArray* valueArray = [NSArray arrayWithObject:valueDictionary];
    NSDictionary* dataDictionary = [NSDictionary dictionaryWithObject:valueArray forKey:@"parameters"];
    NSMutableArray * arrayForData = [[NSMutableArray alloc] init];
    [RDWebGet executeGetRequestWithURL:[NSURL URLWithString:@"http://adept-adeptserver.rhcloud.com/msChart"] andHeaders:dataDictionary andWriteDataTo:arrayForData onCompletePostNotificationWithName:@"MuscleStrengthForWeek"];
    NSLog(@"%@", arrayForData);
}
- (void)muscleDataUpdatedNotification:(NSNotification *) notification
{
    NSArray * dataArray = [NSArray arrayWithArray:[notification object]];
    self.muscleStrengthChartForWeek = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dataArray) {
        [self.muscleStrengthChartForWeek addObject:[dictionary objectForKey:@"Muscle_strenght"]];
    }
}
- (void) updateWristBondeStructureForWeek
{
    NSDate* currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"]; // Date formater
    NSString *dateNow = [dateformate stringFromDate:[NSDate date]]; // Convert date to string
    NSString *dateWeekAgo = [dateformate stringFromDate:sevenDaysAgo]; // Convert date to string
    
    
    NSMutableDictionary* valueDictionary = [[NSMutableDictionary alloc] init];
    [valueDictionary setObject:[NSNumber numberWithInteger:1] forKey:@"UserId"];
    [valueDictionary setObject:[NSNumber numberWithInteger:7] forKey:@"Points"];
    [valueDictionary setObject:dateWeekAgo forKey:@"FromDate"];
    [valueDictionary setObject:dateNow forKey:@"ToDate"];
    
    NSArray* valueArray = [NSArray arrayWithObject:valueDictionary];
    NSDictionary* dataDictionary = [NSDictionary dictionaryWithObject:valueArray forKey:@"parameters"];
    NSMutableArray * arrayForData = [[NSMutableArray alloc] init];
    [RDWebGet executeGetRequestWithURL:[NSURL URLWithString:@"http://adept-adeptserver.rhcloud.com/wbsChart"] andHeaders:dataDictionary andWriteDataTo:arrayForData onCompletePostNotificationWithName:@"BondeStructureForWeek"];
    NSLog(@"%@", arrayForData);
}
- (void)boneDataUpdatedNotification:(NSNotification *) notification
{
    NSArray * dataArray = [NSArray arrayWithArray:[notification object]];
    self.wristBoneStructureForWeek = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dataArray) {
        [self.wristBoneStructureForWeek addObject:[dictionary objectForKey:@"WristCirc"]];
    }
}
- (void) updateCaloriesBalanceForWeek
{
    NSDate* currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"]; // Date formater
    NSString *dateNow = [dateformate stringFromDate:[NSDate date]]; // Convert date to string
    NSString *dateWeekAgo = [dateformate stringFromDate:sevenDaysAgo]; // Convert date to string
    
    
    NSMutableDictionary* valueDictionary = [[NSMutableDictionary alloc] init];
    [valueDictionary setObject:[NSNumber numberWithInteger:1] forKey:@"UserId"];
    [valueDictionary setObject:[NSNumber numberWithInteger:7] forKey:@"Points"];
    [valueDictionary setObject:dateWeekAgo forKey:@"FromDate"];
    [valueDictionary setObject:dateNow forKey:@"ToDate"];
    
    NSArray* valueArray = [NSArray arrayWithObject:valueDictionary];
    NSDictionary* dataDictionary = [NSDictionary dictionaryWithObject:valueArray forKey:@"parameters"];
    NSMutableArray * arrayForData = [[NSMutableArray alloc] init];
    [RDWebGet executeGetRequestWithURL:[NSURL URLWithString:@"http://adept-adeptserver.rhcloud.com/cbChart"] andHeaders:dataDictionary andWriteDataTo:arrayForData onCompletePostNotificationWithName:@"CaloriesBalanceForWeek"];
    NSLog(@"%@", arrayForData);
}
- (void)caloriesDataUpdatedNotification:(NSNotification *) notification
{
    NSArray * dataArray = [NSArray arrayWithArray:[notification object]];
    self.caloriesBalanceForWeek = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dataArray) {
        [self.caloriesBalanceForWeek addObject:[dictionary objectForKey:@"CaloriesBalance"]];
    }
}
- (void) updateRestingHeartRateForWeek
{
    NSDate* currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"]; // Date formater
    NSString *dateNow = [dateformate stringFromDate:[NSDate date]]; // Convert date to string
    NSString *dateWeekAgo = [dateformate stringFromDate:sevenDaysAgo]; // Convert date to string
    
    
    NSMutableDictionary* valueDictionary = [[NSMutableDictionary alloc] init];
    [valueDictionary setObject:[NSNumber numberWithInteger:1] forKey:@"UserId"];
    [valueDictionary setObject:[NSNumber numberWithInteger:7] forKey:@"Points"];
    [valueDictionary setObject:dateWeekAgo forKey:@"FromDate"];
    [valueDictionary setObject:dateNow forKey:@"ToDate"];
    
    NSArray* valueArray = [NSArray arrayWithObject:valueDictionary];
    NSDictionary* dataDictionary = [NSDictionary dictionaryWithObject:valueArray forKey:@"parameters"];
    NSMutableArray * arrayForData = [[NSMutableArray alloc] init];
    [RDWebGet executeGetRequestWithURL:[NSURL URLWithString:@"http://adept-adeptserver.rhcloud.com/rhChart"] andHeaders:dataDictionary andWriteDataTo:arrayForData onCompletePostNotificationWithName:@"HeartRateForWeek"];
    NSLog(@"%@", arrayForData);
}
- (void)heartRateDataUpdatedNotification:(NSNotification *) notification
{
    NSArray * dataArray = [NSArray arrayWithArray:[notification object]];
    self.restingHeartRateForWeek = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dataArray) {
        [self.restingHeartRateForWeek addObject:[dictionary objectForKey:@"HeartRate"]];
    }
}
@end
