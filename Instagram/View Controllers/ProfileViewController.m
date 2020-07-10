//
//  ProfileViewController.m
//  Instagram
//
//  Created by Fiona Barry on 7/6/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "ProfileViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Utilities.h"
#import "PostCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "CollectionHeader.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if (!self.user) {
        self.user = [User currentUser];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [self getProfileFeed];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getProfileFeed];
}

- (void)getProfileFeed {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
        
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGFloat postsPerRow = 3;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postsPerRow - 1)) / postsPerRow;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" equalTo:self.user];
    [query includeKeys:@[@"author",@"image"]];
    [query addDescendingOrder:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error Retreiving Feed"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            self.posts = posts;
            [self.collectionView reloadData];
        }
    }];
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;

    [PFUser logOut];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        PostCollectionViewCell *cell = sender;
        detailsViewController.post = cell.post;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    
    cell.post = post;
    [cell.postImage setImageWithURL:[NSURL URLWithString:post.image.url] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeader *collectionHeader = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeader" forIndexPath:indexPath];
    
    [Utilities roundImage:collectionHeader.profilePicture];
                
    collectionHeader.nameLabel.text = self.user.name;
    collectionHeader.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.user.username];
    collectionHeader.descriptionLabel.text = self.user.descriptionText;
    if (self.user.profilePicture) {
        [collectionHeader.profilePicture setImageWithURL:[NSURL URLWithString:self.user.profilePicture.url] placeholderImage:collectionHeader.profilePicture.image];
    }
    
    return collectionHeader;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (IBAction)didTapEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"Edit" sender:self];
}

@end
