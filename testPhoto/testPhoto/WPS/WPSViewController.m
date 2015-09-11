//
//  WPSViewController.m
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "WPSViewController.h"
#import "UIButton+BackColor.h"
#import  <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImagesViewController.h"
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface WPSViewController (){
    NSMutableArray *realImageArray;
    UIControl *_overLayout;
    UIView *_takePhotoView;
    UIImage *_selectedImage;
    SEL tapSelector;
}

@end

@implementation WPSViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initLayouts];
    
    [self initUILayout];
    
    [self initTakePhotoView];
}

- (void)initLayouts{
    for (UIImageView *imgView in _imageViews) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.userInteractionEnabled = YES;
        if (imgView.tag == 101) {
            if (_sourceimages.count) {//有一张图片
                imgView.hidden = NO;
                imgView.image = _sourceimages[0];
                tapSelector = @selector(previewChoosedPhotoAction:);
                [tap addTarget:self action:tapSelector];
            }else{                    //没有图片
                tapSelector = @selector(choosePhotoAction);
                [tap addTarget:self action:tapSelector];
                imgView.hidden = NO;
                imgView.image = [UIImage imageNamed:@"friend_add_img_icon.png"];
            }
           
        }else if(imgView.tag == 102){
            if (_sourceimages.count > 1) {  //选了一张以上图片
                imgView.hidden = NO;
                imgView.image = _sourceimages[1];
                tapSelector = @selector(previewChoosedPhotoAction:);
                [tap addTarget:self action:tapSelector];
                
            }else if(_sourceimages.count == 1){         //选了一张图片
                tapSelector = @selector(choosePhotoAction);
                [tap addTarget:self action:tapSelector];
                imgView.hidden = NO;
                imgView.image = [UIImage imageNamed:@"friend_add_img_icon.png"];
            }else{
                imgView.hidden = YES;
            }
           
        }else{
            if (_sourceimages.count > 2) { //选了三张图片
                imgView.hidden = NO;
                imgView.image = _sourceimages[2];
                tapSelector = @selector(previewChoosedPhotoAction:);
                [tap addTarget:self action:tapSelector];
            }else if(_sourceimages.count == 2){ //选了两张图片
                tapSelector = @selector(choosePhotoAction);
                [tap addTarget:self action:tapSelector];
                imgView.hidden = NO;
                imgView.image = [UIImage imageNamed:@"friend_add_img_icon.png"];
            }else{                       //选了一张或更少图片
                imgView.hidden = YES;
            }
        }
       [imgView addGestureRecognizer:tap];
    }
}

