//
//  ExerciseDynamicLine.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/29/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "ExerciseDynamicLine.h"

@implementation ExerciseDynamicLine

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    NSInteger numberOfPoints = self.frame.size.width;
    double omega = (sqrt(6*M_PI))/numberOfPoints; // - sqrt(3*M_PI/2)
    int amplitude = (self.frame.size.height*0.9)/2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 3.0f);
    
    CGContextMoveToPoint(context, 0.0f, amplitude); //start at this point
    
    for(int i = 0; i < numberOfPoints; i+=4)
    {
        float x = (omega * (i - self.frame.size.width/2));
        if(i == 0)
        {
            CGContextMoveToPoint(context, 0.0f, self.frame.size.height/2 - amplitude * sin(x * x));
        }
        else
        {
            CGContextAddLineToPoint(context, i, arc4random()%20 + self.frame.size.height/2 - amplitude * sin(x * x)); //draw to this point
        }
    }
    
    // and now draw the Path!
    CGContextStrokePath(context);
}


@end
