//
//  NSString+Extension.h
//  LBasicUtil
//
//  Created by LN on 2021/9/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)
/**
 * 根据filePath创建文件夹，并返回filePath
 * @params filePath 传入的沙盒文件夹路径
 * @return 返回filePath即传入的文件夹路径
 */
+ (NSString *)createSrcPath:(NSString *)filePath;


@end

NS_ASSUME_NONNULL_END
