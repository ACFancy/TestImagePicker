//
//  PGAssetPickerModel.h
//  testPhoto
//
//  Created by ianc on 15/9/11.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PGAsset;
@interface PGAssetPickerModel : NSObject

@property (nonatomic, copy) NSString *albumsName;
@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, strong)PGAsset *asset;
@property (nonatomic, assign) BOOL selected;

- (BOOL)isEqual:(PGAssetPickerModel *)model;

@end
