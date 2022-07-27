//
//  NSString+Extension.m
//  LBasicUtil
//
//  Created by LN on 2021/9/2.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+ (NSString *)createSrcPath:(NSString *)filePath {
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return filePath;
}


@end
