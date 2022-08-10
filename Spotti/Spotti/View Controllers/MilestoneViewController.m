//
//  MilestoneViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 8/5/22.
//

#import "MilestoneViewController.h"
#import "MilestoneCell.h"
#import "GymUser.h"
#import "Parse/Parse.h"


@interface MilestoneViewController () <UITableViewDelegate, UITableViewDataSource, savedMilestone>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *milestones;
@end

@implementation MilestoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 168;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self getMilestoneList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMilestoneList) name:@"load" object:nil];
}

- (void)getMilestoneList{
    PFQuery *query = [PFQuery queryWithClassName:@"Milestone"];
    [query whereKey:@"user" equalTo:[GymUser currentUser]];
    [query whereKey:@"inProgress" equalTo:[NSNumber numberWithBool:YES]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.milestones = objects;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.milestones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MilestoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MilestoneCell" forIndexPath:indexPath];
    [cell setMilestone:self.milestones[indexPath.row]];
    return cell;
}

-(void)dismissMilestoneCreatorVC{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self getMilestoneList];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"creatingMilestone"]){
        UINavigationController *dest = [segue destinationViewController];
        MilestoneCreatorViewController* next = (MilestoneCreatorViewController *)dest.topViewController;
        next.delegate = self;
    }
}
@end
