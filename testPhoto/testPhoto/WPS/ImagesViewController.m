//
//  ImagesViewController.m
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "ImagesViewController.h"
#import "PGZoomImageView.h"
#import "UIButton+BackColor.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ImagesViewController ()<UIScrollViewDelegate>{

    UILabel  *_lblCurrentNumOfImage;
    UIView *_lblBackView;
    UIButton *_deleteBtn;
    UIView *_btnBackView;
    UIScrollView *_scrollView;
    UIControl *_overLayout;
    UIView *_deletePhotoView;
    int originCount;
    
}
@end

@implementation ImagesViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self initLayout];
    
    [self initUILayout];
    
    [self initDeletePhotoView];
}



- (void)initLayout{
    
    originCount = (int)_sourceImages.count;
    
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
    
    //建立预览图
    [self setUpPreviewBrowserWithAnimate:NO];
   
    
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

//建立预览图
- (void)setUpPreviewBrowserWithAnimate:(BOOL)animate{
    //
    if (_scrollView) {
        if (_scrollView.subviews.count > 0) {
            for (UIView *view in _scrollView.subviews) {
                [view removeFromSuperview];
            }
        }
    }
    
    CGFloat scrollView_W = _scrollView.frame.size.width;
    CGFloat scrollView_H = _scrollView.frame.size.height;
    
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
    
    
    [_scrollView scrollRectToVisible:CGRectMake(((_currentIndex * scrollView_W)), 0, scrollView_W, scrollView_H) animated:YES];
}


- (void)initUILayout{
    _overLayout = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _overLayout.backgroundColor = COLOR(.16, .17, .21, .5);
    [_overLayout addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initDeletePhotoView{
    
    //背景
    _deletePhotoView = [[UIView alloc] init];
    CGFloat deletePhotoView_H = 126;
    CGFloat deletePhotoView_W = [UIScreen mainScreen].bounds.size.width - 10;
    CGFloat deletePhotoView_Y = self.view.frame.size.height;
    CGFloat deletePhotoView_X = 5;
    
    _deletePhotoView.frame = CGRectMake(deletePhotoView_X  , deletePhotoView_Y ,deletePhotoView_W  , deletePhotoView_H);
    _deletePhotoView.backgroundColor = [UIColor clearColor];
    _deletePhotoView.layer.cornerRadius = 3.0f;
    _deletePhotoView.layer.masksToBounds = YES;
    
    //删除标题提示语
    CGFloat deletePhotoTip_H = 40;
    CGFloat deletePhotoTip_W = deletePhotoView_W;
    CGFloat deletePhotoTip_Y = 0;
    CGFloat deletePhotoTip_X = 0;
    UILabel *lbldeletePhotoTip = [[UILabel alloc] init];
    lbldeletePhotoTip.frame = CGRectMake(deletePhotoTip_X, deletePhotoTip_Y, deletePhotoTip_W, deletePhotoTip_H);
    lbldeletePhotoTip.font = [UIFont systemFontOfSize:12];
    lbldeletePhotoTip.textColor =  COLOR(160 , 160, 160, 1);
    lbldeletePhotoTip.backgroundColor = COLOR(255, 255, 255, 1);
    lbldeletePhotoTip.textAlignment = NSTextAlignmentCenter;
    lbldeletePhotoTip.text = @"要删除这张图片吗？";
    
    [_deletePhotoView addSubview:lbldeletePhotoTip];
    
    //中间一个间隙
    CGFloat line_X = deletePhotoTip_X;
    CGFloat line_Y = deletePhotoTip_Y + deletePhotoTip_H;
    CGFloat line_W = deletePhotoView_W;
    CGFloat line_H = 1;
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(line_X, line_Y, line_W, line_H);
    lineView.backgroundColor = COLOR(238, 238, 238, 1);
    [_deletePhotoView addSubview:lineView];
    
    //删除按钮
    CGFloat deletePhotoBtn_H = deletePhotoTip_H;
    CGFloat deletePhotoBtn_W = deletePhotoView_W;
    CGFloat deletePhotoBtn_Y = line_Y + line_H;
    CGFloat deletePhotoBtn_X = line_X;
    UIButton *deletePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletePhotoBtn.frame = CGRectMake(deletePhotoBtn_X, deletePhotoBtn_Y, deletePhotoBtn_W, deletePhotoBtn_H);
    deletePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [deletePhotoBtn setBackgroundColor:COLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    [deletePhotoBtn setBackgroundColor:COLOR(220, 220, 220, 1) forState:UIControlStateHighlighted];
    [deletePhotoBtn setTitleColor:COLOR(84, 84, 84, 1) forState:UIControlStateNormal];
    [deletePhotoBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deletePhotoBtn addTarget:self action:@selector(deletePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [_deletePhotoView addSubview:deletePhotoBtn];
    
    //取消按钮
    CGFloat cancleBtn_Y = deletePhotoBtn_Y + deletePhotoBtn_H + 5;
    CGFloat cancelBtn_X = deletePhotoBtn_X;
    CGFloat cancelBtn_W = deletePhotoView_W;
    CGFloat cancelBtn_H = deletePhotoTip_H;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(cancelBtn_X, cancleBtn_Y, cancelBtn_W, cancelBtn_H);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setBackgroundColor:COLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:COLOR(220, 220, 220, 1) forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:COLOR(84, 84, 84, 1) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_deletePhotoView addSubview:cancelBtn];
    
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
    _currentIndex = index;
    _lblCurrentNumOfImage.text = [NSString stringWithFormat:@"%d/%d",_currentIndex+1,(int)_sourceImages.count];
    if (index <0 || index>=_sourceImages.count) {
        return;
    }
    if (index != (_sourceImages.count -1)) {
        PGZoomImageView *zoomView = (PGZoomImageView *)[_scrollView viewWithTag:lastIndex];
        if (zoomView.overScrollView.zoomScale > 1.0) {
            zoomView.overScrollView.zoomScale = 1.0;
        }
    }
    
    lastIndex = 201+index;
    
    if (lastIndex == (_sourceImages.count -1)) {
        PGZoomImageView *zoomView = (PGZoomImageView *)[_scrollView viewWithTag:lastIndex];
        if (zoomView.overScrollView.zoomScale > 1.0) {
            zoomView.overScrollView.zoomScale = 1.0;
        }
        lastIndex = 201+index;
    }
}

#pragma mark Action
- (void)dismiss{
    if (_overLayout) {
        [_overLayout removeFromSuperview];
    }
    
    if (_deletePhotoView) {
        
        [UIView animateWithDuration:0.5f animations:^{
            CGRect originTakePhotoFrame = _deletePhotoView.frame;
            originTakePhotoFrame.origin.y += originTakePhotoFrame.size.height+5;
            _deletePhotoView.frame = originTakePhotoFrame;
        } completion:^(BOOL finished) {
            [_deletePhotoView removeFromSuperview];
        }];
    }
}


- (void)tapAction{
    if (originCount != (_sourceImages.count)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateUIWithSoureImages:)]) {
            [self.delegate updateUIWithSoureImages:_sourceImages];
        }
    }
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteAction:(UIButton *)btn{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:_overLayout];
    [keywindow addSubview:_deletePhotoView];
    [UIView animateWithDuration:0.5f animations:^{
        CGRect newTakePhotoViewFrame = _deletePhotoView.frame;
        newTakePhotoViewFrame.origin.y -= newTakePhotoViewFrame.size.height+5;
        _deletePhotoView.frame = newTakePhotoViewFrame;
    }];

}

- (void)deletePhotoAction{
    [self dismiss];
    switch (_currentIndex) {
        case 0:
            _currentIndex = 0;
            [_sourceImages removeObjectAtIndex:0];
            if (_sourceImages.count == 0) {
                _lblCurrentNumOfImage.text = @"";
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateUIWithSoureImages:)]) {
                    [self.delegate updateUIWithSoureImages:_sourceImages];
                }
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        case 1:
            _currentIndex = 1;            //一共有三张图片
            if (_sourceImages.count == 2) {//一共只有两张图片
                _currentIndex = 0;
            }
            [_sourceImages removeObjectAtIndex:1];
            break;
        case 2:
            _currentIndex = 1;
             [_sourceImages removeObjectAtIndex:2];
            break;
        default:
            break;
    }
    
    _lblCurrentNumOfImage.text = [NSString stringWithFormat:@"%d/%d",_currentIndex+1,(int)_sourceImages.count];
    _scrollView.contentSize = CGSizeMake(_sourceImages.count * SCREEN_WIDTH, _scrollView.frame.size.height);
    [self setUpPreviewBrowserWithAnimate:YES];
}

//取消
- (void)cancelAction{
    [self dismiss];
}

@end
