//
//  GradientView.m
//  Instagram
//
//  Created by Fiona Barry on 7/9/20.
//  Copyright © 2020 fbarry. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void)customInit {
    [[NSBundle mainBundle] loadNibNamed:@"GradientView" owner:self options:nil];
    [self addSubview:self.gradientView];
    self.gradientView.frame = self.bounds;
    self.gradientView.clipsToBounds = YES;
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.gradientView.bounds;
    self.gradient.colors = @[(id)[[UIColor systemPinkColor] CGColor], (id)[[UIColor purpleColor] CGColor], (id)[[UIColor systemPinkColor] CGColor]];
    self.gradient.locations = @[@0.0, @0.6, @0.8];
    [self.gradientView.layer insertSublayer:self.gradient atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradient.frame = self.gradientView.bounds;
}

@end
