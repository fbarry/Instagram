//
//  EditProfileViewController.m
//  Instagram
//
//  Created by Fiona Barry on 7/8/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "EditProfileViewController.h"
#import "User.h"
#import "Utilities.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;
@property (strong, nonatomic) User *currentUser;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utilities roundImage:(UIImageView *)self.profilePicture];
    
    self.currentUser = [User currentUser];
    self.nameField.text = self.currentUser.name;
    self.usernameField.text = self.currentUser.username;
    self.descriptionField.text = self.currentUser.descriptionText;
    
    if (self.currentUser.profilePicture) {
        UIImageView *image = [[UIImageView alloc] init];
        [image setImageWithURL:[NSURL URLWithString:self.currentUser.profilePicture.url]];
        [self.profilePicture setImage:image.image forState:UIControlStateNormal];
    }
}

- (IBAction)didTapSave:(id)sender {
    
    if ([self.nameField.text isEqualToString:@""] || [self.usernameField.text isEqualToString:@""]) {
        [Utilities presentOkAlertControllerInViewController:self
                                                  withTitle:@"Could Not Update"
                                                    message:@"One or more required fields are empty."];
    } else {
        self.currentUser.name = self.nameField.text;
        self.currentUser.username = self.usernameField.text;
        
        if (![self.passwordField.text isEqualToString:@""]) {
            self.currentUser.password = self.passwordField.text;
        }
        
        self.currentUser.descriptionText = self.descriptionField.text;
        self.currentUser.profilePicture = [Utilities getPFFileFromImage:self.profilePicture.imageView.image];
        
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                [Utilities presentOkAlertControllerInViewController:self
                                                          withTitle:@"Could Not Save"
                                                            message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            } else {
                UIAlertController *success = [UIAlertController alertControllerWithTitle:@"Successfully Updated Profile" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:success animated:YES completion:nil];
                [success dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (IBAction)didTapProfile:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pick Image Source" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Take New Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setPicture:CAMERA];
    }];
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"Choose Existing Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setPicture:PHOTOS];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:camera];
    [alert addAction:photos];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setPicture:(SelectionType) type {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
        
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || type == PHOTOS) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [Utilities resizeImage:info[UIImagePickerControllerOriginalImage] withSize:CGSizeMake(1000, 1000)];
    
    [self.profilePicture setImage:image forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
