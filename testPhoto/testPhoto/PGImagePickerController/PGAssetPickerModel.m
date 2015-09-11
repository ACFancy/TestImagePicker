//
//  PGAssetPickerModel.m
//  testPhoto
//
//  Created by ianc on 15/9/11.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "PGAssetPickerModel.h"

@implementation PGAssetPickerModel

- (BOOL)isEqual:(PGAssetPickerModel *)model{
    if (self && model) {
        if([self.albumsName isEqualToString:model.albumsName] && [self.photoName isEqualToString:model.photoName]) {
            return YES;
        }
    }else{
        return NO;
    }
    return NO;
}

@end
