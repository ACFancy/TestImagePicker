//
//  PGAssetsPickerController.m
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "PGAssetsPickerController.h"
#import "PGAssetsViewCell.h"
#import "PGGroupPikcerView.h"
#import "PGAlbums.h"
#import "UIButton+BackColor.h"
#import "PGAssetPickerModel.h"

#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define kAssetsViewCellIdentifier           @"PGAssetsViewCellIdentifier"
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
typedef void (^voidBlock)(void);

@interface PGAssetsPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,PGGroupPickerViewDelegate>{
    NSMutableArray *selectedArray;
}
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageTitleView;
@property (weak, nonatomic) IBOutlet UIView *navigationTopView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PGGroupPikcerView *groupPickerView;

@property (nonatomic, strong) PGAlbums *albums;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *assets;


@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;

- (IBAction)backAction:(id)sender;
- (IBAction)btnTitleAction:(id)sender;
- (IBAction)btnDoneAction:(id)sender;

@end

@implementation PGAssetsPickerController

#pragma mark - ALAssetsLibrary
+ (ALAssetsLibrary *) defaultAssetsLibrary{
    static dispatch_once_t pre = 0;
    static ALAssetsLibrary *library= nil;
    dispatch_once(&pre, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (instancetype)init{
    self = [super initWithNibName:@"PGAssetsPickerController" bundle:nil];
    if (self) {
        self.view.translatesAutoresizingMaskIntoConstraints = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryUpdated:) name:ALAssetsLibraryChangedNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
    self.assetsLibrary = nil;
    self.albums = nil;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initVariable];
    
    __weak typeof(self) weakSelf = self;
    [self setupGroup:^{
        [weakSelf.groupPickerView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } withSetupAsset:YES];
    
    [self initLayout];
    
}

- (void)initVariable{
    self.assetsFilter = [ALAssetsFilter allPhotos];
    selectedArray = [NSMutableArray array];
    self.maximumNumberOfSelection = self.maxinumNumberOfSelectionPhoto;
    self.view.clipsToBounds = YES;
}

- (void)initLayout{
    
    //btnDone按钮状态
    [self.btnDone setBackgroundColor:Color(238, 238, 238, 1) forState:UIControlStateNormal];
    [self.btnDone setBackgroundColor:Color(255, 255, 255, 1) forState:UIControlStateHighlighted];
    
    //某一个相册的所有照片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = kThumbnailSize;
    layout.sectionInset = UIEdgeInsetsMake(1.0, 0, 0, 0);
    layout.minimumInteritemSpacing  = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    CGFloat collectionView_X = 0;
    CGFloat collectionView_Y = 64;
    CGFloat collectionView_W = [UIScreen mainScreen].bounds.size.width;
    CGFloat collectionView_H = [UIScreen mainScreen].bounds.size.height - self.navigationTopView.frame.size.height - self.bottomView.frame.size.height;
    CGRect collectionViewFrame = CGRectMake(collectionView_X, collectionView_Y, collectionView_W, collectionView_H);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[PGAssetsViewCell class] forCellWithReuseIdentifier:kAssetsViewCellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view insertSubview:self.collectionView atIndex:0];
    
    //相册选择图表视图
    __weak typeof(self) weakSelf = self;
    self.groupPickerView = [[PGGroupPikcerView alloc] initGroups:self.groups];
    self.groupPickerView.delegate = self;
    self.groupPickerView.blockTouchCell = ^(NSInteger row){
        [weakSelf changeGroup:row filter:weakSelf.assetsFilter];
    };
    
    [self.view insertSubview:self.groupPickerView aboveSubview:self.bottomView];
    [self.view bringSubviewToFront:self.navigationTopView];
    [self menuArrowRotate];
    
}

- (void)changeGroup:(NSInteger)item filter:(ALAssetsFilter *)filter{
    self.assetsFilter = filter;
    PGAlbums *tempalbums = (PGAlbums *)self.groups[item];
    self.albums = tempalbums;
    if (self.albums.assetsArray.count<=0) {
        [self initAssets:nil];
    }else{
        self.assets = [NSMutableArray arrayWithArray:self.albums.assetsArray];
    }

    [self.groupPickerView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:item inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.groupPickerView dismiss:YES];
    [self.btnTitle setTitle:self.albums.name forState:UIControlStateNormal];
    [self menuArrowRotate];
    [self reloadData];
}

//翻转
- (void)menuArrowRotate{
   [UIView animateWithDuration:0.35 animations:^{
       if (self.groupPickerView.isOpen) {
           self.imageTitleView.image = [UIImage imageNamed:@"PGAssetPickerController.bundle/pg_icon_arrow_up.png"];
       }else{
           self.imageTitleView.image = [UIImage imageNamed:@"PGAssetPickerController.bundle/pg_icon_arrow_down.png"];
       }
   } completion:nil];
}

//初始化某个相册中所有的照片
- (void)initAssets:(voidBlock)successBlock{
    if (!self.assets) {
        self.assets = [NSMutableArray array];
    }else{
        [self.assets removeAllObjects];
    }
    
    if (!self.albums) {
        
        PGAlbums *tempAblums = (PGAlbums *)self.groups[0];
        self.albums = tempAblums;
    }
    
    [self.albums setFilter:self.assetsFilter];
    NSInteger assetCount = self.albums.totalCount;
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset,NSUInteger index, BOOL *stop){
        if (asset) {
            PGAsset *tempAsset = [[PGAsset alloc] initWithAsset:asset];
            [self.assets addObject:tempAsset];
             self.albums.assetsArray = [NSMutableArray arrayWithArray:self.assets];
            
            NSString *type = [asset  valueForProperty:ALAssetPropertyType];
            if ([type isEqual:ALAssetTypePhoto]) {
                self.numberOfPhotos ++;
            }
        }else if( self.assets.count >= assetCount){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
                if (successBlock) {
                    successBlock();
                }
            });
        }
    };
    
    [self.albums.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:resultsBlock];
    
}

