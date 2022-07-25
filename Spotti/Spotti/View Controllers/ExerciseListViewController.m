//
//  ExerciseListViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/25/22.
//

#import "ExerciseListViewController.h"
#import "ExerciseListCell.h"
#import "APIManager.h"

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
    [self makeRequest:NO completionBlock:^(NSArray *result) {
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

- (void)makeRequest:(BOOL)isPagination completionBlock: (void (^)(NSArray *result))completion{
    if(!isPagination){
        _isPaginationOn = YES;
        [self.activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            APIManager *manager = [APIManager new];
            NSArray __block *res = [NSArray new];
            [manager exerciseList:(self.exerciseList.count + 20) completionBlock:^(NSArray * _Nonnull exercises) {
                [self.activityIndicator stopAnimating];
                res = exercises;
                completion(exercises);
            }];
            self.isPaginationOn = NO;
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.isPaginationOn = NO;
            [self.tableView reloadData];
        });
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger pos = scrollView.contentOffset.y;
    NSInteger contentHeight = scrollView.contentSize.height;
    if ((pos > contentHeight - 20 - scrollView.frame.size.height) && !_isPaginationOn){
        [self makeRequest:YES completionBlock:^(NSArray *result) {
                    self.exerciseList = result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
        }];
    }
}

@end
