//
//  AdeptDataBaseInteractions.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/24/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "AdeptDataBaseInteractions.h"

@implementation AdeptDataBaseInteractions

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        // TODO: init timer to refresh the information
    }
    return self;
}



@end
