//
//  GradientView.h
//  Instagram
//
//  Created by Fiona Barry on 7/9/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GradientView : UIView

@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) CAGradientLayer *gradient;

@end

NS_ASSUME_NONNULL_END
