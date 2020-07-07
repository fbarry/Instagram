//
//  CaptureViewController.m
//  Instagram
//
//  Created by Fiona Barry on 7/6/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "CaptureViewController.h"
#import "Post.h"
#import <Parse/Parse.h>
#import "Utilities.h"

@interface CaptureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *postImage;
@property (strong, nonatomic) IBOutlet UITextView *postText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator stopAnimating];
}

- (IBAction)didTapShare:(id)sender {
    [self.activityIndicator startAnimating];
    [Post postUserImage:self.postImage.currentImage withCaption:self.postText.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error Posting Content"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [self didTapCancel:self];
            self.navigationController.tabBarController.selectedViewController = [self.navigationController.tabBarController.viewControllers objectAtIndex:0];
        }
        [self.activityIndicator stopAnimating];
    }];
}

- (IBAction)didTapImage:(id)sender {
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
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || type == PHOTOS) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [Utilities resizeImage:info[UIImagePickerControllerOriginalImage] withSize:CGSizeMake(1000, 1000)];
    
    [self.postImage setImage:image forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapCancel:(id)sender {
    [self.postImage setImage:[UIImage imageNamed:@"image_placeholder.png"] forState:UIControlStateNormal];
    self.postText.text = nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
