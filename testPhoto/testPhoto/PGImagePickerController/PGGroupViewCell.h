//
//  PGGroupViewCell.h
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAlbums.h"

@interface PGGroupViewCell : UITableViewCell

@property (nonatomic, strong)PGAlbums *albums;

- (void)applyData:(PGAlbums *)albums;

@end
