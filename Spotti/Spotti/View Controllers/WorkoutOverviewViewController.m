//
//  WorkoutOverviewViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/8/22.
//


//TODO: Upon finishing a workout, save exercises and their values to parse saveinBackgroundwithBlock


#import "WorkoutOverviewViewController.h"
#import "ExerciseCell.h"

@interface WorkoutOverviewViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *objectives;
@property (weak, nonatomic) IBOutlet UILabel *focusAreas;
@property (weak, nonatomic) IBOutlet UILabel *frequency;


@end

@implementation WorkoutOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *muscleNumbers = [[NSMutableDictionary alloc] init];
    muscleNumbers[@"Legs"] = [NSArray arrayWithObjects:@(11),@(7),@(8),@(10),@(3),@(15),  nil];
    muscleNumbers[@"Chest"] = [NSArray arrayWithObjects:@(4), nil];
    muscleNumbers[@"Back"] = [NSArray arrayWithObjects:@(12), @(9),nil];
    muscleNumbers[@"Biceps"] = [NSArray arrayWithObjects:@(1),@(13), nil];
    muscleNumbers[@"Triceps"] = [NSArray arrayWithObjects:@(5), nil];
    muscleNumbers[@"Shoulders"] = [NSArray arrayWithObjects:@(2), nil];
    
    self.muscleNumbers = [muscleNumbers copy];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.objectives.text = self.workout.objective;
    self.focusAreas.text = [self.workout.focusAreas componentsJoinedByString:@","];
    self.frequency.text = [NSString stringWithFormat:@"%@ times a week", self.workout.frequency];
    
    [self fillExerciseList];



    
}

- (void)fillExerciseList{
    
//    NSMutableArray __block *temp = [NSMutableArray new];
    
    APIManager *manager = [APIManager new];
    
//    for(int i = 0; i < self.workout.focusAreas.count;i++){
//        [manager exerciseListFromWorkout:self.workout currentExercise:0 completionBlock:^(NSArray *exercises){
////            [temp addObjectsFromArray:exercises];
////            NSLog(@"temp size %lu",(unsigned long)temp.count);
//            self.exercises = exercises;
//            NSLog(@"exercises size inside loop %lu", (unsigned long)self.exercises.count);
//        }];
        
//            }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://wger.de",@"/api/v2/exercise/?language=2"]];
    //    NSLog(@"%@",url);
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                
                            NSLog(@"%@", [error localizedDescription]);
                
                        }
            else
            {
                
                NSLog(@"Succesful results");
            
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSArray *results = dataDictionary[@"results"];
                NSLog(@"%@", [results class]);
                
                
                NSLog(@"res: %@", results);
                
                self.exercises = results;
                
            }
        }];
    
    [task resume];
        
//    self.workout.exerciseArray = self.exercises;
    
    [self.tableView reloadData];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://wger.de",@"/api/v2/exercise/?language=2"]];
//    NSLog(@"%@",url);
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
//    NSURLSession *session =  [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"executing task");
//            if (error != nil) {
//                NSLog(@"%@", [error localizedDescription]);
//            }
//            else {
//
//                NSLog(@"Succesful results");
//
//                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//                NSArray *results = dataDictionary[@"results"];
//
//                NSArray *focusAreas = self.workout.focusAreas;
//                NSMutableArray *completeExerciseList = [NSMutableArray new];
//
//                int numberOfExercises = [self.workout.frequency intValue] >= 3 ? 7 : 5;
//                int exercisesPerArea = (numberOfExercises/focusAreas.count) + 1;
//
//                NSLog(@"%@", results);
//
//                for(int i = 0; i < focusAreas.count;i++){
//
//                    NSString *currentExerciseNumbers = self.muscleNumbers[focusAreas[i]];
////                    NSArray *filteredarray = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ IN $muscles", currentExerciseNumbers]];
//
////                    NSArray *array = [NSArray arrayWithObject:[NSMutableDictionary dictionaryWithObject:@"filter string" forKey:@"email"]];   // you can also do same for Name key...
//                       NSArray *filteredarray = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"muscles IN %@", currentExerciseNumbers]];
//                    NSLog(@"%@", currentExerciseNumbers);
//                    NSLog(@"filtered %@", filteredarray);
//
//                }
//
//                [self.tableView reloadData];
//            }
//        }];
//
//[task resume];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
    
    Exercise *currentExercise = self.exercises[indexPath.row];
    
    cell.exercise = currentExercise;
    cell.exerciseName.text = currentExercise.exerciseName;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"number of counts %lu", (unsigned long)self.exercises.count);
    return self.exercises.count;
}


@end
