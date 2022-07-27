//
//  NSString+Date.h
//  InvigilationSystem
//
//  Created by LN on 2020/3/27.
//  Copyright © 2020 Raintai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (time)

+ (NSString *)currentTime;
+ (NSString *)currentTimestamp;
+ (NSString *)timeWithTimeStamp:(NSString *)string timeZone:(NSString *)timeZone;
+ (NSDate *)cnDateFromDateStr:(NSString *)dateStr;
+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp;
+ (NSString *)cnDateStrFromTimeStamp:(NSString *)timeStamp;
/**
 * 根据秒计算转化为 00:00格式的 NSString
 * @params second 秒
 * @return 返回 00:00 格式的字符串
 */
+ (NSString *)convertSecondToMS:(NSInteger)second;

/**
 * 根据秒计算转化为 00:00:00格式的 NSString
 * @params second 秒
 * @return 返回 00:00:00 格式的字符串
 */
+ (NSString *)convertSecondToHMSStr:(int)sCount;
@end

NS_ASSUME_NONNULL_END
