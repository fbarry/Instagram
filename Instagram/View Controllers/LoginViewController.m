//
//  LoginViewController.m
//  Instagram
//
//  Created by Fiona Barry on 7/6/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "LoginViewController.h"
#import "Utilities.h"
#import <Parse/Parse.h>
#import "User.h"
#import "GradientView.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet GradientView *gradientView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapSignup:(id)sender {
    [self performSegueWithIdentifier:@"SignUp" sender:self];
}

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error Logging In"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        }
    }];
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
