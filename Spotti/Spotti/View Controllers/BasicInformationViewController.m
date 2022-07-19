//
//  BasicInformationViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/6/22.
//

#import "BasicInformationViewController.h"
#import <Parse/Parse.h>
#import "GymUser.h"


@interface BasicInformationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *feet;
@property (weak, nonatomic) IBOutlet UITextField *inches;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *fitnessLevel;
@property (weak, nonatomic) IBOutlet UITextView *bio;
@property (weak, nonatomic) IBOutlet UITextField *gym;

@end

@implementation BasicInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapSubmit:(id)sender {
    GymUser *currentUser = [GymUser currentUser];
    currentUser[@"firstName"] = self.firstName.text;
    currentUser[@"lasttName"] = self.lastName.text;
    currentUser[@"gender"] = self.gender.text;
    currentUser[@"height"] = [NSString stringWithFormat:@"%@ ft, %@ in", self.feet.text,self.inches.text];
    currentUser[@"weight"] = [NSNumber numberWithInt:[self.weight.text intValue]];
    currentUser[@"fitnessLevel"] = self.fitnessLevel.text;
    currentUser[@"bio"] = self.bio.text;
    currentUser[@"friends"] = [NSArray new];
    currentUser[@"lastWorkout"] = [NSDate date];
    currentUser[@"streak"] = [NSNumber numberWithInt:0];
    currentUser[@"gym"] = self.gym.text;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
            if(succeeded){
                [self performSegueWithIdentifier:@"successfulInfoSubmission" sender:self];
            }
            else{
                NSLog(@"%@", error.localizedDescription);
            }
    }];
}
- (IBAction)dismissKeyboard:(id)sender {
    
    [self.view endEditing:YES];
}

@end
