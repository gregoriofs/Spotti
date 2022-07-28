//
//  ExerciseListViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/25/22.
//

#import "ExerciseListViewController.h"
#import "ExerciseListCell.h"
#import "APIManager.h"
#import "ExerciseDetailsViewController.h"

@interface ExerciseListViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *exerciseList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isPaginationOn;
@end

@implementation ExerciseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _isPaginationOn = NO;
    self.exerciseList = [NSArray new];
    [self makeRequest:^(NSArray *result) {
        self.exerciseList = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (IBAction)didTapPlus:(UIButton *)sender {
    [self animateButton:sender];
    ExerciseListCell *cell = sender.superview.superview;
    [self.delegate addedNewExercise:cell.exercise];
}

- (void) animateButton:(UIButton *)button{
    button.frame = CGRectMake(30, 50, 100, 100);
    [UIView animateWithDuration:.75 animations:^{
            button.frame = CGRectMake(10, 70, 100, 100);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExerciseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exerciseListCell" forIndexPath:indexPath];
    if(!self.addingExercise){
        cell = [tableView dequeueReusableCellWithIdentifier:@"exerciseListCellTwo"forIndexPath:indexPath];
    }
    Exercise *exercise = self.exerciseList[indexPath.row];
    cell.exercise = exercise;
    cell.exerciseName.text = exercise.exerciseName;
    cell.focusArea.text = [exercise.muscles componentsJoinedByString:@","];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.exerciseList.count;
}

- (void)makeRequest: (void (^)(NSArray *result))completion{
    APIManager *manager = [APIManager new];
    [manager exerciseList:(self.exerciseList.count + 20) allExercises:NO completionBlock:^(NSArray * _Nonnull exercises) {
        [self.activityIndicator stopAnimating];
        NSMutableArray *tempCopy = [self.exerciseList mutableCopy];
        [tempCopy addObjectsFromArray:exercises];
        self.exerciseList = [tempCopy copy];
        self.isPaginationOn = NO;
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isPaginationOn){
        NSInteger scrollViewContentHeight = self.tableView.contentSize.height;
        NSInteger scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging){
            self.isPaginationOn = YES;
            [self.activityIndicator startAnimating];
            [self makeRequest:^(NSArray *result) {
            }];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        ExerciseDetailsViewController *next = [segue destinationViewController];
        Exercise *curr = self.exerciseList[[self.tableView indexPathForCell:sender].row];
        next.exercise = curr;
}


@end
