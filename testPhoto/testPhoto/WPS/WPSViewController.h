//
//  WPSViewController.h
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPSViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@property (nonatomic, strong) NSMutableArray *sourceimages;

- (IBAction)backAction:(UIBarButtonItem *)sender;
@end
