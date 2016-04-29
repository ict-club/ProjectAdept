//
//  GraphicsTableViewCell.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/22/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "GraphicsTableViewCell.h"
#import "ResearchKit/ResearchKit/Charts/ORKRangedPoint.h"

@implementation GraphicsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.pointsArray = [[NSMutableArray alloc] init];
    [self.pointsArray addObject:[NSNumber numberWithInteger:arc4random()%50]];
    [self.pointsArray addObject:[NSNumber numberWithInteger:arc4random()%50]];
    [self.pointsArray addObject:[NSNumber numberWithInteger:arc4random()%50]];
    [self.pointsArray addObject:[NSNumber numberWithInteger:arc4random()%50]];
    [self.pointsArray addObject:[NSNumber numberWithInteger:arc4random()%50]];
    [self.pointsArray addObject:[NSNumber numberWithInteger:arc4random()%50]];
    [self.pointsArray addObject:[NSNumber numberWithInteger:arc4random()%50]];
}


- (void)layoutSubviews
{
    
    self.graphView.dataSource = self;
}


- (NSInteger) numberOfPlotsInGraphChartView:(ORKGraphChartView *)graphChartView
{
    return 1;
}

- (NSInteger) graphChartView:(ORKGraphChartView *)graphChartView numberOfPointsForPlotIndex:(NSInteger)plotIndex
{
    return [self.pointsArray count];
}

- (UIColor *)graphChartView:(ORKGraphChartView *)graphChartView colorForPlotIndex:(NSInteger)plotIndex
{
    double leftRed = 51.0f/255.0f;
    double leftGreen = 204.0f/255.0f;
    double leftBlue = 204.0f/255.0f;
    return [UIColor colorWithRed:leftRed green:leftGreen blue:leftBlue alpha:1.0f];
}

- (NSString *) graphChartView:(ORKGraphChartView *)graphChartView titleForXAxisAtPointIndex:(NSInteger)pointIndex
{
#warning implement timestaps
    switch (pointIndex) {
        case 0:
            return @"Mon";
            break;
        case 1:
            return @"Tue";
            break;
        case 2:
            return @"Wed";
            break;
        case 3:
            return @"Thur";
            break;
        case 4:
            return @"Fr";
            break;
        case 5:
            return @"Sat";
            break;
        case 6:
            return @"Sun";
            break;
        default:
            return @"Mon";
            break;
    }
}
- (ORKRangedPoint *)graphChartView:(ORKGraphChartView *)graphChartView pointForPointIndex:(NSInteger)pointIndex plotIndex:(NSInteger)plotIndex
{
    ORKRangedPoint * rangedPoint = [[ORKRangedPoint alloc] initWithValue:[[self.pointsArray objectAtIndex:pointIndex] integerValue]];
    
    return rangedPoint;
}
@end
