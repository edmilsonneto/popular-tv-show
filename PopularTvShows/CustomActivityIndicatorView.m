//
//  CustomActivityIndicatorView.m
//  PopularTvShows
//
//  Created by Edmilson Neto on 21/01/17.
//  Copyright © 2017 Edmilson Neto. All rights reserved.
//

#import "CustomActivityIndicatorView.h"

@implementation CustomActivityIndicatorView

- (CustomActivityIndicatorView *) initWithView:(UIView *) view size:(int)size style:(UIActivityIndicatorViewStyle)style {
    self = [super initWithFrame:view.frame];
    if(self) {
        UIView *bg = [[UIView alloc] initWithFrame:view.frame];
        bg.backgroundColor = [UIColor blackColor];
        bg.alpha = 0.6f;
        
        UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
        bg2.center = view.center;
        bg2.backgroundColor = [UIColor blackColor];
        bg2.layer.cornerRadius = 10;
        bg2.layer.masksToBounds = YES;
        
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        act.center = self.center;
        
        self.center = view.center;
        [self addSubview:bg];
        [self addSubview:bg2];
        [self addSubview:act];
        [act startAnimating];
    }
    return self;
}

@end
