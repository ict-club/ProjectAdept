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
#import "ExerciseAndFoodLog.h"

NS_ENUM(NSInteger, STATE_ENUM)
{
    EX_STATE_WAITING_TO_START,
    EX_STATE_ONGOING,
    EX_STATE_FINISHED
};

@interface ExerciseExecutionViewController ()
{
    NSInteger exerciseIndex;
    CGFloat difficulty;
    HealthKitIntegration * healthKit;
    NSInteger currentState;
    NSInteger repetitions;
}
@property NSMutableDictionary * exerciseInformation;
@property (nonatomic, strong) NSArray * dataPoints;
@property (nonatomic, strong) RDBluetoothLowEnergy * bleCommunication;
@property (strong, nonatomic) BluetoothDeviceList * bluetoothDeviceList;
@property (strong, nonatomic) HealthKitIntegration * heathKit;
@property (strong, nonatomic) CBCharacteristic * isometricCaracteristic;
@property (assign, nonatomic) NSInteger currentIsometricData;
@property (assign, nonatomic) NSInteger trainingTime;
@property (assign, nonatomic) CGFloat burnedCalories;
@property (assign, nonatomic) NSInteger heartRateZoneMin;
@property (assign, nonatomic) NSInteger heartRateZoneMax;

@property (strong, nonatomic) CBCharacteristic * isometricCharacteristic;
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
    currentState = EX_STATE_WAITING_TO_START;
    exerciseIndex = 0;
    repetitions = 0;
    
    [self subscribeToIsometricCharacteristic];
}

- (void) viewDidAppear:(BOOL)animated
{
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [healthKit writeActiveEnergyBurnedToHealthKit:self.burnedCalories];
}


