//
//  LoginViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/6/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "GymUser.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (IBAction)didTapLogIn:(id)sender {
    [self loginUser];
}

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)registerUser {
    GymUser *newUser = [GymUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            [self performSegueWithIdentifier:@"successfulSignup" sender:self];
        }
    }];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [GymUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            [self performSegueWithIdentifier:@"successfulLogin" sender:self];
        }
    }];
}

@end
