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
    self.pointsArray = [NSMutableArray arrayWithObject:[NSNumber numberWithDouble:0]];
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
    
    
    double Red = 255.0f/255.0f;
    double Green = 51.0f/255.0f;
    double Blue = 204.0f/255.0f;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    NSInteger numberOfPoints = self.frame.size.width;
    int amplitude = (self.frame.size.height*0.9)/2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:Red green:Green blue:Blue alpha:1].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 3.0f);
    
    CGContextMoveToPoint(context, 0.0f, amplitude); //start at this point
    
    double scaleFactor = (double)numberOfPoints / (double)[self.pointsArray count];
    double xPoint = 0.0f;
    
    for(int i = 0; i < [self.pointsArray count]; i+=1)
    {
        if(i == 0)
        {
            CGContextMoveToPoint(context, 0.0f, 0.0f);
        }
        else
        {
            CGContextAddLineToPoint(context, xPoint += scaleFactor, ([[self.pointsArray objectAtIndex:i] doubleValue]/1023.0) * self.frame.size.height); //draw to this point
        }
    }
    
    // and now draw the Path!
    CGContextStrokePath(context);
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 15.0f;
    self.layer.masksToBounds = YES;
}


@end
