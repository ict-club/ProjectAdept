//
//  RGWebPost.h
//  World Payday
//
//  Created by iOS Developer on 09/03/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface RDWebPost : NSObject

-(void)loadDataToPostUserDataWithId:(NSInteger)Id andUserId:(NSInteger)userId andCaloriesToBeBurned:(NSInteger)caloriesToBeBurned andCaloriesBalance:(NSInteger)caloriesBalance;
-(void)loadDataToPostUserDataCaloriesWithId:(NSInteger)Id andName:(NSString*)name andAge:(NSInteger)age andTitle:(NSString*)title andOverallCondition:(NSInteger)overallCondition andRecommendedCalories:(float)recommendedCalories andPicture_small:(NSString*)picture_small andPicture_big:(NSString*)picture_big;

@end
