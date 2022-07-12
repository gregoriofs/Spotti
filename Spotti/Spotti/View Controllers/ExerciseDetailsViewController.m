//
//  ExerciseDetailsViewController.m
//  Spotti
//
//  Created by Gregorio Floretino Sanchez on 7/12/22.
//

#import "ExerciseDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ExerciseDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet UILabel *exerciseName;
@property (weak, nonatomic) IBOutlet UILabel *exerciseDescription;


@end


//TODO: add image to detail view

@implementation ExerciseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.exerciseName.text = self.exercise.exerciseName;
    self.exerciseDescription.text = self.exercise.exerciseDescription;
    
    NSLog(@"imageulr %@", self.imageURL);
    
    [self.exerciseImage setImageWithURL:self.imageURL];
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
