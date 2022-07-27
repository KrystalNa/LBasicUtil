//
//  UIImage+Extension.m
//  Contract
//
//  Created by LN on 2019/9/4.
//  Copyright © 2019 LN. All rights reserved.
//

#import "UIImage+Extension.h"
#import <SDWebImage/SDImageCache.h>

@implementation UIImage (Extension)

+ (UIImage *)compressQualityWithImage:(UIImage *)image maxLimit:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    
    while (data.length > maxLength && compression > 0) {
        compression -= 0.05;
        data = UIImageJPEGRepresentation(image, compression);
    }
    
    return [[UIImage alloc] initWithData:data];
}

//+ (CGFloat)totalSizeOfImage:(UIImage *)image {
//    
//    CGImageRef cgimg = image.CGImage;
//    size_t bpp = CGImageGetBitsPerPixel(cgimg);
//    size_t bpc = CGImageGetBitsPerComponent(cgimg);
//    size_t bytesPerPixel = bpp / bpc;
//    
//   CGSize imageSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
//    CGFloat bytesPerRow = imageSize.height*imageSize.width * bytesPerPixel;
//    CGFloat totalBytes = bytesPerPixel * (UInt64)bytesPerRow;
//    return totalBytes;
//}

+ (void)saveImage:(UIImage *)image name:(NSString*)name {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@", name]];  // 保存文件的名称
    
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
//        DDLogDebug(@"保存成功");
    }
}

+ (BOOL)saveImage:(UIImage*)image withPath:(NSString*)path{

    BOOL result = [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    if (result) {
        //清除sd_image缓存，否则同名图片不更新
        NSString *filePath = [NSURL fileURLWithPath:path].absoluteString;
        [[SDImageCache sharedImageCache] removeImageForKey:filePath cacheType:SDImageCacheTypeAll completion:nil];
        return YES;
    }else{
        return NO;
    }
}



-(NSData *)compressWithLengthLimit:(NSUInteger)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}

- (NSData *)compressQualityWithLengthLimit:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    while (data.length > maxLength && compression > 0) {
        compression -= 0.05;
        data = UIImageJPEGRepresentation(self, compression); // When compression less than a value, this code dose not work
    }
    return data;
}


-(NSData *)compressMidQualityWithLengthLimit:(NSInteger)maxLength{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

-(NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength{
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return data;
}

/**
 *  根据image 返回放大或缩小之后的图片
 *
 *  @param image    原始图片
 *  @param multiple 放大倍数 0 ~ 2 之间
 *
 *  @return 新的image
 */
+ (UIImage *)createNewImageWithColor:(UIImage *)image multiple:(CGFloat)multiple
{
    CGFloat newMultiple = multiple;
    if (multiple == 0) {
        newMultiple = 1;
    }
    else if((fabs(multiple) > 0 && fabs(multiple) < 1) || (fabs(multiple)>1 && fabs(multiple)<2))
    {
        newMultiple = multiple;
    }
    else
    {
        newMultiple = 1;
    }
    CGFloat w = image.size.width*newMultiple;
    CGFloat h = image.size.height*newMultiple;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *tempImage = nil;
    CGRect imageFrame = CGRectMake(0, 0, w, h);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:0] addClip];
    [image drawInRect:imageFrame];
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempImage;
}

+ (UIImage *)imageWithColor:(UIColor*)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    [color set];

    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)createQRCodeWithStr:(NSString *)urlString size:(CGFloat) size
{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *image = [filter outputImage];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)fixOrientation:(UIImage *)image {
    
    CGFloat radian = 0;
    
    if (image.imageOrientation == UIImageOrientationRight) {
        radian = M_PI_2;
    }
    
    if (image.imageOrientation == UIImageOrientationLeft) {
        radian = -M_PI_2;
    }
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGAffineTransform rotatedTransform = CGAffineTransformRotate(CGAffineTransformIdentity, radian);
    
    CGRect rotatedRect = CGRectApplyAffineTransform(imageRect, rotatedTransform);
    rotatedRect.origin.x = 0;
    rotatedRect.origin.y = 0;
    
    UIGraphicsBeginImageContext(rotatedRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotatedRect.size.width / 2, rotatedRect.size
                          .height / 2);
    CGContextRotateCTM(context, radian);
    CGContextTranslateCTM(context, -image.size.width / 2, -image.size.height / 2);
    [image drawAtPoint:CGPointZero];
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return rotatedImage;
}

- (UIImage *)scaleTo480x640 {
    
    UIImage *newImg;
    
    CGFloat scaleWidth = 480.0;
    CGFloat scaleHeight = 640.0;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    
    UIGraphicsBeginImageContext(scaleSize);
    [self drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImg;
}

- (UIImage *)imageScale:(float)scale {
    
    UIImage *newImg;
    
    CGFloat scaleWidth = self.size.width*scale;
    CGFloat scaleHeight = self.size.height*scale;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    
    UIGraphicsBeginImageContext(scaleSize);
    [self drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImg;
}

@end
