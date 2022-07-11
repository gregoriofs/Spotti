//
//  FocusAreaViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/7/22.
//

#import "FocusAreaViewController.h"
#import "FrequencyViewController.h"

@interface FocusAreaViewController ()

@property (strong, nonatomic) NSMutableSet* areas;
@end

@implementation FocusAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.areas = [[NSMutableSet alloc]init];
    
    NSLog(@"%@", self.currentWorkout);
}
- (IBAction)didTapChest:(id)sender {
    NSString *area = [(UIButton *)sender currentTitle];
    NSLog(@"%@",area);
    [self.areas addObject:area];
}
- (IBAction)didTapBack:(id)sender {
    NSString *area = [(UIButton *)sender currentTitle];
    NSLog(@"%@",area);
    [self.areas addObject:area];
}
- (IBAction)didTapBiceps:(id)sender {
    NSString *area = [(UIButton *)sender currentTitle];
    NSLog(@"%@",area);
    [self.areas addObject:area];
}
- (IBAction)didTapTriceps:(id)sender {
    NSString *area = [(UIButton *)sender currentTitle];
    NSLog(@"%@",area);
    [self.areas addObject:area];
}
- (IBAction)didTapLegs:(id)sender {
    NSString *area = [(UIButton *)sender currentTitle];
    NSLog(@"%@",area);
    [self.areas addObject:area];
}
- (IBAction)didTapShoulders:(id)sender {
    NSString *area = [(UIButton *)sender currentTitle];
    NSLog(@"%@",area);
    [self.areas addObject:area];
}
- (IBAction)didTapNext:(id)sender {
    
    self.currentWorkout.focusAreas = [self.areas allObjects];
    
    NSLog(@"%@",self.currentWorkout);
    
    [self performSegueWithIdentifier:@"showFrequencySegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqual:@"showFrequencySegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        FrequencyViewController *newVC = (FrequencyViewController *)navigationController.topViewController;
        newVC.currentWorkout = self.currentWorkout;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

*/

@end
