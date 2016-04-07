//
//  HomeViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/28/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthKitObject = [HealthKitIntegration sharedInstance];
    
    
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(healthKitNotAvailableNotificationHandler:)
                               name:@"HealthKitNotAvailable"
                             object:nil];
    
    
    [self.healthKitObject initialize];
    [self.healthKitObject updateBMIinHealthKit];
    
}

- (void) viewDidAppear:(BOOL)animated
{
     NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(redrawLeftCircle:)
                               name:BMI_UPDATED
                             object:self.healthKitObject];
    
    [notificationCenter addObserver:self
                           selector:@selector(redrawRightCircle:)
                               name:CALORIE_BALANCE_UPDATED
                             object:self.healthKitObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) healthKitNotAvailableNotificationHandler: (NSNotification *) notification
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                    message:@"Cannot get information from health kit application. Go to health app and enable services"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action){}]];
    
}

-(void) redrawCircles: (NSNotification *) notification
{
    [self redrawCircles];
}

- (void) redrawCircles
{
    [self redrawLeftCircle:nil];
}

- (void) redrawLeftCircle:(NSNotification *) notification
{
    double currentBMI = self.healthKitObject.BMI;
    self.leftCircleView.textString = [NSString stringWithFormat:@"BMI: %0.2f", currentBMI];
    double leftRed = 51.0f/255.0f;
    double leftGreen = 204.0f/255.0f;
    double leftBlue = 204.0f/255.0f;
    
    if(currentBMI < 18.5 || currentBMI > 25)
    {
        leftGreen = 51.0f/255.0f;
        leftBlue = 204.0f/255.0f;
        if(currentBMI < 18.5)
        {
            leftRed = 128.0f + fabs(currentBMI - 18.5f)*50.0f;
        }
        else
        {
            leftRed = 128.f + fabs(currentBMI - 25.0f) * 25.0f;
        }
        if(leftRed > 255.0f) leftRed = 255.0f;
        leftRed /= 255.0f;
        
    }
    
    self.leftCircleView.strokeColor = [UIColor colorWithRed:leftRed green:leftGreen blue:leftBlue alpha:1];
    [self.leftCircleView setNeedsDisplay];
}

- (void) redrawCenterCircle: (NSNotification *) notification
{
    
}

- (void) redrawRightCircle: (NSNotification *) notification
{
    double netEnergy = self.healthKitObject.netEnergy/1000;
    self.rightCircleView.textString = [NSString stringWithFormat:@"%0.2f kJ", netEnergy];
    double leftRed = 51.0f/255.0f;
    double leftGreen = 204.0f/255.0f;
    double leftBlue = 204.0f/255.0f;
    
    if(netEnergy < -500 || netEnergy > 500)
    {
        leftGreen = 51.0f/255.0f;
        leftBlue = 204.0f/255.0f;
        
        leftRed = 128.0f + (fabs(netEnergy) - 500.0f)/10.0f;
        
        if(leftRed > 255.0f) leftRed = 255.0f;
        leftRed /= 255.0f;
    }
    
    self.rightCircleView.strokeColor = [UIColor colorWithRed:leftRed green:leftGreen blue:leftBlue alpha:1];
    [self.rightCircleView setNeedsDisplay];
}


@end
