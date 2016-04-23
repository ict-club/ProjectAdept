//
//  GraphicsTableViewCell.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/22/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResearchKit/ResearchKit/Charts/ORKLineGraphChartView.h"
@interface GraphicsTableViewCell : UITableViewCell <ORKGraphChartViewDataSource>

@property (weak, nonatomic) IBOutlet ORKLineGraphChartView *graphView;
@property (strong, nonatomic) NSMutableArray * pointsArray;
@property (weak, nonatomic) IBOutlet UILabel *graphicName;
@property (strong, nonatomic) NSString * graphName;
@end
