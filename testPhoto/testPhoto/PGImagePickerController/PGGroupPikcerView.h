//
//  PGGroupPikcerView.h
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^intBlock)(NSInteger);

@protocol PGGroupPickerViewDelegate <NSObject>

@optional
- (void)needToRotateMenu;

@end

@interface PGGroupPikcerView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, copy) intBlock blockTouchCell;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) id <PGGroupPickerViewDelegate> delegate;

- (instancetype)initGroups:(NSMutableArray *)groups;

- (void)show;
- (void)dismiss:(BOOL)animated;
- (void)toggle;
- (void)reloadData;

@end
