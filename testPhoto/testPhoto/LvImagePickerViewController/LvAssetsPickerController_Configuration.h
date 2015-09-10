//
//  LvAssetsPickerController_Configuration.h
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

//#ifndef testPhoto_LvAssetsPickerController_Configuration_h
//#define testPhoto_LvAssetsPickerController_Configuration_h
//
//#endif
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^intBlock)(NSInteger);
typedef void (^voidBlock)(void);

#define kGroupViewCellIdentifier            @"groupViewCellIdentifier"
#define kAssetsViewCellIdentifier           @"AssetsViewCellIdentifer"
#define kAssetSupplementaryViewIdentifier   @"AssetsSupplementaryViewIdentifier"
#define kThumbnailLength     78.0f
#define kThumbnailSize  CGSizeMake(kThumbnailLength,kThumbnailLength)

#define kTagButtonClose 101
#define kTagButtonGroupPicker 102
#define kTagButtonDone 103
#define kTagNoAssetViewImageView 30
#define kTagNoAssetViewTitleLabel 31
#define kTagNoAssetViewMsgLabel 32

#define kGroupPickerViewCellLength 90

