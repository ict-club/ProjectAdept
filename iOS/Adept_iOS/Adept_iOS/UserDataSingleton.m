//
//  UserDataSingleton.m
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "UserDataSingleton.h"

@implementation UserDataSingleton

+(UserDataSingleton*) theSingleton {
    static UserDataSingleton* theSingleton = nil;
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
        _name = @"One";
        _age = 1;
        _title = @"Title";
        _overalCondition = 1;
        _recomendedCalories = 1.0;
        _pictureSmall = @"http://i.imgur.com/VcgfWmD.png";
        _pictureBig = @"http://i.imgur.com/VcgfWmD.png";
    }
    return self;
}

@end
