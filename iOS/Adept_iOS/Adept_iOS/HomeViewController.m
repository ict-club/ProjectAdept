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
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(healthKitNotAvailableNotificationHandler:)
                               name:@"HealthKitNotAvailable"
                             object:nil];
    self.healthKitObject = [HealthKitIntegration sharedInstance];
    [self.healthKitObject initialize];
    [self.healthKitObject updateData];
    [self.healthKitObject updateBMIinHealthKit];
    [self.healthKitObject updateBMIForToday];
    [self.healthKitObject updateBMIinHealthKit];
    
    [notificationCenter addObserver:self
                           selector:@selector(redrawCircles)
                               name:HEALTH_KIT_DATA_UPDATED
                             object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) redrawCircles
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
            leftRed = 1280.f + fabs(currentBMI - 25.0f) * 25.0f;
        }
        if(leftRed > 255.0f) leftRed = 255.0f;
        leftRed /= 255.0f;
        
    }
    
    self.leftCircleView.strokeColor = [UIColor colorWithRed:leftRed green:leftGreen blue:leftBlue alpha:1];
    [self.view setNeedsDisplay];
}
@end