//重载数据
- (void)reloadData{
    [self.collectionView reloadData];
    //设置在这之前是否有选中的cell
    if (selectedArray.count) {
        for (PGAssetPickerModel *model in selectedArray) {
            int i = 0;
            for (PGAsset *temAset in self.assets) {
                PGAssetPickerModel *temM = [[PGAssetPickerModel alloc] init];
                temM.albumsName = self.albums.name;
                temM.photoName = temAset.fileName;
                if ([model isEqual:temM]) {
                    temAset.selected = model.selected;
                    if (model.selected) {
                        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                    }
                }
                i++;
            }
        }
    }
    [self setAssetsCount];
}

- (void)setAssetsCount{
    if (selectedArray.count) {
            [self.btnDone setTitle:[NSString stringWithFormat:@"完成( %lu )",(unsigned long)selectedArray.count] forState:UIControlStateNormal];
    }else{
        [self.btnDone setTitle:@"完成" forState:UIControlStateNormal];
    }

}

#pragma mark - Notification
- (void)assetsLibraryUpdated:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([notification.name isEqualToString:ALAssetsLibraryChangedNotification]) {
            NSDictionary *info = [notification userInfo];
            NSSet *updatedAssets = [info objectForKey:ALAssetLibraryUpdatedAssetsKey];
            NSSet *updatedAssetsGroup = [info objectForKey:ALAssetLibraryUpdatedAssetGroupsKey];
            NSSet *deletedAssetGroup = [info objectForKey:ALAssetLibraryDeletedAssetGroupsKey];
            NSSet *insertedAssetGroup = [info objectForKey:ALAssetLibraryInsertedAssetGroupsKey];
            
            if (notification.userInfo == nil) {
                //all Clear
                [self setupGroup:nil withSetupAsset:YES];
                return ;
            }
            
            if (insertedAssetGroup.count > 0 || deletedAssetGroup.count >0) {
                [self setupGroup:nil withSetupAsset:NO];
            }
            if (notification.userInfo.count == 0) {
                return ;
            }
            
            if (updatedAssets.count < 2 && updatedAssetsGroup.count == 0 && deletedAssetGroup.count == 0 && insertedAssetGroup.count == 0) {
                [self.assetsLibrary assetForURL:[updatedAssets allObjects][0] resultBlock:^(ALAsset *asset) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        PGAsset *tempAsset = self.assets[0];
                        if ([[[tempAsset.containAsset valueForKey:ALAssetPropertyAssetURL] absoluteString] isEqualToString:[[asset valueForKey:ALAssetPropertyAssetURL] absoluteString]]) {
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
                            [self.collectionView selectItemAtIndexPath:newPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                            [self setAssetsCount];
                        }
                    });
                } failureBlock:nil];
                return;
            }
           
            NSMutableArray *selectedItems = [NSMutableArray array];
            NSArray *selectedPath = self.collectionView.indexPathsForSelectedItems;
            for (NSIndexPath *idxPath in selectedPath) {
                [selectedItems addObject:[self.assets objectAtIndex:idxPath.row]];
            }
            
            NSInteger beforeAssets = self.assets.count;
            [self initAssets:^{
               
                for (PGAsset *item in selectedItems) {
                    for (PGAsset *asset in self.assets) {
                        if ([item isEqual:asset]) {
                            NSUInteger idx = [self.assets indexOfObject:asset];
                            NSIndexPath *newPath = [NSIndexPath indexPathForRow:idx inSection:0];
                            [self.collectionView selectItemAtIndexPath:newPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                        }
                    }
                }
                
                [self setAssetsCount];
                
                if (self.assets.count > beforeAssets) {
                    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
                }
                
            }];
            
        }
        
        
    });
}

