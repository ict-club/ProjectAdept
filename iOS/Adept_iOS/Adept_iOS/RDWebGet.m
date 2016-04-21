//
//  RDWebGet.m
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "RDWebGet.h"
#import "RDWeb.h"

@interface RDWebGet ()
@property NSInteger Id;
//User Data
@property NSInteger userId;
@property NSInteger caloriesToBeBurned;
@property NSInteger caloriesBalance;
@property NSString* timeStamp;
//User Data Calories
@property NSString* name;
@property NSInteger age;
@property NSString* title;
@property NSInteger overallCondition;
@property float recommendedCalories;
@property NSString* picture_small;
@property NSString* picture_big;
@end

@implementation RDWebGet

// if we are getting from user data isUserData = YES; if we are getting from user data calories isUserData = NO
-(void)getFromServerWithUserId:(NSInteger)userId AndIsUserData:(BOOL)isUserData
{
    NSMutableDictionary *dictionaryToPost = [NSMutableDictionary
                                             dictionaryWithDictionary:@{  @"UserId" : [NSNumber numberWithUnsignedInteger:userId]  }];
    
    NSString* serverUrl = [NSString stringWithFormat:@""];
    
    RDWeb* webPost = [[RDWeb alloc] init];
    webPost.requestURL = [NSURL URLWithString:serverUrl];
    
    [webPost postToServerWithUserDictionary:dictionaryToPost completionHandler:^(BOOL success, NSMutableDictionary *JSONresult, NSError* error){
        
        if (success) {
            if (isUserData == YES) {
                self.Id = [[JSONresult valueForKey:@"id"] integerValue];
                self.name = [JSONresult objectForKey:@"Name"];
                self.age = [[JSONresult valueForKey:@"Age"] integerValue];
                self.title = [JSONresult objectForKey:@"Title"];
                self.overallCondition = [[JSONresult valueForKey:@"OverallCondition"] integerValue];
                self.recommendedCalories = [[JSONresult valueForKey:@"RecommendedCalories"] floatValue];
                self.picture_small = [JSONresult objectForKey:@"picture_small"];
                self.picture_big = [JSONresult objectForKey:@"picture_big"];
                
                
            } else {
                self.Id = [[JSONresult valueForKey:@"id"] integerValue];
                self.userId = [[JSONresult valueForKey:@"UserId"] integerValue];
                self.caloriesToBeBurned = [[JSONresult valueForKey:@"CaloriesToBeBurned"] integerValue];
                self.caloriesBalance = [[JSONresult valueForKey:@"CaloriesBalance"] integerValue];
                self.timeStamp = [JSONresult objectForKey:@"Timestamp"];
                
                
            }
            
        } else {
            // Not Successful
        }
        
        
        
    }];
    
    
    
    
    
}






@end
