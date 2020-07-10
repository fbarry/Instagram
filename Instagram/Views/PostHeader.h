//
//  PostHeader.h
//  Instagram
//
//  Created by Fiona Barry on 7/8/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@class PostHeader;

@protocol PostHeaderDelegate <NSObject>

- (void)didTapProfile:(PostHeader *)header;

@end

@interface PostHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) id <PostHeaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *postUsername;
@property (strong, nonatomic) User *user;

@end

NS_ASSUME_NONNULL_END
