//
//  RDDateTime.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/31/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "RDDateTime.h"

@implementation RDDateTime

+ (NSDate *) dateForYear: (NSInteger) year andMonth: (NSInteger) month andDay: (NSInteger) day isEndOfDay: (bool) endOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    
    comps.day = day;
    comps.month = month;
    comps.year = year;
    
    if(endOfDay == YES)
    {
        comps.hour = 23;
        comps.minute = 59;
        comps.second = 59;
        comps.nanosecond = 99999999;
    }
    else
    {
        comps.hour = 0;
        comps.minute = 0;
        comps.second = 0;
        comps.nanosecond = 0;
    }
    return [calendar dateFromComponents:comps];
}

+ (NSDate *) beginingOfToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    return [calendar dateFromComponents:comps];
}


+ (NSDate *) endOfToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    
    comps.hour = 23;
    comps.minute = 59;
    comps.second = 59;
    comps.nanosecond = 99999999;
    
    return [calendar dateFromComponents:comps];
}


+ (NSDate *) beginingOfDayBeforeNumberOfDays: (NSInteger) numberOfDays;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    
    comps.day -= numberOfDays;
    return [calendar dateFromComponents:comps];
}

+ (NSDate *) endOfDayBeforeNumberOfDays: (NSInteger) numberOfDays
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    
    comps.day -= numberOfDays;
    comps.hour = 23;
    comps.minute = 59;
    comps.second = 59;
    comps.nanosecond = 999999999;
    return [calendar dateFromComponents:comps];

}

+ (NSDate *) beginingOfTheWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    
    comps.weekday = 1;
    return [calendar dateFromComponents:comps];
}

+ (NSDate *) endOfTheWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    
    comps.weekday = 7;
    comps.hour = 23;
    comps.minute = 59;
    comps.second = 59;
    comps.nanosecond = 999999999;
    return [calendar dateFromComponents:comps];
}
+ (NSDate *) beginingOfWeekBeforeNumberOfWeeks: (NSInteger) numberOfWeeks
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    
    comps.weekOfYear -= numberOfWeeks;
    comps.weekday = 1;
    return [calendar dateFromComponents:comps];
}
+ (NSDate *) endOfWeekBeforeNumberOfWeeks: (NSInteger) numberOfWeeks
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                fromDate:[NSDate date]];
    
    comps.weekOfYear -= numberOfWeeks;
    comps.weekday = 7;
    comps.hour = 23;
    comps.minute = 59;
    comps.second = 59;
    comps.nanosecond = 999999999;
    return [calendar dateFromComponents:comps];

}

+ (NSDate *) beginingOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth
                fromDate:[NSDate date]];
    return [calendar dateFromComponents:comps];

}

+ (NSDate *) endOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth
                fromDate:[NSDate date]];
    comps.month += 1;
    NSDate * dateToReturn = [NSDate dateWithTimeInterval:-1 sinceDate:[calendar dateFromComponents:comps]];
    return dateToReturn;
}

+ (NSDate *) beginingOfMonthBeforeNumberOfMonths: (NSInteger) numberOfMonths
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth
                fromDate:[NSDate date]];
    comps.month -= numberOfMonths;
    return [calendar dateFromComponents:comps];

}
+ (NSDate *) endOfMonthBeforeNumberOfMonths: (NSInteger) numberOfMonths
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth
                fromDate:[NSDate date]];
    comps.month -= (numberOfMonths + 1);
    NSDate * dateToReturn = [NSDate dateWithTimeInterval:-1 sinceDate:[calendar dateFromComponents:comps]];
    return dateToReturn;
}

+ (NSDate *) beginingOfMonthNumber: (NSInteger) numberOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear
                fromDate:[NSDate date]];
    comps.month = numberOfMonth;
    return [calendar dateFromComponents:comps];
}
+ (NSDate *) endOfMonthNumber: (NSInteger) numberOfMonth;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps =
    [calendar components:NSCalendarUnitYear
                fromDate:[NSDate date]];
    if(numberOfMonth == 12)
    {
        comps.month = 12;
        comps.day = 31;
        comps.hour = 23;
        comps.minute = 59;
        comps.nanosecond = 999999999;
        return [calendar dateFromComponents:comps];
    }
    else
    {
        comps.month += 1;
        NSDate * dateToReturn = [NSDate dateWithTimeInterval:-1 sinceDate:[calendar dateFromComponents:comps]];
        return dateToReturn;
    }
}

+ (NSDate *) beginingOfJanuary;
{
    return [self beginingOfMonthNumber:1];
}
+ (NSDate *) endOfJanuary
{
    return [self endOfMonthNumber:1];
}
+ (NSDate *) beginingOfFebuary
{
    return [self beginingOfMonthNumber:2];
}
+ (NSDate *) endOfFebuary
{
    return [self endOfMonthNumber:2];
}
+ (NSDate *) beginingOfMarch
{
    return [self beginingOfMonthNumber:3];
}
+ (NSDate *) endOfMarch
{
    return [self endOfMonthNumber:3];
}
+ (NSDate *) beginingOfApril
{
    return [self beginingOfMonthNumber:4];
}
+ (NSDate *) endOfApril
{
    return [self endOfMonthNumber:4];
}
+ (NSDate *) beginingOfMay
{
    return [self beginingOfMonthNumber:5];
}
+ (NSDate *) endOfMay
{
    return [self endOfMonthNumber:5];
}
+ (NSDate *) beginingOfJune
{
    return [self beginingOfMonthNumber:6];
}
+ (NSDate *) endOfJune
{
    return [self endOfMonthNumber:6];
}
+ (NSDate *) beginingOfJuly
{
    return [self beginingOfMonthNumber:7];
}
+ (NSDate *) endOfJuly
{
    return [self endOfMonthNumber:7];
}
+ (NSDate *) beginingOfAugust
{
    return [self beginingOfMonthNumber:8];
}
+ (NSDate *) endOfAugust
{
    return [self endOfMonthNumber:8];
}
+ (NSDate *) beginingOfSeptember
{
    return [self beginingOfMonthNumber:9];
}
+ (NSDate *) endOfSeptember
{
    return [self endOfMonthNumber:9];
}
+ (NSDate *) beginingOfOctober
{
    return [self beginingOfMonthNumber:10];
}
+ (NSDate *) endOfOctober
{
    return [self endOfMonthNumber:10];
}
+ (NSDate *) beginingOfNovember
{
    return [self beginingOfMonthNumber:11];
}
+ (NSDate *) endOfNovember
{
    return [self endOfMonthNumber:11];
}
+ (NSDate *) beginingOfDecember
{
    return [self beginingOfMonthNumber:12];
}
+ (NSDate *) endOfDecember
{
    return [self endOfMonthNumber:12];
}



@end
