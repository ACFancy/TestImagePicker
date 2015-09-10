//
//  LvGroupPickerView.m
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "LvGroupPickerView.h"
#import "LvGroupViewCell.h"

#define BounceAnimationPixel 5
#define NavigationHeight 64
@implementation LvGroupPickerView

- (instancetype)initWithGroups:(NSMutableArray *)groups{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        //init
        self.groups = groups;
        [self setupLayout];
        [self setupTableView];
        [self addObserver:self forKeyPath:@"groups" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"groups"];
}

- (void)setupLayout{
    self.frame = CGRectMake(0, - ([UIScreen mainScreen].bounds.size.height/2.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2.0);
    self.layer.cornerRadius = 4.0f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationHeight, [UIScreen mainScreen].bounds.size.width,self.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = kGroupPickerViewCellLength;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.tableView];
}

- (void)reloadData{
    [self.tableView reloadData];
}

- (void)show{
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = CGRectMake(0, BounceAnimationPixel, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f delay:0.f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
    self.isOpen = YES;
}

- (void)dismiss:(BOOL)animated{
    if (!animated) {
        self.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height/2.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2.0);
    }else{
       [UIView animateWithDuration:0.3f animations:^{
           self.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height/2.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2.0);
       } completion:^(BOOL finished) {
           
       }];
    }
    self.isOpen = NO;
}

- (void)toggle{
    if (self.frame.origin.y < 0) {
        [self show];
    }else{
        [self dismiss:YES];
    }
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"kGroupViewCellIdentifier";
    
    LvGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LvGroupViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell applyData:[self.groups objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableVIew Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kGroupPickerViewCellLength;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.blockTouchCell) {
        self.blockTouchCell(indexPath.row);
    }
}

@end
