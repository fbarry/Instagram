//
//  PostHeader.h
//  Instagram
//
//  Created by Fiona Barry on 7/8/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostHeader : UITableViewHeaderFooterView

// @property (strong, nonatomic) IBOutlet UIView *postHeader;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *postUsername;

@end

NS_ASSUME_NONNULL_END
