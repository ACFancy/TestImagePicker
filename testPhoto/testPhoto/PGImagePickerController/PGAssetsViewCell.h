//
//  PGAssetsViewCell.h
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAsset.h"
#define kThumbnailLength    78.0f

@interface PGAssetsViewCell : UICollectionViewCell

- (void)applyData:(PGAsset *)asset;

@end
