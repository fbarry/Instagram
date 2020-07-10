//
//  PostHeader.m
//  Instagram
//
//  Created by Fiona Barry on 7/8/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "PostHeader.h"

@implementation PostHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileTapped:)];
    [self addGestureRecognizer:profileTapGestureRecognizer];
}

- (void)profileTapped:(UITapGestureRecognizer *)sender {
    [self.delegate didTapProfile:self];
}

@end
