//
//  ExerciseExecutionViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/29/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResearchKit/ResearchKit/Charts/ORKLineGraphChartView.h"
@interface ExerciseExecutionViewController : UIViewController

@property NSDictionary * exerciseInformation;
@property (nonatomic, strong) NSArray * dataPoints;

@end
