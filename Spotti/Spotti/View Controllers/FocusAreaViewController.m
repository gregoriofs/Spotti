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
}

- (IBAction)didTapChest:(UIButton *)sender {
    [sender setHighlighted:YES];
    NSString *area = [(UIButton *)sender currentTitle];
    [self.areas addObject:area];
}

- (IBAction)didTapBack:(UIButton *)sender {
    [sender setHighlighted:YES];
    NSString *area = [(UIButton *)sender currentTitle];
    [self.areas addObject:area];
}

- (IBAction)didTapBiceps:(UIButton *)sender {
    NSString *area = [(UIButton *)sender currentTitle];
    [sender setHighlighted:YES];
    [self.areas addObject:area];
}

- (IBAction)didTapTriceps:(UIButton *)sender {
    [sender setHighlighted:YES];
    NSString *area = [(UIButton *)sender currentTitle];
    [self.areas addObject:area];
}

- (IBAction)didTapLegs:(UIButton *)sender {
    [sender setHighlighted:YES];
    NSString *area = [(UIButton *)sender currentTitle];
    [self.areas addObject:area];
}

- (IBAction)didTapShoulders:(UIButton *)sender {
    [sender setHighlighted:YES];
    NSString *area = [(UIButton *)sender currentTitle];
    [self.areas addObject:area];
}

- (IBAction)didTapNext:(UIButton *)sender {
    self.currentWorkout.focusAreas = [self.areas allObjects];
    [self performSegueWithIdentifier:@"showFrequencySegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqual:@"showFrequencySegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        FrequencyViewController *newVC = (FrequencyViewController *)navigationController.topViewController;
        newVC.currentWorkout = self.currentWorkout;
    }
}

@end
