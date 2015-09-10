//
//  LvAssetsPickerController.h
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LvAssetsPickerController_Configuration.h"
@class  LvAssetsPickerController;
@protocol LvAssetsPickerControllerDelegate <NSObject>
- (void)LvAssetsPickerController:(LvAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
@optional
- (void)LVAssetsPickerControllerDidCancel:(LvAssetsPickerController *)picker;

@end


@interface LvAssetsPickerController : UIViewController

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionVideo;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionPhoto;

@property (nonatomic, assign) NSInteger maximumNumberOfSelectionMedia;

@property (nonatomic, weak) id <LvAssetsPickerControllerDelegate> delegate;
@end
