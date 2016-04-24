//
//  ExerciseAndFoodLog.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/24/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseAndFoodLog : NSObject
@property (nonatomic, strong) NSMutableArray * logArray;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * dateArray;

+ (id)sharedInstance;

@end
