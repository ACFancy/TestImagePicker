//
//  PGAlbums.h
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

/* 相册对象 */
@interface PGAlbums : NSObject

/* 实际的相册数据对象 */
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

/* 该相册实际的照片对象PGAsset数组，用来在第一次进入相册之后，就不用再次枚举统计 */
@property (nonatomic, strong) NSMutableArray *assetsArray;

/* 相册使用的类型过滤 */
@property (nonatomic, strong) ALAssetsFilter *filter;

/* 相册名字 */
@property (nonatomic, readonly, copy) NSString *name;

/* 相册中图片数量 */
@property (nonatomic, assign, readonly) NSInteger totalCount;

/* 相册的缩略图 */
@property (nonatomic, readonly, strong) UIImage *posterImage;

@property (nonatomic, readonly) CGImageRef posterCGImage;

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)aGroup;

- (BOOL)isEqual:(PGAlbums *)aAlbums;

@end
