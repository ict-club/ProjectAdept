//
//  addFoodViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "AddFoodViewController.h"

@implementation AddFoodViewController

- (void) viewDidLoad
{
    self.buttonAddFood.layer.cornerRadius = 6.5;
    self.buttonAddFood.layer.masksToBounds = YES;
    self.buttonAddFood.layer.borderWidth = 0.1;
    self.tableViewDataFromFood.layer.cornerRadius = 6.5;
    self.tableViewDataFromFood.layer.masksToBounds = YES;
    self.tableViewDataFromFood.layer.borderWidth = 1.0;
}

- (void) viewDidAppear:(BOOL)animated
{
    
}

- (void) didReceiveMemoryWarning
{
    
}


@end
