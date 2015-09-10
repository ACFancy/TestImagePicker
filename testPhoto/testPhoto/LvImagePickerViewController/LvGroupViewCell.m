//
//  LvGroupViewCell.m
//  testPhoto
//
//  Created by ianc on 15/9/9.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "LvGroupViewCell.h"

@implementation LvGroupViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //init
        self.textLabel.font = [UIFont  fontWithName:@"AppleSDGothicNeo-Medium" size:17];
        self.detailTextLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:11];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"X.png"]];
        self.selectedBackgroundView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.accessoryView.hidden = NO;
    }else{
        self.accessoryView.hidden = YES;
    }
}

- (void)applyData:(ALAssetsGroup *)assetsGroup{
    self.assetsGroup = assetsGroup;
    CGImageRef posterImage = assetsGroup.posterImage;
    size_t height = CGImageGetHeight(posterImage);
    float scale = height / kThumbnailLength;
    self.imageView.image = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%ld张",(long)[assetsGroup numberOfAssets]];
}

@end
