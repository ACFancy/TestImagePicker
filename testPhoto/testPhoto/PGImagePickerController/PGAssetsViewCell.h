//
//  PGAssetsViewCell.h
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAsset.h"
#define kThumbnailLength    ([UIScreen mainScreen].bounds.size.width-6)/4.0

@interface PGAssetsViewCell : UICollectionViewCell

- (void)applyData:(PGAsset *)asset;

@end
