//
//  DetailsViewController.m
//  Instagram
//
//  Created by Fiona Barry on 7/7/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PostCollectionViewCell.h"
#import <Parse/Parse.h>
#import "Utilities.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [Utilities roundImage:self.profilePicture];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.post.createdAt];
    
    if (self.post.author.profilePicture) {
        [self.profilePicture setImageWithURL:[NSURL URLWithString:self.post.author.profilePicture.url] placeholderImage:self.profilePicture.image];
    }
    self.usernameLabel.text = self.post.author.username;
    [self.postImage setImageWithURL:[NSURL URLWithString:self.post.image.url]];
    self.postText.text = self.post.caption;
    
    if (![self.post.author.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)didTapDelete:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Item" message:@"Are you sure you want to continue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deletePost];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) deletePost {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post deleteAllInBackground:@[self.post] block:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self withTitle:@"Cannot Delete Item" message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
