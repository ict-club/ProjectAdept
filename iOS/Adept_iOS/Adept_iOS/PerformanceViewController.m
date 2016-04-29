//
//  PerformanceViewController.m
//  Adept_iOS
//
//  Created by Martin Kuvandzhiev on 3/28/16.
//  Copyright © 2016 Martin Kuvandzhiev. All rights reserved.
//

#import "PerformanceViewController.h"
#import "GraphicsTableViewCell.h"
#import "LogTableViewCell.h"
#import "ExerciseAndFoodLog.h"

@interface PerformanceViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"LogTableViewCell" bundle:nil] forCellReuseIdentifier:@"LogTableViewCellIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GraphicTableViewCell" bundle:nil] forCellReuseIdentifier:@"GraphicTableViewCellIdentifier"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.segmentController.selectedSegmentIndex == 0) return [[[ExerciseAndFoodLog sharedInstance] logArray] count];
    else return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * tableViewCell;
    if(self.segmentController.selectedSegmentIndex == 0)
    {
        LogTableViewCell * logTableViewCell = (LogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LogTableViewCellIdentifier" forIndexPath:indexPath];
        
        
        logTableViewCell.logTypeLabel.text = [[[ExerciseAndFoodLog sharedInstance] logArray] objectAtIndex:indexPath.row];
        
        logTableViewCell.dataLabel.text = [NSString stringWithFormat:@"%@ kCal",[[[ExerciseAndFoodLog sharedInstance] dataArray] objectAtIndex:indexPath.row]];
        
        NSDate * logDate = [[[ExerciseAndFoodLog sharedInstance] dateArray] objectAtIndex:indexPath.row];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        formatter.doesRelativeDateFormatting = YES;
        logTableViewCell.dateTimeLabel.text = [formatter stringFromDate:logDate];

        self.tableView.rowHeight = 60.0f;
        tableViewCell = logTableViewCell;
    }
    else
    {
        GraphicsTableViewCell * graphicTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"GraphicTableViewCellIdentifier" forIndexPath:indexPath];
        self.tableView.rowHeight = 180.0f;
        switch (indexPath.row) {
            case 0:
                graphicTableViewCell.graphicName.text = @"Wrist size";
                break;
            case 1:
                graphicTableViewCell.graphicName.text = @"Max power";
                break;
            case 2:
                graphicTableViewCell.graphicName.text = @"Calories balance";
                break;
            case 3:
                graphicTableViewCell.graphicName.text = @"Calories left to be burned";
                break;
            case 4:
                graphicTableViewCell.graphicName.text = @"BMI";
                break;
            default:
                break;
        }
        tableViewCell = graphicTableViewCell;
    }
    
    return tableViewCell;
    
}



- (IBAction)segmentControllerStateChanged:(id)sender {
    [self.tableView reloadData];
}

@end
