//
//  ImagesViewController.m
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "ImagesViewController.h"
#import "PGZoomImageView.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ImagesViewController ()<UIScrollViewDelegate>{

    UILabel  *_lblCurrentNumOfImage;
    UIView *_lblBackView;
    UIButton *_deleteBtn;
    UIView *_btnBackView;
    UIScrollView *_scrollView;
    
}
@end

@implementation ImagesViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initLayout];
}


- (void)initLayout{
    
    CGFloat scrollView_Y = 40;
    CGFloat scrollView_X = 0;
    CGFloat scrollView_W = SCREEN_WIDTH;
    CGFloat scrollView_H = SCREEN_HEIGHT - scrollView_Y - 40;
    CGRect scrollViewFrame = CGRectMake(scrollView_X, scrollView_Y, scrollView_W, scrollView_H);
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [self.view addSubview:_scrollView];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 4;
    _scrollView.minimumZoomScale = 0.5;
    
    if (_sourceImages.count > 0) {
        [_scrollView setContentSize:CGSizeMake(scrollView_W * _sourceImages.count, scrollView_H)];
    }

    //图片
    scrollView_W = _scrollView.frame.size.width;
    scrollView_H = _scrollView.frame.size.height;
   
    int index =0;
    for (UIImage *image in _sourceImages) {
        
        CGRect pgZoomViewFrame =  CGRectMake(index*scrollView_W, 0, scrollView_W, scrollView_H);
        PGZoomImageView *imageView = [[PGZoomImageView alloc] initWithFrame:pgZoomViewFrame];
        imageView.tag = index+201;
        imageView.image = image;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        tapImg.numberOfTapsRequired = 1;
        tapImg.numberOfTouchesRequired = 1;
        
        [imageView addGestureRecognizer:tapImg];
        
        [_scrollView addSubview:imageView];
        ++index;
    }
    
    
    [_scrollView scrollRectToVisible:CGRectMake(((_currentIndex * scrollView_W)), 0, scrollView_W, scrollView_H) animated:NO];
    
    //当前图片位置背景
    CGFloat lblBackView_HW = 30;
    CGFloat lblBackView_X = 15;
    CGFloat lblBackView_Y = SCREEN_HEIGHT - 20 - lblBackView_HW;
 
    _lblBackView = [[UIView alloc] initWithFrame:CGRectMake(lblBackView_X, lblBackView_Y, lblBackView_HW, lblBackView_HW)];
    _lblBackView.backgroundColor = COLOR(.16, .17, .21, .5);
    _lblBackView.layer.cornerRadius = 3.0f;
    _lblBackView.layer.masksToBounds = YES;
    [self.view addSubview:_lblBackView];
    
    //当前的图片位置
    CGFloat lblCurrentNum_X = 0;
    CGFloat lblCurrentNum_H = 30;
    CGFloat lblCurrentNum_W = 30;
    CGFloat lblCurrentNum_Y = 0;
    CGRect lblCurrentNumFrame = CGRectMake(lblCurrentNum_X, lblCurrentNum_Y, lblCurrentNum_W, lblCurrentNum_H);
    
    _lblCurrentNumOfImage = [[UILabel alloc] initWithFrame:lblCurrentNumFrame];
    _lblCurrentNumOfImage.textAlignment = NSTextAlignmentCenter;
    _lblCurrentNumOfImage.textColor = [UIColor whiteColor];
    _lblCurrentNumOfImage.font = [UIFont systemFontOfSize:14];
    _lblCurrentNumOfImage.text = [NSString stringWithFormat:@"%d/%d",_currentIndex+1,(int)_sourceImages.count];
    [_lblBackView addSubview:_lblCurrentNumOfImage];
    
    //删除按钮背景
    CGFloat btnBackView_HW = lblBackView_HW;
    CGFloat btnBackView_X = SCREEN_WIDTH - 15 - btnBackView_HW;
    CGFloat btnBackView_Y = lblBackView_Y;
    CGRect btnBackViewFrame = CGRectMake(btnBackView_X, btnBackView_Y, btnBackView_HW, btnBackView_HW);
    _btnBackView = [[UIView alloc] initWithFrame:btnBackViewFrame];
    _btnBackView.backgroundColor = COLOR(.16, .17, .21, .5);
    _btnBackView.layer.cornerRadius = 3.0f;
    _btnBackView.layer.masksToBounds = YES;
    [self.view addSubview:_btnBackView];
    
    //删除按钮
    CGFloat deleteBtn_HW = 25;
    CGFloat deleteBtn_Y = (btnBackView_HW - deleteBtn_HW)/2.0;
    CGFloat deleteBtn_X = (btnBackView_HW - deleteBtn_HW)/2.0; //SCREEN_WIDTH - 15 - deleteBtn_HW;
    CGRect deleteBtnFrame = CGRectMake(deleteBtn_X, deleteBtn_Y, deleteBtn_HW, deleteBtn_HW);
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = deleteBtnFrame;
    [_deleteBtn setImage:[UIImage imageNamed:@"icon_del.png"] forState:UIControlStateNormal];
    [_deleteBtn setImage:[UIImage imageNamed:@"icon_del_h.png"] forState:UIControlStateHighlighted];
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBackView addSubview:_deleteBtn];
    
}

#pragma mark - UIScrollView Delegate
static int lastIndex = 201;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self dealWithZoomScaleWithScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   [self dealWithZoomScaleWithScrollView:scrollView];
}


#pragma mark - Private Method

- (void)dealWithZoomScaleWithScrollView:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x)/SCREEN_WIDTH;
    if (index <0 || index>=_sourceImages.count) {
        return;
    }
    if (index != (_sourceImages.count -1)) {
        PGZoomImageView *zoomView = (PGZoomImageView *)[_scrollView viewWithTag:lastIndex];
        if (zoomView.overScrollView.zoomScale > 1.0) {
            zoomView.overScrollView.zoomScale = 1.0;
        }
        lastIndex = 201+index;
    }

}

#pragma mark Action
- (void)tapAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteAction:(UIButton *)btn{
   
}

@end
