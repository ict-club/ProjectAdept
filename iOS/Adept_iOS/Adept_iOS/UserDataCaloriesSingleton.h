//
//  UserDataCaloriesSingleton.h
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataCaloriesSingleton : NSObject

@property NSInteger userId;
@property NSInteger Id;
@property NSInteger caloriesToBeBurned;
@property NSInteger CaloriesBalance;
@property NSDate* timeStamp;

+(UserDataCaloriesSingleton*) theSingleton;

@end
