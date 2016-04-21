//
//  ExerciseExecutionViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/29/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "ExerciseExecutionViewController.h"
#import "ExerciseStaticLine.h"
#import "ExerciseDynamicLine.h"
#import "HealthKitIntegration.h"

@interface ExerciseExecutionViewController ()
{
    NSInteger exerciseIndex;
    CGFloat difficulty;
    HealthKitIntegration * healthKit;
}
@property (weak, nonatomic) IBOutlet ExerciseStaticLine *exerciseStaticGraphic;
@property (strong, nonatomic) IBOutlet ExerciseDynamicLine *exerciseDynamicGraphic;
@property (weak, nonatomic) IBOutlet UIImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet UILabel *burnedCaloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentForceLabel;

@end

@implementation ExerciseExecutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleCommunication = [RDBluetoothLowEnergy sharedInstance];
    self.bluetoothDeviceList = [BluetoothDeviceList sharedInstance];
    healthKit = [HealthKitIntegration sharedInstance];
    
    self.exerciseImage.layer.borderColor = [UIColor blackColor].CGColor;
    self.exerciseImage.layer.borderWidth = 1.0f;
    self.exerciseImage.layer.cornerRadius = 15;
    self.exerciseImage.layer.masksToBounds = YES;
    
    exerciseIndex = 0;
    
    self.exerciseDynamicGraphic.pointsArray = [[NSMutableArray alloc] init];
    self.exerciseDynamicGraphic.numberOfPoints = [[self.exerciseInformation objectForKey:@"Time"] integerValue] * 10;
    difficulty = [[self.exerciseInformation objectForKey:@"Hardness"] integerValue];
    
   
    [self.exerciseDynamicGraphic setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    self.bleCommunication.delegate = self;
    [self subscribeToIsometricCharacteristic];
}

- (void) viewDidAppear:(BOOL)animated
{
    //    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
    //                                                        target:self
    //                                                      selector:@selector(refreshTrainingData)
    //                                                      userInfo:nil
    //                                                       repeats:YES];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [healthKit writeActiveEnergyBurnedToHealthKit:self.burnedCalories];
}


- (void) subscribeToIsometricCharacteristic
{
    CBPeripheral * TAOPeripheral = (CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:2] device];
    
    for(NSInteger i = [[TAOPeripheral services] count] - 1; i >= 0; i--)
    {
        CBService * aService = [[TAOPeripheral services] objectAtIndex:i];
        for(CBCharacteristic * aCharacteristic in aService.characteristics)
        {
            if([[aCharacteristic.UUID UUIDString]  isEqual: @"5A01"] == YES)
            {
                [TAOPeripheral setNotifyValue:YES forCharacteristic:aCharacteristic];
                self.isometricCaracteristic = aCharacteristic;
                [TAOPeripheral readValueForCharacteristic:self.isometricCaracteristic];
                break;
            }
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [healthKit writeActiveEnergyBurnedToHealthKit:self.burnedCalories];
}

- (void) viewDidDisappear:(BOOL)animated
{
    self.bleCommunication.delegate = nil;
}

- (void) refreshTrainingData
{
    
    NSInteger exerciseSeconds = exerciseIndex/10;
    self.exerciseTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld s", exerciseSeconds/60, exerciseSeconds%60];
    
    if(self.currentIsometricData > 0) self.burnedCalories += [healthKit getCaloriesForIsometricsForce:self.currentIsometricData andTime:0.1];
    self.burnedCaloriesLabel.text = [NSString stringWithFormat:@"%0.1f Cal", self.burnedCalories];
    
    self.currentForceLabel.text = [NSString stringWithFormat:@"%ld N",self.currentIsometricData];
}


- (void) didUpdateValueForCharacteristic: (RDBluetoothLowEnergy *) bluetoothLowEnergy andData: (NSData *) data
{
    NSString * isometricData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", isometricData);
    
    self.currentIsometricData = [isometricData integerValue];
    NSInteger graphicIsometricDataToSend = self.currentIsometricData*100/difficulty;
    [self refreshTrainingData];
    if(exerciseIndex < self.exerciseDynamicGraphic.numberOfPoints && graphicIsometricDataToSend > 0)
    {
        [self.exerciseDynamicGraphic.pointsArray addObject:[NSNumber numberWithInteger:graphicIsometricDataToSend]];
        [self.exerciseDynamicGraphic setNeedsDisplay];
        exerciseIndex ++ ;
    }
}
- (void) didWriteValueForCharacteristic: (RDBluetoothLowEnergy *) bluetoothLowEnergy
{
    
}

- (void) didDisconnectDevice:(CBPeripheral *)device
{
    if([device.name isEqualToString: @"ТАО-АА-0051"] == YES)
    {
        [self.bleCommunication connectToDevice:device];
    }
}

- (void) didConnectDevice:(CBPeripheral *)device
{
    if([device.name isEqualToString: @"ТАО-АА-0051"] == YES)
    {
        [device discoverServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"5000"]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void)
                       {
                           [self subscribeToIsometricCharacteristic];
                       });
    }
}




@end
