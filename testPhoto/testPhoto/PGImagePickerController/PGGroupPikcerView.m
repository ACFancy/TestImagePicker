//
//  PGGroupPikcerView.m
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "PGGroupPikcerView.h"
#import "PGGroupViewCell.h"
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define NavigationHeight 64
#define kPGGroupViewCellHeight 80
#define BounceAnimationPixel 5
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface PGGroupPikcerView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PGGroupPikcerView

- (instancetype)initGroups:(NSMutableArray *)groups{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.groups = groups;
        [self initLayout];
        [self addObserver:self forKeyPath:@"PGgroups" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"PGgroups"];
}

- (void)initLayout{
    //自身属性的设置
    CGFloat selfView_X = 0;
    CGFloat selfView_Y = - SCREEN_HEIGHT;
    CGFloat selfView_H = SCREEN_HEIGHT;
    CGFloat selfView_W = SCREEN_WIDTH;
    self.frame = CGRectMake(selfView_X, selfView_Y, selfView_W, selfView_H);
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    self.backgroundColor = Color(.16, .17, .21, .5);
    UITapGestureRecognizer *selfTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otherDismissAction:)];
    selfTap.numberOfTouchesRequired = 1;
    selfTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:selfTap];
    
    //tableView的设置
    CGFloat tableView_X = 0;
    CGFloat tableView_Y = NavigationHeight;
    CGFloat tableView_W = SCREEN_WIDTH;
    CGFloat tableView_H = (SCREEN_HEIGHT*2/3.0)-NavigationHeight;
    CGRect tableViewFrame = CGRectMake(tableView_X, tableView_Y, tableView_W, tableView_H);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource =  self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = kPGGroupViewCellHeight;
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
}

- (void)show{
      [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
          CGRect newFrame = self.frame;
          newFrame.origin.y = BounceAnimationPixel;
          self.frame = newFrame;
      } completion:^(BOOL finished) {
          [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
              CGRect newFrame = self.frame;
              newFrame.origin.y = 0;
              self.frame = newFrame;
          } completion:^(BOOL finished) {
              
          }];
      }];
    self.isOpen = YES;
}
- (void)dismiss:(BOOL)animated{
    if (!animated) {
        CGRect newFrame = self.frame;
        newFrame.origin.y = - newFrame.size.height;
        self.frame = newFrame;
    }else{
      [UIView animateWithDuration:0.3f animations:^{
          CGRect newFrame = self.frame;
          newFrame.origin.y = - newFrame.size.height;
          self.frame = newFrame;
      }];
    }
    self.isOpen = NO;
}
- (void)toggle{
    if (self.frame.origin.y < 0) {
        [self show];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }else{
        [self dismiss:YES];
    }
}
- (void)reloadData{
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"kPGGroupViewCell";
    
    PGGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PGGroupViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PGAlbums *albums = (PGAlbums *)self.groups[indexPath.row];
    [cell applyData:albums];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kPGGroupViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.blockTouchCell) {
        self.blockTouchCell(indexPath.row);
        
//        [self performSelector:@selector(deselectedTableViewCellWithIndexPath:) withObject:indexPath afterDelay:1];
    }
}

- (void)deselectedTableViewCellWithIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action
- (void)otherDismissAction:(UITapGestureRecognizer *)tapGesture{
    if(CGRectContainsPoint(self.frame, [tapGesture locationInView:self])){
        CGPoint touchPoint = [tapGesture locationInView:self];
        if (touchPoint.y >(SCREEN_HEIGHT*2/3.0) ) {
            [self dismiss:YES];
        }

    }
    
    
}


@end
