//
//  PGAsset.m
//  testPhoto
//
//  Created by ianc on 15/9/10.
//  Copyright (c) 2015年 PGWizard. All rights reserved.
//

#import "PGAsset.h"

@implementation PGAsset

- (instancetype)initWithAsset:(ALAsset *)asset{
    if (self = [super init]) {
        
        self.containAsset = asset;
        self.selected = NO;
    }
    return self;
}

- (BOOL)isEqual:(PGAsset *)asset{
    if (![asset isKindOfClass:[PGAsset class]]) {
        return  NO;
    }
    
    if (!asset) {
        return NO;
    }
    
    if (!self.containAsset || !asset.containAsset) {
        return NO;
    }
    
    //在同一个ALAssetsGroup实例，枚举出来的实例情况下是可以用来判断是否相等的
    return [self.url.absoluteString isEqualToString:asset.url.absoluteString];
}

- (BOOL)thImage:(UIImage *)theImage isEqual:(UIImage *)aImage{
    NSData *data1 = UIImagePNGRepresentation(theImage);
    NSData *data2 = UIImagePNGRepresentation(aImage);
    return [data1 isEqualToData:data2];
}

- (UIImage *)aspectRatioThumbnail{
    if (self.containAsset) {
        return [UIImage imageWithCGImage:[self.containAsset aspectRatioThumbnail]];
    }else{
        return nil;
    }
}

- (UIImage *)thumbnail{
    if (self.containAsset) {
        return  [UIImage imageWithCGImage:[self.containAsset thumbnail]];
    }else{
        return  nil;
    }
}

- (CGSize)imageSize{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [representation dimensions];
    }else{
        return CGSizeZero;
    }
}

- (UIImage *)fullResolutionImage{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        
        /* ALAsset 这张高清图要用这个进行翻转得到的才是正的图 */
        return [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1.0 orientation:(UIImageOrientation)[representation orientation]];
    }else{
        return nil;
    }
}

- (UIImage *)fullScreenImage{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [UIImage imageWithCGImage:[representation fullScreenImage]];
    }else{
        return nil;
    }
}


- (NSString *)fileName{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [representation filename];
    }else{
        return  nil;
    }
}

- (long long)size{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [representation size];
    }else{
        return 0;
    }
}

- (CGFloat)scale{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [representation scale];
    }else{
        return 0.0f;
    }
}

- (ALAssetOrientation)orientation{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [representation orientation];
    }else{
        return ALAssetOrientationUp;
    }
}

- (NSDictionary *)metaData{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [representation metadata];
    }else{
        return  nil;
    }
}

- (BOOL)isHaveBeenEdit{
    if (self.containAsset) {
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (systemVersion >= 8.0 || systemVersion <=5.0) {
            CGSize originalImageSize = CGSizeMake([self.containAsset.defaultRepresentation.metadata[@"PixelWidth"] floatValue], [self.containAsset.defaultRepresentation.metadata[@"PixelHeight"] floatValue]);
            CGFloat originScale = originalImageSize.width/originalImageSize.height;
            originScale = [[NSString stringWithFormat:@"%.2f",originScale] floatValue];
            
            CGFloat fullScreenScale = self.fullScreenImage.size.width/self.fullScreenImage.size.height;
            fullScreenScale = [[NSString stringWithFormat:@"%.2f",fullScreenScale] floatValue];
            
            return originScale == fullScreenScale?NO:YES;
        }else{
            return [self.containAsset.defaultRepresentation.metadata.allKeys containsObject:@"AdjustmentXMP"];
        }
    }else{
        return NO;
    }
}

