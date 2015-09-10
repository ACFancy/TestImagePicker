//
//  PGAssetsPickerController.h
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class PGAssetsPickerController;
@protocol PGAssetsPickerControllerDelegate <NSObject>

- (void)PGAssetsPickerController:(PGAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
@optional
- (void)PGAssetsPickerControllerDidCancel:(PGAssetsPickerController *)picker;

@end

@interface PGAssetsPickerController : UIViewController

@property (nonatomic, strong)ALAssetsFilter *assetsFilter;
@property (nonatomic, assign) NSInteger maxinumNumberOfSelectionPhoto;

@property (nonatomic, weak)id <PGAssetsPickerControllerDelegate> delegate;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
