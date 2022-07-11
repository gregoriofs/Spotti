//
//  ObjectivesViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "ObjectivesViewController.h"
#import "FocusAreaViewController.h"


@interface ObjectivesViewController ()

@end

@implementation ObjectivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentWorkout = [[Workout alloc]init];
    
    
}
- (IBAction)didTapStrength:(id)sender {
    
    if (![sender isKindOfClass:[UIButton class]])
           return;

    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    NSLog(@"%@", self.currentWorkout.objective);
}
- (IBAction)didTapConditioning:(id)sender {
    
    if (![sender isKindOfClass:[UIButton class]])
           return;

    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    NSLog(@"%@", self.currentWorkout.objective);
}
- (IBAction)didTapMuscleGrowth:(id)sender {
    
    if (![sender isKindOfClass:[UIButton class]])
           return;

    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    NSLog(@"%@", self.currentWorkout.objective);
    
}
- (IBAction)didTapFitness:(id)sender {
    
    if (![sender isKindOfClass:[UIButton class]])
           return;

    NSString *title = [(UIButton *)sender currentTitle];
    self.currentWorkout.objective = title;
    NSLog(@"%@", title);
    NSLog(@"%@", self.currentWorkout.objective);
}
- (IBAction)didTapNext:(id)sender {
    
    if(self.currentWorkout.objective != nil){
        
        [self performSegueWithIdentifier:@"focusAreaSegue" sender:self];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Potential error: not selecting the navigation controller, just the focus vc so it won't properly update or something similar
    
    UINavigationController *navigationController = [segue destinationViewController];
    FocusAreaViewController *newVC = (FocusAreaViewController *)navigationController.topViewController;
    
    newVC.currentWorkout = self.currentWorkout;
    
}

@end
