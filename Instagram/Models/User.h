//
//  User.h
//  Instagram
//
//  Created by Fiona Barry on 7/7/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser

@property (strong, nonatomic) PFFileObject *profilePicture;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descriptionText;

- (void) updateProfilePicture: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
