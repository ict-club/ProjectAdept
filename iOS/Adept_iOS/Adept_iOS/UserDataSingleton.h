//
//  UserDataSingleton.h
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataSingleton : NSObject

@property NSInteger userId;
@property NSInteger Id;
@property NSString* name;
@property NSInteger age;
@property NSString* title;
@property NSInteger overalCondition;
@property float recomendedCalories;
@property NSString* pictureSmall;
@property NSString* pictureBig;

+(UserDataSingleton*) theSingleton;

@end
