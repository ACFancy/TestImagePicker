//
//  PGAssetsViewCell.m
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "PGAssetsViewCell.h"

#define kThumbnailLength    78.0f

@interface PGAssetsViewCell ()

@property (nonatomic, strong) PGAsset *asset;
@property (nonatomic, strong) UIImage *image;

@end

@implementation PGAssetsViewCell

static UIImage *checkedIcon;
static UIImage *uncheckedIcon;
static UIColor *selectedColor;

+ (void)initialize{
    checkedIcon = [UIImage imageNamed:@"PGAssetPickerController.bundle/pg_icon_chk_normal.png"];
    uncheckedIcon = [UIImage imageNamed:@"PGAssetPickerController.bundle/pg_icon_chk_active.png"];
    selectedColor = [UIColor colorWithWhite:1 alpha:0.3];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
    }
    return self;
}

- (void)applyData:(PGAsset *)asset{
    self.asset = asset;
    self.image = asset.thumbnail;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self setNeedsDisplay];
    
    self.asset.selected = selected;
    
    if (selected) {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeScale(0.97, 0.97);
        } completion:^(BOOL finished) {
           [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
               self.transform = CGAffineTransformIdentity;
           } completion:nil];
        }];
    }else{
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeScale(1.03, 1.03);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
  
    }
}

- (void)drawRect:(CGRect)rect{
    [self.image drawInRect:CGRectMake(0, 0, kThumbnailLength, kThumbnailLength)];
    if (self.selected) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, selectedColor.CGColor);
        CGContextFillRect(context, rect);
        [checkedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect)-checkedIcon.size.width-2, CGRectGetMinY(rect)+2)];
    }else{
        [uncheckedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect)-uncheckedIcon.size.width-2, CGRectGetMinY(rect)+2)];
    }
}

@end
