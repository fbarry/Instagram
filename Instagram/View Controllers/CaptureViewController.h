//
//  CaptureViewController.h
//  Instagram
//
//  Created by Fiona Barry on 7/6/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    CAMERA,
    PHOTOS,
} SelectionType;

@protocol CaptureViewControllerDelegate <NSObject>

- (void)didPost;

@end

@interface CaptureViewController : UIViewController

@property (nonatomic) id<CaptureViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
