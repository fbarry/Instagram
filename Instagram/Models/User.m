//
//  User.m
//  Instagram
//
//  Created by Fiona Barry on 7/7/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "User.h"
#import "Utilities.h"

@implementation User

@dynamic profilePicture;
@dynamic name;
@dynamic descriptionText;
@dynamic likes;

- (void)updateProfilePicture:( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    self.profilePicture = [Utilities getPFFileFromImage:image];
    [self saveInBackgroundWithBlock:completion];
}

@end