- (void)initUILayout{
    _overLayout = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _overLayout.backgroundColor = COLOR(.16, .17, .21, .5);
    [_overLayout addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTakePhotoView{
    
    //背景
    _takePhotoView = [[UIView alloc] init];
    CGFloat takePhotoView_H = 126;
    CGFloat takePhotoView_W = [UIScreen mainScreen].bounds.size.width - 10;
    CGFloat takePhotoView_Y = self.view.frame.size.height;
    CGFloat takePhotoView_X = 5;
    
    _takePhotoView.frame = CGRectMake(takePhotoView_X  , takePhotoView_Y ,takePhotoView_W  , takePhotoView_H);
    _takePhotoView.backgroundColor = [UIColor clearColor];
    _takePhotoView.layer.cornerRadius = 3.0f;
    _takePhotoView.layer.masksToBounds = YES;
    
    //拍照按钮
    CGFloat takePhotoBtn_H = 40;
    CGFloat takePhotoBtn_W = takePhotoView_W;
    CGFloat takePhotoBtn_Y = 0;
    CGFloat takePhotoBtn_X = 0;
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoBtn.frame = CGRectMake(takePhotoBtn_X, takePhotoBtn_Y, takePhotoBtn_W, takePhotoBtn_H);
    takePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [takePhotoBtn setBackgroundColor:COLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    [takePhotoBtn setBackgroundColor:COLOR(220, 220, 220, 1) forState:UIControlStateHighlighted];
    [takePhotoBtn setTitleColor:COLOR(84, 84, 84, 1) forState:UIControlStateNormal];
    [takePhotoBtn setTitle:@"拍 照" forState:UIControlStateNormal];
    [takePhotoBtn addTarget:self action:@selector(takePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [_takePhotoView addSubview:takePhotoBtn];
    
    //中间一个间隙
    CGFloat line_X = takePhotoBtn_X;
    CGFloat line_Y = takePhotoBtn_Y + takePhotoBtn_H;
    CGFloat line_W = takePhotoView_W;
    CGFloat line_H = 1;
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(line_X, line_Y, line_W, line_H);
    lineView.backgroundColor = COLOR(238, 238, 238, 1);
    [_takePhotoView addSubview:lineView];
    
    //从手机相册选择
    CGFloat fromPhotoBtn_H = takePhotoBtn_H;
    CGFloat fromPhotoBtn_W = takePhotoView_W;
    CGFloat fromPhotoBtn_Y = line_Y + line_H;
    CGFloat fromPhotoBtn_X = line_X;
    UIButton *fromPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fromPhotoBtn.frame = CGRectMake(fromPhotoBtn_X, fromPhotoBtn_Y, fromPhotoBtn_W, fromPhotoBtn_H);
    fromPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fromPhotoBtn setBackgroundColor:COLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    [fromPhotoBtn setBackgroundColor:COLOR(220, 220, 220, 1) forState:UIControlStateHighlighted];
    [fromPhotoBtn setTitleColor:COLOR(84, 84, 84, 1) forState:UIControlStateNormal];
    [fromPhotoBtn setTitle:@"从手机相册选择" forState:UIControlStateNormal];
    [fromPhotoBtn addTarget:self action:@selector(fromPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [_takePhotoView addSubview:fromPhotoBtn];
    
    //取消按钮
    CGFloat cancleBtn_Y = fromPhotoBtn_Y + fromPhotoBtn_H + 5;
    CGFloat cancelBtn_X = fromPhotoBtn_X;
    CGFloat cancelBtn_W = takePhotoView_W;
    CGFloat cancelBtn_H = takePhotoBtn_H;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(cancelBtn_X, cancleBtn_Y, cancelBtn_W, cancelBtn_H);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setBackgroundColor:COLOR(255, 255, 255, 1) forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:COLOR(220, 220, 220, 1) forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:COLOR(84, 84, 84, 1) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_takePhotoView addSubview:cancelBtn];
    
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        _selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else{
        return;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toImagesSegue"]) {
        NSNumber *indexNum = (NSNumber *)sender;
        ImagesViewController *imgVC = (ImagesViewController *)segue.destinationViewController;
        imgVC.sourceImages = _sourceimages;
        imgVC.currentIndex = [indexNum intValue];
    }
}

#pragma mark - Action
- (void)dismiss{
    if (_overLayout) {
        [_overLayout removeFromSuperview];
    }
    
    if (_takePhotoView) {
        
        [UIView animateWithDuration:0.5f animations:^{
            CGRect originTakePhotoFrame = _takePhotoView.frame;
            originTakePhotoFrame.origin.y += originTakePhotoFrame.size.height+5;
            _takePhotoView.frame = originTakePhotoFrame;
        } completion:^(BOOL finished) {
            [_takePhotoView removeFromSuperview];
        }];
    }
}

//拍照
- (void)takePhotoAction{
    AVAuthorizationStatus statuss = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statuss == AVAuthorizationStatusAuthorized) {
        [self dismiss];
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = (id)self;
        camera.allowsEditing = NO;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            NSString *reqiredMediaType = (NSString *)kUTTypeImage;
            NSArray *arrMediaTypes = [NSArray arrayWithObject:reqiredMediaType];
            camera.mediaTypes = arrMediaTypes;
        }else{
            return;
        }
        
        [self presentViewController:camera animated:YES completion:nil];
    }else if(statuss == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                UIImagePickerController *camera = [[UIImagePickerController alloc] init];
                camera.delegate = (id)self;
                camera.allowsEditing = NO;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
                    camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                    NSString *reqiredMediaType = (NSString *)kUTTypeImage;
                    NSArray *arrMediaTypes = [NSArray arrayWithObject:reqiredMediaType];
                    camera.mediaTypes = arrMediaTypes;
                }
            }
        }];
        
    }else{
        [self dismiss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CannotUseCamera", nil) message:NSLocalizedString(@"CannotUseCameraTip", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"confirm",nil) otherButtonTitles: nil];
        [alertView show];
    }
}

//从相机中选择
- (void)fromPhotoAction{
    [self dismiss];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = (id)self;
    picker.allowsEditing = NO;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//取消
- (void)cancelAction{
    [self dismiss];
}

- (void)choosePhotoAction{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_overLayout];
    [keyWindow addSubview:_takePhotoView];
    [UIView animateWithDuration:0.5f animations:^{
        CGRect newTakePhotoViewFrame = _takePhotoView.frame;
        newTakePhotoViewFrame.origin.y -= newTakePhotoViewFrame.size.height+5;
        _takePhotoView.frame = newTakePhotoViewFrame;
    }];
    
}

- (void)previewChoosedPhotoAction:(UITapGestureRecognizer *)tapGes{
    UIImageView *imageView = (UIImageView *)tapGes.view;
    NSNumber *toIndex = [NSNumber numberWithInt:((int)imageView.tag - 101)];
    
    [self performSegueWithIdentifier:@"toImagesSegue" sender:toIndex];
}

- (IBAction)backAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
