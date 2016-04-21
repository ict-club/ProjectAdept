//
//  RGWebPost.m
//  World Payday
//
//  Created by iOS Developer on 09/03/2016.
//  Copyright © 2016 iOS Developer. All rights reserved.
//

#import "RDWebPost.h"
#import "RDWeb.h"


@implementation RDWebPost

-(void)loadDataToPostUserDataWithId:(NSInteger)Id andUserId:(NSInteger)userId andCaloriesToBeBurned:(NSInteger)caloriesToBeBurned andCaloriesBalance:(NSInteger)caloriesBalance
{   //Getting Time Stamp
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    //This is the shown time format in the documentation "2016-04-18T17:48:47.000Z"
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    dateString = [formatter stringFromDate:[NSDate date]];

    
    NSMutableDictionary *dictionaryToPost = [NSMutableDictionary
                                             dictionaryWithDictionary:@{
                                                                        @"id" : [NSNumber numberWithUnsignedInteger:Id],
                                                                        @"UserId" : [NSNumber numberWithUnsignedInteger:userId],
                                                                        @"CaloriesToBeBurned" : [NSNumber numberWithUnsignedInteger:caloriesToBeBurned],
                                                                        @"CaloriesBalance" : [NSNumber numberWithUnsignedInteger:caloriesBalance],
                                                                        @"Timestamp" : dateString
                                                                        }];
    [self postToServerWithDictionaryToPost:dictionaryToPost];
    
}
-(void)loadDataToPostUserDataCaloriesWithId:(NSInteger)Id andName:(NSString*)name andAge:(NSInteger)age andTitle:(NSString*)title andOverallCondition:(NSInteger)overallCondition andRecommendedCalories:(float)recommendedCalories andPicture_small:(NSString*)picture_small andPicture_big:(NSString*)picture_big
{   //Getting Time Stamp
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    //This is the shown time format in the documentation "2016-04-18T17:48:47.000Z"
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *dictionaryToPost = [NSMutableDictionary
                                             dictionaryWithDictionary:@{
                                                                        @"id" : [NSNumber numberWithUnsignedInteger:Id],
                                                                        @"Name" : name,
                                                                        @"Age" : [NSNumber numberWithUnsignedInteger:age],
                                                                        @"Title" : title,
                                                                        @"OverallCondition" : [NSNumber numberWithUnsignedInteger:overallCondition],
                                                                        @"RecommendedCalories" : [NSNumber numberWithFloat:recommendedCalories],
                                                                        @"picture_small" : picture_small,
                                                                        @"picture_big" : picture_big
                                                                        }];

    [self postToServerWithDictionaryToPost:dictionaryToPost];
    
}
-(void)postToServerWithDictionaryToPost:(NSMutableDictionary*)dictionaryToPost
{
    NSString* serverUrl = [NSString stringWithFormat:@""];
    
    RDWeb* webPost = [[RDWeb alloc] init];
    webPost.requestURL = [NSURL URLWithString:serverUrl];
    
    [webPost postToServerWithUserDictionary:dictionaryToPost completionHandler:^(BOOL success, NSMutableDictionary *JSONresult, NSError* error){

        if (success) {
            // Successful
        } else {
            // Not Successful
        }
        
        
        
    }];
}

@end