//从图片裁减信息中截取出图片
- (UIImage *)getCropImageFromRepresentation:(ALAssetRepresentation *)representation{
    NSError *error;
    CGSize originalImageSize = CGSizeMake([representation.metadata[@"PixelWidth"] floatValue], [representation.metadata[@"PixelHeight"] floatValue]);
    
    NSData *xmpData = [representation.metadata[@"AdjustmentXMP"] dataUsingEncoding:NSUTF8StringEncoding];
    if (!xmpData) {
        return nil;
    }
    
    EAGLContext *myEAGContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    CIContext *context = [CIContext contextWithEAGLContext:myEAGContext options:@{kCIContextWorkingColorSpace:[NSNull null]}];
    CGImageRef img = [representation fullResolutionImage];
    CIImage *image = [CIImage imageWithCGImage:img];
    NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData inputImageExtent:image.extent error:&error];
    if (error) {
        return nil;
    }
    
    if (originalImageSize.width != CGImageGetWidth(img) || (originalImageSize.height != CGImageGetHeight(img))) {
        CGFloat zoom = MIN(originalImageSize.width/CGImageGetWidth(img), originalImageSize.height/CGImageGetHeight(img));
        BOOL translationFound = NO, cropFound = NO;
        for (CIFilter *filter in filterArray) {
            if ([filter.name isEqualToString:@"CIAffineTransform"] && !translationFound) {
                translationFound = YES;
                CGAffineTransform t = [[filter valueForKey:@"inputTransform"] CGAffineTransformValue];
                
                t.tx /= zoom;
                t.ty /= zoom;
                [filter setValue:[NSValue valueWithCGAffineTransform:t] forKey:@"inputTransform"];
            }
            
            if ([filter.name isEqualToString:@"CICrop"] && !cropFound) {
                cropFound = YES;
                CGRect r = [[filter valueForKey:@"inputRectangle"] CGRectValue];
                r.origin.x /= zoom;
                r.origin.y /= zoom;
                r.size.width /= zoom;
                r.size.height /= zoom;
                [filter setValue:[NSValue valueWithCGRect:r] forKey:@"inputRectangle"];
            }
            
        }
    }
    
    //filter chain
    for (CIFilter *filter in filterArray) {
        [filter setValue:image forKey:kCIInputImageKey];
        image = [filter outputImage];
    }
    
    //render
    CGImageRef editImageRef = [context createCGImage:image fromRect:image.extent];
    
    UIImage *editImage = [UIImage imageWithCGImage:editImageRef];
    
    //
    CGImageRelease(editImageRef);
    
    return  editImage;
}


- (UIImage *)correctImageOrentation:(UIImage *)originImage{
   //正确的方向
    if (originImage.imageOrientation == UIImageOrientationUp) {
        CGSize scaleSize = CGSizeMake(originImage.size.width, originImage.size.height);
        
        UIGraphicsBeginImageContext(scaleSize);
        
        //绘制改变大小的图片
       [originImage drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
        
        UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return scaleImage;
    }
    
    //错误的方向
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (originImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, originImage.size.width, originImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, originImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, -originImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (originImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, originImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, -1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, originImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
   
    CGContextRef ctx = CGBitmapContextCreate(NULL, originImage.size.width, originImage.size.height, CGImageGetBitsPerComponent(originImage.CGImage), 0, CGImageGetColorSpace(originImage.CGImage), CGImageGetBitmapInfo(originImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (originImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, originImage.size.width, originImage.size.height), originImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, originImage.size.width, originImage.size.height), originImage.CGImage);
            break;
    }
    
    //创建一张新图
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

//被裁减过的图片
- (UIImage *)editImage{
    if (self.isHaveBeenEdit) {
        CGFloat currentIOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (currentIOSVersion >= 8.0 || currentIOSVersion <= 5.0) {
            return self.fullScreenImage;
        }else{
           return [self getCropImageFromRepresentation:[self.containAsset defaultRepresentation]]? [self getCropImageFromRepresentation:[self.containAsset defaultRepresentation]]:self.fullScreenImage;
        }
    }
    
    return self.fullScreenImage;
}

- (NSURL *)url{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [representation url];
    }else{
        return nil;
    }
}

- (NSString *)uniqueIdentifier{
    if (self.containAsset) {
        ALAssetRepresentation *representation = [self.containAsset defaultRepresentation];
        return [representation UTI];
    }else{
        return nil;
    }
}


@end
