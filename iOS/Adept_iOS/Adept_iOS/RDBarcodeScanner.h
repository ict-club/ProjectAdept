//
//  RDBarcodeScanner.h
//  Adept_iOS
//
//  Created by PETAR LAZAROV on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@import AVFoundation;

@interface RDBarcodeScanner : NSObject

+ (RDBarcodeScanner * )processMetadataObject:(AVMetadataMachineReadableCodeObject*) code;
- (NSString *) getBarcodeType;
- (NSString *) getBarcodeData;
- (void) printBarcodeData;
@end
