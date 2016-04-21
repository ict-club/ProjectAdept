//
//  UserDataCaloriesSingleton.m
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "UserDataCaloriesSingleton.h"

@implementation UserDataCaloriesSingleton

+(UserDataCaloriesSingleton*) theSingleton {
    static UserDataCaloriesSingleton* theSingleton = nil;
    if (!theSingleton) {
        theSingleton = [[super allocWithZone:nil]init];
    }
    return theSingleton;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    
    return [self theSingleton];
}

-(id)init{
    self = [super init];
    if (self) {
        //User date properties:
        _userId = 1;
        _Id = 1;
        _caloriesToBeBurned = 10;
        _CaloriesBalance = 10;
        _timeStamp = [NSDate dateWithTimeIntervalSinceNow:0];
    }
    return self;
}

@end