- (void) subscribeToIsometricCharacteristic
{
    CBPeripheral * TrainingPeripheral;
    
    if([(CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:2] device] state] == CBPeripheralStateConnected)
    {
        TrainingPeripheral = (CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:2] device];
    }
    else if([(CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:3] device] state] == CBPeripheralStateConnected)
    {
        TrainingPeripheral = (CBPeripheral *)[[self.bluetoothDeviceList objectAtIndex:3] device];
    }
    else if([(CBPeripheral *) [[self.bluetoothDeviceList objectAtIndex:0] device] state] == CBPeripheralStateConnected)
    {
        TrainingPeripheral = (CBPeripheral *) [[self.bluetoothDeviceList objectAtIndex:0]  device];
    }
    else
    {
        return;
    }
    for(NSInteger i = [[TrainingPeripheral services] count] - 1; i >= 0; i--)
    {
        CBService * aService = [[TrainingPeripheral services] objectAtIndex:i];
        for(CBMutableCharacteristic * aCharacteristic in aService.characteristics)
        {
            if([aCharacteristic.UUID  isEqual: [CBUUID UUIDWithString:@"5A01"]] == YES)
            {
                [TrainingPeripheral setNotifyValue:YES forCharacteristic:aCharacteristic];
                self.isometricCaracteristic = aCharacteristic;
                break;
            }
            else if([aCharacteristic.UUID isEqual:[CBUUID UUIDWithString:@"0000ffe1-0000-1000-8000-00805f9b34fb"]])
            {
                [TrainingPeripheral setNotifyValue:YES forCharacteristic:aCharacteristic];
                self.isometricCaracteristic = aCharacteristic;
                break;
            }
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    if(self.burnedCalories > 0)
    {
        [healthKit writeActiveEnergyBurnedToHealthKit:self.burnedCalories];
        
        [[[ExerciseAndFoodLog sharedInstance] logArray] insertObject:@"Exercise" atIndex:[[[ExerciseAndFoodLog sharedInstance] logArray] count]];
        [[[ExerciseAndFoodLog sharedInstance] dataArray] insertObject:[NSString stringWithFormat:@"-%0.2f", self.burnedCalories] atIndex:[[[ExerciseAndFoodLog sharedInstance] dataArray] count]];
        [[[ExerciseAndFoodLog sharedInstance] dateArray] insertObject:[NSDate date] atIndex:[[[ExerciseAndFoodLog sharedInstance] dateArray] count]];
        
        
    }
    
        
}

- (void) viewDidDisappear:(BOOL)animated
{
    self.bleCommunication.delegate = nil;
}

- (void) refreshTrainingData
{
    NSInteger exerciseSeconds = exerciseIndex/10 + repetitions * (self.exerciseDynamicGraphic.numberOfPoints / 10);
    
    if(currentState == EX_STATE_ONGOING)
    {
        self.exerciseTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld s", exerciseSeconds/60, exerciseSeconds%60];
    }
    else if(currentState == EX_STATE_WAITING_TO_START)
    {
        self.exerciseTimeLabel.text = @"Ready to start";
    }
    else if(currentState == EX_STATE_FINISHED)
    {
        self.exerciseTimeLabel.text = @"Release";
    }
    
    if(self.currentIsometricData > 0)
    {
        self.burnedCalories += [healthKit getCaloriesForIsometricsForce:self.currentIsometricData andTime:0.1];
    }
    self.burnedCaloriesLabel.text = [NSString stringWithFormat:@"%0.1f Cal", self.burnedCalories];
    
    self.currentForceLabel.text = [NSString stringWithFormat:@"%ld N",self.currentIsometricData];
}

- (void) checkState
{
    if(exerciseIndex >= self.exerciseDynamicGraphic.numberOfPoints && currentState == EX_STATE_ONGOING)
    {
        currentState = EX_STATE_FINISHED;
    }
    else if(currentState == EX_STATE_FINISHED && self.currentIsometricData == 0)
    {
        currentState = EX_STATE_WAITING_TO_START;
        repetitions += 1;
        exerciseIndex = 0;
        self.exerciseDynamicGraphic.pointsArray = [[NSMutableArray alloc] init];
    }
    else if(currentState == EX_STATE_WAITING_TO_START && self.currentIsometricData > 0)
    {
        currentState = EX_STATE_ONGOING;
    }
}

- (void) didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic ofDevice:(CBPeripheral *)peripheral andData:(NSData *)data
{
    if([peripheral.name isEqualToString:@"TAO-AA-0246"] == YES || [peripheral.name isEqualToString: @"TAO-AA-0375"] == YES || [peripheral.name isEqualToString:@"BT05"] == YES)
    {
        NSString * isometricData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", isometricData);
        
        self.currentIsometricData = [isometricData integerValue];
        NSInteger graphicIsometricDataToSend = self.currentIsometricData*100/difficulty;
        [self checkState];
        [self refreshTrainingData];
        if(exerciseIndex < self.exerciseDynamicGraphic.numberOfPoints && graphicIsometricDataToSend > 0)
        {
            [self.exerciseDynamicGraphic.pointsArray addObject:[NSNumber numberWithInteger:graphicIsometricDataToSend]];
            [self.exerciseDynamicGraphic setNeedsDisplay];
            exerciseIndex ++ ;
        }
    }
}
- (void) didWriteValueForCharacteristic: (RDBluetoothLowEnergy *) bluetoothLowEnergy
{
    
}

- (void) didDisconnectDevice:(CBPeripheral *)device
{
    if([device.name isEqualToString: @"ТАО-АА-0246"] == YES || [device.name isEqualToString: @"ТАО-АА-0375"] == YES)
    {
        [self.bleCommunication connectToDevice:device];
    }
}

- (void) didConnectDevice:(CBPeripheral *)device
{
    if([device.name isEqualToString: @"ТАО-АА-0246"] == YES || [device.name isEqualToString: @"ТАО-АА-0375"] == YES)
    {
        [device discoverServices:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void)
                       {
                           [self subscribeToIsometricCharacteristic];
                       });
    }
}




@end
