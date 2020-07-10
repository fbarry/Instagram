//
//  Like.h
//  Instagram
//
//  Created by Fiona Barry on 7/10/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>
#import "Post.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Like : PFObject

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) User *user;

+ (void)createLikeForPost:(Post *)post byUser:(User *)user withCompletion:(void (^)(BOOL succeeded, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
