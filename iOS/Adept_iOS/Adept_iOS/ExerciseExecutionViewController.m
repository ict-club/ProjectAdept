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

@interface ExerciseExecutionViewController ()
@property (weak, nonatomic) IBOutlet ExerciseStaticLine *exerciseStaticGraphic;
@property (weak, nonatomic) IBOutlet ExerciseDynamicLine *exerciseDynamicGraphic;
@property (weak, nonatomic) IBOutlet UILabel *burnedCaloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartrateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *exerciseImage;

@end

@implementation ExerciseExecutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.exerciseImage.layer.borderColor = [UIColor blackColor].CGColor;
    self.exerciseImage.layer.borderWidth = 3.0f;
//    self.exerciseImage.layer.cornerRadius = 15;
//    self.exerciseImage.layer.masksToBounds = YES;
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

@end
