//
//  addFoodViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "AddFoodViewController.h"
#import <AVFoundation/AVFoundation.h>

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
    
    self.titles = [NSArray arrayWithObjects:@"Type Food:", @"Calories:", @"Fat:", @"Carbs:", @"Protein:", nil];
    self.selectedArray = [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil];
    self.food1 = [NSArray arrayWithObjects:@"Вафла", @"100", @"10", @"0", @"100", nil];
    self.food2 = [NSArray arrayWithObjects:@"Вафла", @"200", @"20", @"1", @"200", nil];
    self.food3 = [NSArray arrayWithObjects:@"Вафла", @"300", @"30", @"2", @"300", nil];
    self.food4 = [NSArray arrayWithObjects:@"Вафла", @"400", @"40", @"3", @"400", nil];
    self.food5 = [NSArray arrayWithObjects:@"Вафла", @"500", @"50", @"4", @"500", nil];
    
    
    self.buttonAddFood.layer.cornerRadius = 6.5;
    self.buttonAddFood.layer.masksToBounds = YES;
    self.buttonAddFood.layer.borderWidth = 0.1;
    self.tableViewDataFromFood.layer.cornerRadius = 6.5;
    self.tableViewDataFromFood.layer.masksToBounds = YES;
    self.tableViewDataFromFood.layer.borderWidth = 1.0;
    
    
    
    _highlightView = [[UIView alloc] init];
    _highlightView.frame = CGRectMake(0, 0, self.tableViewDataFromFood.frame.size.width, self.tableViewDataFromFood.frame.size.height);
    _highlightView.layer.borderColor = [UIColor blackColor].CGColor;
    _highlightView.layer.cornerRadius = 6.5;
    _highlightView.layer.masksToBounds = YES;
    _highlightView.layer.borderWidth = 1.0;
    [self.tableViewDataFromFood addSubview:_highlightView];
    
//    _label = [[UILabel alloc] init];
//    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
//    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
//    _label.textColor = [UIColor whiteColor];
//    _label.textAlignment = NSTextAlignmentCenter;
//    _label.text = @"(none)";
//    [self.view addSubview:_label];
    
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
    _prevLayer.frame = CGRectMake(0, 0, self.tableViewDataFromFood.frame.size.width, self.tableViewDataFromFood.frame.size.height);
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _prevLayer.cornerRadius = 6.5;
    _prevLayer.masksToBounds = YES;
    _prevLayer.borderWidth = 1.0;
    [self.tableViewDataFromFood.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
}
- (IBAction)buttonAddFood:(id)sender {
    self.barCodeString = @"no code scanned";
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
                
            }
            //            _label.text = detectionString;
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
