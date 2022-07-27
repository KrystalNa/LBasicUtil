//
//  UIImage+Extension.h
//  Contract
//
//  Created by LN on 2019/9/4.
//  Copyright © 2019 LN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

+ (UIImage *)compressQualityWithImage:(UIImage *)image maxLimit:(NSInteger)maxLength;
 

+ (BOOL)saveImage:(UIImage*)image withPath:(NSString*)path;
/*
 *  压缩图片方法(先压缩质量再压缩尺寸)
 */
-(NSData *)compressWithLengthLimit:(NSUInteger)maxLength;
/*
 *  压缩图片方法(压缩质量)
 */
-(NSData *)compressQualityWithLengthLimit:(NSInteger)maxLength;
/*
 *  压缩图片方法(压缩质量二分法)
 */
-(NSData *)compressMidQualityWithLengthLimit:(NSInteger)maxLength;
/*
 *  压缩图片方法(压缩尺寸)
 */
-(NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength;


+ (UIImage *)createNewImageWithColor:(UIImage *)image multiple:(CGFloat)multiple;
+ (UIImage *)imageWithColor:(UIColor*)color;
+ (UIImage *)createQRCodeWithStr:(NSString *)urlString size:(CGFloat) size;

+ (UIImage *)fixOrientation:(UIImage *)image;
- (UIImage *)imageScale:(float)scale;
- (UIImage *)scaleTo480x640;

@end

NS_ASSUME_NONNULL_END
