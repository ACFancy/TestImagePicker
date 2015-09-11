//
//  ImagesViewController.h
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewControllerDelegate <NSObject>

@optional
- (void)updateUIWithSoureImages:(NSMutableArray *)sourceImages;

@end

@interface ImagesViewController : UIViewController


@property (nonatomic, strong) NSMutableArray *sourceImages;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, weak)id<ImageViewControllerDelegate>delegate;

@end
