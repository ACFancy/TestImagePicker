//
//  PGZoomImageView.m
//  testPhoto
//
//  Created by ianc on 15/9/11.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "PGZoomImageView.h"

@interface PGZoomImageView ()<UIScrollViewDelegate>{
    BOOL _didCheckSizel;
    UIImageView *_imageView;
}

@end

@implementation PGZoomImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect overScrollViewFrame = self.frame;
        overScrollViewFrame.origin.x = 0;
        overScrollViewFrame.origin.y = 0;
        _overScrollView = [[UIScrollView alloc] initWithFrame:overScrollViewFrame];
        _overScrollView.maximumZoomScale = 3;
        _overScrollView.minimumZoomScale = 1;
        _overScrollView.showsHorizontalScrollIndicator = NO;
        _overScrollView.showsVerticalScrollIndicator = NO;
        _overScrollView.scrollsToTop = NO;
        _overScrollView.backgroundColor = [UIColor blackColor];
        _overScrollView.delegate = self;
        [self addSubview:_overScrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:_overScrollView.frame];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_overScrollView addSubview:_imageView];
        
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    _imageView.image = image;
}

#pragma mark - 返回需要放大的视图 要是ScrollView的子视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

@end
