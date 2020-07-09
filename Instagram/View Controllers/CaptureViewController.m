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
#import "MBProgressHUD.h"
#import "CameraView.h"

@interface CaptureViewController () <CameraViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *postImage;
@property (strong, nonatomic) IBOutlet UITextView *postText;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CaptureViewController

CGPoint lastOffset;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.postText.delegate = self;
}

- (IBAction)didTapShare:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post postUserImage:self.postImage.currentImage withCaption:self.postText.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error Posting Content"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            [self didTapCancel:self];
            self.navigationController.tabBarController.selectedViewController = [self.navigationController.tabBarController.viewControllers objectAtIndex:0];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)didTapImage:(id)sender {
    CameraView *camera = [[CameraView alloc] init];
    camera.delegate = self;
    camera.viewController = self;
    [camera alertConfirmation];
}

- (void)setImage:(UIImage *)image {
    [self.postImage setImage:image forState:UIControlStateNormal];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.postText.text isEqualToString:@"Write your caption here"]) {
        self.postText.text = nil;
    }
    [self.postImage setUserInteractionEnabled:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.postImage setUserInteractionEnabled:YES];
    if ([self.postText.text isEqual:@""]) {
        self.postText.text = @"Write your caption here";
    }
}

- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapCancel:(id)sender {
    [Utilities presentConfirmationInViewController:self
                                         withTitle:@"Draft will be deleted"
                                         yesHandler:^(UIAlertAction * _Nonnull action) {
        self.postText.text = @"Write your caption here";
        [self.postImage setImage:[UIImage imageNamed:@"placeholder_image"] forState:UIControlStateNormal];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
