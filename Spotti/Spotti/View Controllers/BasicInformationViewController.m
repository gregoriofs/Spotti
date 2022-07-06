//
//  BasicInformationViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/6/22.
//

#import "BasicInformationViewController.h"
#import <Parse/Parse.h>

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

@end

@implementation BasicInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSubmit:(id)sender {
    NSLog(@"successful submission of new data");
    
    PFUser *currentUser = [PFUser currentUser];
    
    currentUser[@"firstName"] = self.firstName.text;
    currentUser[@"lastName"] = self.lastName.text;
    currentUser[@"gender"] = self.gender.text;
    currentUser[@"height"] = [NSString stringWithFormat:@"%@ ft, %@ in", self.feet.text,self.inches.text];
    currentUser[@"weight"] = [NSNumber numberWithInt:[self.weight.text intValue]];
    currentUser[@"fitnessLevel"] = self.fitnessLevel.text;
    currentUser[@"bio"] = self.bio.text;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
            if(succeeded){
                NSLog(@"saved all user basic information");
                [self performSegueWithIdentifier:@"successfulInfoSubmission" sender:self];
            }
            else{
                NSLog(@"%@", error.localizedDescription);
            }
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
