//
//  PGGroupViewCell.m
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "PGGroupViewCell.h"
#define kPGGroupViewCellHeight 80
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface PGGroupViewCell (){

    //相册缩略图
    UIImageView *_postImageView;
    //相册名称
    UILabel *_lblAlbumsName;
    //相册中照片数量
    UILabel *_lblAblumsPhotoNum;
    //下面的线条
    UIView *_linView;
    
}
@end

@implementation PGGroupViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout{
    //相册缩略图
    _postImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _postImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_postImageView];
    
    //相册名称
    _lblAlbumsName = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblAlbumsName.textAlignment = NSTextAlignmentLeft;
    _lblAlbumsName.font = [UIFont systemFontOfSize:15];
    _lblAlbumsName.textColor = Color(20, 28, 28, 1);
    [self.contentView addSubview:_lblAlbumsName];
    
    //相册照片数量
    _lblAblumsPhotoNum = [[UILabel alloc] initWithFrame:CGRectZero];
    _lblAblumsPhotoNum.textColor = NSTextAlignmentLeft;
    _lblAblumsPhotoNum.font = [UIFont systemFontOfSize:12];
    _lblAblumsPhotoNum.textColor = Color(157, 158, 159, 1);
    [self.contentView addSubview:_lblAblumsPhotoNum];
    
    //下面线条
    _linView = [[UIView alloc] initWithFrame:CGRectZero];
    _linView.backgroundColor = Color(238, 238, 238, 1);
    [self.contentView addSubview:_linView];
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}

- (void)applyData:(PGAlbums *)albums{
    self.albums = albums;
    CGImageRef posterImage = albums.posterCGImage;
    CGFloat height = CGImageGetHeight(posterImage);
    float scale = height / kPGGroupViewCellHeight;
    _postImageView.image = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    _lblAlbumsName.text = albums.name;
    _lblAblumsPhotoNum.text = [NSString stringWithFormat:@"%ld张",(long)albums.totalCount];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //相册缩略图
    CGFloat postImageView_X = 10;
    CGFloat postImageView_Y = 10;
    CGFloat postImageView_HW = 60;
    _postImageView.frame = CGRectMake(postImageView_X, postImageView_Y, postImageView_HW, postImageView_HW);
    
    //相册名称
    CGFloat lblAblumsName_X = postImageView_X + postImageView_HW + 8;
    CGFloat lblAblumsName_Y = postImageView_Y + 5;
    CGFloat lblAblumsName_H = 30;
    CGFloat lblAblumsName_W = self.frame.size.width - lblAblumsName_X - 5;
    _lblAlbumsName.frame = CGRectMake(lblAblumsName_X, lblAblumsName_Y, lblAblumsName_W, lblAblumsName_H);
    
    //相册数量
    CGFloat lblNum_Y = lblAblumsName_Y + lblAblumsName_H + 5;
    CGFloat lblNum_X = lblAblumsName_X;
    CGFloat lblNum_H = 15;
    CGFloat lblNum_W = lblAblumsName_W;
    _lblAblumsPhotoNum.frame = CGRectMake(lblNum_X, lblNum_Y, lblNum_W, lblNum_H);
    
    //下面线条
    CGFloat line_Y = self.frame.size.height - 1;
    CGFloat line_X = 5;
    CGFloat line_H = 1;
    CGFloat line_W = self.frame.size.width - 2*line_X;
    _linView.frame = CGRectMake(line_X, line_Y, line_W, line_H);
    
}


@end
