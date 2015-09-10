//
//  LvWrapperPickerController.m
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "LvWrapperPickerController.h"

@implementation LvWrapperPickerController

#pragma mark - ViewController Setting/Rotate
- (BOOL)shouldAutorotate{
    return  YES;
}

- (UIViewController *)childViewControllerForStatusBarHidden{
    return nil;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


@end
