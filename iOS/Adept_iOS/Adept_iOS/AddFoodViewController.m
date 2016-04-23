//
//  addFoodViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "AddFoodViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HealthKitIntegration.h"

@interface AddFoodViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
}
@end

@implementation AddFoodViewController

- (void) viewDidLoad
{
    self.barCodeString = [NSString stringWithFormat:@""];
    
#warning add valid data for foods
    self.titles = [NSMutableArray arrayWithObjects:@"Type Food:", @"Calories:", @"Fat:", @"Carbs:", @"Protein:", @"Food Quality:", nil];
    self.selectedArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", nil];
    self.food1 = [NSMutableArray arrayWithObjects:@"Вафла", @"100", @"10", @"0", @"100", @"Junk", nil];
    self.food2 = [NSMutableArray arrayWithObjects:@"Кифла", @"200", @"20", @"1", @"200", @"Healthy", nil];
    self.food3 = [NSMutableArray arrayWithObjects:@"Салам", @"300", @"30", @"2", @"300", @"Healthy", nil];
    self.food4 = [NSMutableArray arrayWithObjects:@"Банан", @"400", @"40", @"3", @"400", @"Junk", nil];
    self.food5 = [NSMutableArray arrayWithObjects:@"Наденичка", @"500", @"50", @"4", @"500", @"Junk", nil];
    
    self.foodForBarCode = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           self.food1, @"42268222",
                           self.food2, @"0022000015532",
                           self.food3, @"3800000600029",
                           self.food4, @"3800214422493", nil];
    
    self.buttonAddFood.layer.cornerRadius = 6.5;
    self.buttonAddFood.layer.masksToBounds = YES;
    self.buttonAddFood.layer.borderWidth = 0.1;
    self.previewView.layer.cornerRadius = 6.5;
    self.previewView.layer.masksToBounds = YES;
    self.previewView.layer.borderWidth = 1.0;
    
    
    
    _highlightView = [[UIView alloc] init];
    _highlightView.frame = CGRectMake(0, 0, self.previewView.frame.size.width, self.previewView.frame.size.height);
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.cornerRadius = 6.5;
    _highlightView.layer.masksToBounds = YES;
    _highlightView.layer.borderWidth = 1.0;
    [self.previewView addSubview:_highlightView];
    
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = CGRectMake(0, 0, self.previewView.frame.size.width, self.previewView.frame.size.height);
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _prevLayer.cornerRadius = 6.5;
    _prevLayer.masksToBounds = YES;
    _prevLayer.borderWidth = 1.0;
    [self.previewView.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
}




#pragma mark - Button pressed handler
- (IBAction)buttonAddFood:(id)sender {
#warning must add to data base
    self.barCodeString = @"no code scanned";
    if([[self.selectedArray objectAtIndex:0] length] > 0)
    {
        double intakeCalories = [[self.selectedArray objectAtIndex:1] doubleValue];
        [[HealthKitIntegration sharedInstance] writeIntakeCaloriesToHealthKit: intakeCalories];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Food added to log" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
                                               
    }
}








- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString)
        {
            if (![detectionString isEqualToString:self.barCodeString]) {
                NSLog(@"%@", detectionString);
                self.barCodeString = detectionString;
                NSString* key = [NSString stringWithFormat:@"%@", detectionString];
                self.selectedArray = [self.foodForBarCode mutableArrayValueForKey:key];
                
                if ([self.selectedArray count] > 0) {
                    [self.tableView reloadData];
                } else {
                    self.barCodeString = @"wrong barcode";
                }
                
                
            }
            break;
        }
    }
    
    _highlightView.frame = highlightViewRect;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) didReceiveMemoryWarning
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddFoodTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    

    // Configure the cell...
        
    cell.textLabel.text = [self.titles objectAtIndex:[indexPath row]];
    cell.detailTextLabel.text = [self.selectedArray objectAtIndex:[indexPath row]];
    
    
    return cell;
}
@end
