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
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString* barCodeString;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *food1;
@property (nonatomic, strong) NSMutableArray *food2;
@property (nonatomic, strong) NSMutableArray *food3;
@property (nonatomic, strong) NSMutableArray *food4;
@property (nonatomic, strong) NSMutableArray *food5;

@property (nonatomic, strong) NSMutableDictionary* foodForBarCode;

@end
