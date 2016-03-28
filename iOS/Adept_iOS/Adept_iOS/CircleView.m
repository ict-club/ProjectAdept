//
//  CircleView.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/28/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (void)drawCanvas2WithInsideTest: (NSString*)insideTest
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* gradientColor = [UIColor colorWithRed: 0.213 green: 0.756 blue: 0.923 alpha: 1];
    
    //// Image Declarations
    UIImage* insideImage = [UIImage imageNamed: @"insideImage.png"];
    
    //// DataCirle Drawing
    CGRect dataCirleRect = CGRectMake(75, 45, 200, 200);
    UIBezierPath* dataCirlePath = [UIBezierPath bezierPathWithOvalInRect: dataCirleRect];
    CGContextSaveGState(context);
    [dataCirlePath addClip];
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawTiledImage(context, CGRectMake(75, -45, insideImage.size.width, insideImage.size.height), insideImage.CGImage);
    CGContextRestoreGState(context);
    [gradientColor setStroke];
    dataCirlePath.lineWidth = 6.5;
    [dataCirlePath stroke];
    NSMutableParagraphStyle* dataCirleStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    dataCirleStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* dataCirleFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 12], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: dataCirleStyle};
    
    CGFloat dataCirleTextHeight = [insideTest boundingRectWithSize: CGSizeMake(dataCirleRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: dataCirleFontAttributes context: nil].size.height;
    CGContextSaveGState(context);
    CGContextClipToRect(context, dataCirleRect);
    [insideTest drawInRect: CGRectMake(CGRectGetMinX(dataCirleRect), CGRectGetMinY(dataCirleRect) + (CGRectGetHeight(dataCirleRect) - dataCirleTextHeight) / 2, CGRectGetWidth(dataCirleRect), dataCirleTextHeight) withAttributes: dataCirleFontAttributes];
    CGContextRestoreGState(context);
}

@end
