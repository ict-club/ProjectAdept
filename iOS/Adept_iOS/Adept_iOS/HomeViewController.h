//
//  HomeViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/28/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"

@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet CircleView *mainCircleView;
@property (weak, nonatomic) IBOutlet CircleView *leftCircleView;
@property (weak, nonatomic) IBOutlet CircleView *centerCircleView;
@property (weak, nonatomic) IBOutlet CircleView *rightCircleView;

@end
