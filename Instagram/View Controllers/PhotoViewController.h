//
//  PhotoViewController.h
//  Instagram
//
//  Created by Fiona Barry on 7/6/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    CAMERA,
    PHOTOS,
} SelectionType;

@protocol PhotoViewControllerDelegate <NSObject>

- (void)setPostPhoto:(UIImage *)photo;

@end

@interface PhotoViewController : UIViewController

@property (strong, nonatomic) id<PhotoViewControllerDelegate> delegate;
@property (nonatomic) SelectionType type;

@end

NS_ASSUME_NONNULL_END
