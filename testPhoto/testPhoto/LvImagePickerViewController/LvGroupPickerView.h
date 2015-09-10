//
//  LvGroupPickerView.h
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LvAssetsPickerController_Configuration.h"
@interface LvGroupPickerView : UIView <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, copy) intBlock blockTouchCell;
@property (nonatomic, assign) BOOL isOpen;

- (instancetype)initWithGroups:(NSMutableArray *)groups;

- (void)show;
- (void)dismiss:(BOOL)animated;
- (void)toggle;
- (void)reloadData;

@end
