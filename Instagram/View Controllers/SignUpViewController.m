//
//  SignUpViewController.m
//  Instagram
//
//  Created by Fiona Barry on 7/9/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "SignUpViewController.h"
#import "Utilities.h"
#import "User.h"
#import "CameraView.h"
#import "GradientView.h"

@interface SignUpViewController () <CameraViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;
@property (weak, nonatomic) IBOutlet GradientView *gradientView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionField.delegate = self;
    [Utilities roundImage:(UIImageView *)self.profilePicture];
}

- (IBAction)didTapSignup:(id)sender {
    if ([self.username.text isEqual:@""] || [self.password.text isEqual:@""] || [self.name isEqual:@""]) {
        // Fields are empty
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Invalid Input"
                                                    message:@"Username/Password field is incomplete."];
    } else {
        User *user = [User new];
        
        user.username = self.username.text;
        user.password = self.password.text;
        user.descriptionText = self.descriptionField.text;
        user.profilePicture = [Utilities getPFFileFromImage:self.profilePicture.imageView.image];
                
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"Error Creating User"
                                                            message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            } else {
                [self performSegueWithIdentifier:@"Back" sender:self];
            }
        }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.descriptionField.text isEqualToString:@"Write your description here..."]) {
        self.descriptionField.text = nil;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.descriptionField.text isEqual:@""]) {
        self.descriptionField.text = @"Write your description here...";
    }
}

- (IBAction)didTapBack:(id)sender {
    [self performSegueWithIdentifier:@"Back" sender:self];
}

- (IBAction)didTapProfile:(id)sender {
    CameraView *camera = [[CameraView alloc] init];
    camera.delegate = self;
    camera.viewController = self;
    [camera alertConfirmation];
}

- (void)setImage:(UIImage *)image {
    [self.profilePicture setImage:image forState:UIControlStateNormal];
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
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
