//
//  ExerciseDetailsViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import "ExerciseDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileViewController.h"

@interface ExerciseDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet UILabel *exerciseName;
@property (weak, nonatomic) IBOutlet UILabel *exerciseDescription;
@end
//TODO: add image to detail view

@implementation ExerciseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.exerciseName.text = self.exercise.exerciseName;
    self.exerciseDescription.text = self.exercise.exerciseDescription;
    self.exerciseImage.file = self.exercise.image;
    [self.exerciseImage loadInBackground];
}

@end