//初始化每个相册
- (void)setupGroup:(voidBlock)endBlock withSetupAsset:(BOOL)doSetUpAsset{
    if (!self.assetsLibrary) {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (!self.groups) {
        self.groups = [NSMutableArray array];
    }else{
        [self.groups removeAllObjects];
    }
    
    __weak typeof(self) weakSelf = self;
    
    ALAssetsFilter *assetsFilter = [ALAssetsFilter allAssets];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [group setAssetsFilter:assetsFilter];
//            NSInteger groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
            NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
            if ([sGroupPropertyName isEqualToString:@"Camera Roll"]) {
                PGAlbums *tempAlbums = [[PGAlbums alloc] initWithAssetsGroup:group];
                
                [weakSelf.groups insertObject:tempAlbums atIndex:0];
                
                if (doSetUpAsset) {
                    weakSelf.albums = tempAlbums;
                    [weakSelf initAssets:nil];
                }
            }else{
                if (group.numberOfAssets > 0) {
                    PGAlbums *tempAlbums = [[PGAlbums alloc] initWithAssetsGroup:group];
//                    weakSelf.albums = tempAlbums;
                    [weakSelf.groups addObject:tempAlbums];
//                    [weakSelf initAssets:nil];
                }
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.groupPickerView reloadData];
                if (endBlock) {
                    endBlock();
                }
            });
            
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
      
        [self.btnTitle setTitle:@"" forState:UIControlStateNormal];
        self.imageTitleView.image = nil;
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:resultBlock failureBlock:failureBlock];
    
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = kAssetsViewCellIdentifier;
    PGAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PGAsset *tempAsset2 = (PGAsset *)[self.assets objectAtIndex:indexPath.row];
    [cell applyData:tempAsset2];
    return cell;
}

#pragma mark - CollectionView Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectedArray.count >= self.maxinumNumberOfSelectionPhoto) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"万万没想到" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    return selectedArray.count < self.maxinumNumberOfSelectionPhoto;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PGAsset *tempAsset = (PGAsset *)self.assets[indexPath.row];
    PGAssetPickerModel *pgModel = [[PGAssetPickerModel alloc] init];
    pgModel.albumsName = self.albums.name;
    pgModel.photoName = tempAsset.fileName;
    pgModel.asset = tempAsset;
    pgModel.selected = YES;
    tempAsset.selected = YES;
    if (selectedArray.count) {
        BOOL flag = NO;
        for (PGAssetPickerModel *temM in selectedArray) {
            if ([temM isEqual:pgModel]) {
                flag = YES;
                break;
            }
        }
        
        if (!flag) {
            [selectedArray addObject:pgModel];
        }
        
    }else{
        [selectedArray addObject:pgModel];
    }
    [self setAssetsCount];
//    [self setAssetsCountWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    PGAsset *tempAsset = (PGAsset *)self.assets[indexPath.row];
    
    PGAssetPickerModel *pgModel = [[PGAssetPickerModel alloc] init];
    pgModel.albumsName = self.albums.name;
    pgModel.photoName = tempAsset.fileName;
    pgModel.asset = tempAsset;
    pgModel.selected = NO;
    tempAsset.selected = NO;
    if (selectedArray.count) {

        for (PGAssetPickerModel *temM in selectedArray) {
            if ([temM isEqual:pgModel]) {
                [selectedArray removeObject:temM];
                break;
            }
        }
    }
    [self setAssetsCount];
//    [self setAssetsCountWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

#pragma mark - PGGroupPickerView Delegate
- (void)needToRotateMenu{
    [self menuArrowRotate];
}

#pragma mark - Private Method
- (void)finishPickingAssets{
    NSMutableArray *tassets = [[NSMutableArray alloc] init];
    for (PGAssetPickerModel *model in selectedArray) {
        [tassets addObject:model.asset];
    }
    
    if (tassets.count > 0) {
        PGAssetsPickerController *picker = (PGAssetsPickerController *)self;
        if ([picker.delegate respondsToSelector:@selector(PGAssetsPickerController:didFinishPickingAssets:)]) {
            [picker.delegate PGAssetsPickerController:picker didFinishPickingAssets:tassets];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

#pragma mark Action
- (IBAction)backAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(PGAssetsPickerControllerDidCancel:)]) {
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnTitleAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn isEqual:self.btnTitle]) {
        [self.groupPickerView toggle];
        [self menuArrowRotate];
        
    }
    
}

- (IBAction)btnDoneAction:(id)sender {
     [self finishPickingAssets];
}
@end
