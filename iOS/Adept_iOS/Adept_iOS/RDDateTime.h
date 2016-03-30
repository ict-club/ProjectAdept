//
//  RDDateTime.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/31/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDDateTime : NSObject

+ (NSDate *) beginingOfToday;
+ (NSDate *) endOfToday;
+ (NSDate *) beginingOfDayBeforeNumberOfDays: (NSInteger) numberOfDays;
+ (NSDate *) endOfDayBeforeNumberOfDays: (NSInteger) numberOfDays;

+ (NSDate *) beginingOfTheWeek;
+ (NSDate *) endOfTheWeek;
+ (NSDate *) beginingOfWeekBeforeNumberOfWeeks: (NSInteger) numberOfWeeks;
+ (NSDate *) endOfWeekBeforeNumberOfWeeks: (NSInteger) numberOfWeeks;

+ (NSDate *) beginingOfMonth;
+ (NSDate *) endOfMonth;
+ (NSDate *) beginingOfMonthBeforeNumberOfMonths: (NSInteger) numberOfMonths;
+ (NSDate *) endOfMonthBeforeNumberOfMonths: (NSInteger) numberOfMonths;

+ (NSDate *) beginingOfMonthNumber: (NSInteger) numberOfMonth;
+ (NSDate *) endOfMonthNumber: (NSInteger) numberOfMonth;

+ (NSDate *) beginingOfJanuary;
+ (NSDate *) endOfJanuary;
+ (NSDate *) beginingOfFebuary;
+ (NSDate *) endOfFebuary;
+ (NSDate *) beginingOfMarch;
+ (NSDate *) endOfMarch;
+ (NSDate *) beginingOfApril;
+ (NSDate *) endOfApril;
+ (NSDate *) beginingOfMay;
+ (NSDate *) endOfMay;
+ (NSDate *) beginingOfJune;
+ (NSDate *) endOfJune;
+ (NSDate *) beginingOfJuly;
+ (NSDate *) endOfJuly;
+ (NSDate *) beginingOfAugust;
+ (NSDate *) endOfAugust;
+ (NSDate *) beginingOfSeptember;
+ (NSDate *) endOfSeptember;
+ (NSDate *) beginingOfOctober;
+ (NSDate *) endOfOctober;
+ (NSDate *) beginingOfNovember;
+ (NSDate *) endOfNovember;
+ (NSDate *) beginingOfDecember;
+ (NSDate *) endOfDecember;

+ (NSDate *) dateForYear: (NSInteger) year andMonth: (NSInteger) month andDay: (NSInteger) day isEndOfDay: (bool) endOfDay;
@end
