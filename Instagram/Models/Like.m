//
//  Like.m
//  Instagram
//
//  Created by Fiona Barry on 7/10/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "Like.h"

@implementation Like

@dynamic post;
@dynamic user;

+ (void)createLikeForPost:(Post *)post byUser:(User *)user withCompletion:(void (^)(BOOL succeeded, NSError * _Nullable error))completion {
    Like *like = [Like new];
    like.post = post;
    like.user = user;
    
    [like saveInBackgroundWithBlock:completion];
}

@end
