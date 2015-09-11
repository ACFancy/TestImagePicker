//
//  PGAlbums.m
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "PGAlbums.h"

@implementation PGAlbums

- (instancetype)initWithAssetsGroup:(ALAssetsGroup *)aGroup{
    if (self = [super init]) {
        self.assetsGroup = aGroup;
        self.assetsArray = [NSMutableArray array];
    }
    return self;
}

- (UIImage *)posterImage{
    if (!self.assetsGroup) {
        return nil;
    }
    return [UIImage imageWithCGImage:[self.assetsGroup posterImage]];
}

- (CGImageRef)posterCGImage{
    if (!self.assetsGroup) {
        return nil;
    }
    return [self.assetsGroup posterImage];
}

- (NSInteger)totalCount{
    if (!self.assetsGroup) {
        return 0;
    }
    return self.assetsGroup.numberOfAssets;
}

- (NSString *)name{
    if (!self.assetsGroup) {
        return nil;
    }
    NSString *sGroupPropertyName = (NSString *)[self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if ([sGroupPropertyName isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else if([sGroupPropertyName isEqualToString:@"My Photo Stream"]){
        return @"我的照片流";
    }
    
    return sGroupPropertyName;
    
}

- (void)setFilter:(ALAssetsFilter *)filter{
    if (_filter != filter) {
        _filter = filter;
        [self.assetsGroup setAssetsFilter:_filter];
    }
}

- (BOOL )isEqual:(PGAlbums *)aAlbums{
    if (!aAlbums) {
        return NO;
    }
    if (![aAlbums isKindOfClass:[PGAlbums class]]) {
        return NO;
    }
    
    return [aAlbums.name isEqualToString:self.name];
}

@end
