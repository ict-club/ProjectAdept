//
//  HeartRateExerciseViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/16/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "HeartRateExerciseViewController.h"

@implementation HeartRateExerciseViewController

- (void) viewDidLoad
{
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
}

- (void) didReceiveMemoryWarning
{
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"HRCell"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


@end
