//
//  PGAsset.h
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

/* 照片对象 */
@interface PGAsset : NSObject

/* 真实的Asset对象 */
@property (nonatomic, strong) ALAsset *containAsset;

/* 照片是否选中 */
@property (nonatomic, assign) BOOL selected;

/* 等比例缩略图 */
@property (nonatomic, readonly) UIImage *aspectRatioThumbnail;

/* 缩略图 */
@property (nonatomic, readonly) UIImage *thumbnail;

/* 图片大小 */
@property (nonatomic, readonly) CGSize imageSize;

/* 高清图片 */
@property (nonatomic, readonly) UIImage *fullResolutionImage;

/* 全屏图片 */
@property (nonatomic, readonly) UIImage *fullScreenImage;

/* 图片文件名字 */
@property (nonatomic, readonly, copy) NSString *fileName;

/* 缩放倍数 */
@property (nonatomic, readonly, assign) CGFloat scale;

/* 占用内存大小 */
@property (nonatomic, readonly) long long size;

/*  倾斜方向 */
@property (nonatomic, readonly) ALAssetOrientation orientation;

/* 原始数据 */
@property (nonatomic, readonly) NSDictionary *metaData;

/* 是否已经被剪裁 */
@property (nonatomic, assign, readonly) BOOL isHaveBeenEdit;

/* 被裁减过的图片 */
@property (nonatomic, readonly, strong) UIImage *editImage;

/* 图片的路径，和ALAssetPropertyAssetUrl 取到的是一样的 */
@property (nonatomic, readonly) NSURL *url;

/* 图片的唯一标识符 */
@property (nonatomic, readonly) NSString *uniqueIdentifier;

- (instancetype)initWithAsset:(ALAsset *)asset;

- (BOOL)isEqual:(PGAsset *)asset;

@end
