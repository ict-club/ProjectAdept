//
//  addFoodViewController.h
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 4/21/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFoodViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *buttonAddFood;
@property (weak, nonatomic) IBOutlet UIView *tableViewDataFromFood;
@property (weak, nonatomic) IBOutlet UILabel *tableViewCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *tableViewCellDetail;

@property (nonatomic, strong) NSString* barCodeString;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *selectedArray;
@property (nonatomic, strong) NSArray *food1;
@property (nonatomic, strong) NSArray *food2;
@property (nonatomic, strong) NSArray *food3;
@property (nonatomic, strong) NSArray *food4;
@property (nonatomic, strong) NSArray *food5;

@property (nonatomic, strong) NSMutableDictionary* foodForBarCode;

@end
