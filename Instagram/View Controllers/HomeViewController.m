//
//  HomeViewController.m
//  Instagram
//
//  Created by Fiona Barry on 7/6/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "HomeViewController.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import <Parse/Parse.h>
#import "Utilities.h"
#import "PostCell.h"
#import "UIImageView+AFNetworking.h"
#import "CaptureViewController.h"
#import "DetailsViewController.h"
#import "PostHeader.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.activityIndicator.center = self.view.center;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PostHeader" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"PostHeader"];
    
    [self loadFeed];
    
    self.tableView.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView.refreshControl addTarget:self action:@selector(loadFeed) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadFeed];
}

- (void)loadFeed {
    [self.activityIndicator startAnimating];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKeys:@[@"author",@"image"]];
    [query addDescendingOrder:@"createdAt"];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (error) {
            [Utilities presentOkAlertControllerInViewController:self
                                                      withTitle:@"Error Retreiving Feed"
                                                        message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        } else {
            self.posts = posts;
            [self.tableView reloadData];
        }
        [self.tableView.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 62;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    cell.post = self.posts[indexPath.section];
    [cell.postImage setImageWithURL:[NSURL URLWithString:cell.post.image.url] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    cell.postText.text = cell.post.caption;
    cell.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", cell.post.likeCount];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PostHeader *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PostHeader"];
    [Utilities roundImage:header.profilePicture];
    Post *post = self.posts[section];
    if (post.author.profilePicture) {
        [header.profilePicture setImageWithURL:[NSURL URLWithString:post.author.profilePicture.url] placeholderImage:header.profilePicture.image];
    }
    header.postUsername.text = post.author.username;
    return header;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Details"]) {
        DetailsViewController *detailsViewController = [segue destinationViewController];
        PostCell *cell = sender;
        detailsViewController.post = cell.post;
    }
}

@end
