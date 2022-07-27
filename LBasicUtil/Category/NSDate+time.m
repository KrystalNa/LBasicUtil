//
//  NSString+Date.m
//  InvigilationSystem
//
//  Created by LN on 2020/3/27.
//  Copyright © 2020 Raintai. All rights reserved.
//

#import "NSDate+time.h"

@implementation NSDate (Date)

+ (NSString *)currentTime {
    
   NSDate *date = [NSDate date];

   NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
   [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"shanghai"]];
   NSString *timeStr = [dateFormat stringFromDate:date];

    return timeStr;
}

+ (NSString *)currentTimestamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval= [date timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", timeInterval*1000];//转为字符型

    return timeString;
}

+ (NSString *)timeWithTimeStamp:(NSString *)string timeZone:(NSString *)timeZone {
    NSInteger t_integer = [string integerValue] / 1000;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:t_integer];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //格式化成目标时间格式
    [formatter setDateFormat:@"HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    NSString   *timeString  = [formatter stringFromDate:date];

    return  timeString;
}

+ (NSDate *)cnDateFromDateStr:(NSString *)dateStr {

    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"shanghai"]];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}

+ (NSDate *)dateFromTimeStamp:(NSString *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timeStamp.longLongValue)*0.001];
    return date;
}

+ (NSString *)cnDateStrFromTimeStamp:(NSString *)timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timeStamp.longLongValue)*0.001];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
     [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"shanghai"]];
    NSString *timeStr = [dateFormat stringFromDate:date];
    return timeStr;
}


#pragma mark - 秒转字符串格式
+ (NSString *)convertSecondToMS:(NSInteger)second{
    NSInteger sCount = second;
    NSInteger m = sCount / 60;
    sCount = sCount % 60;
    NSInteger s = sCount;
    return [NSString stringWithFormat:@"%02ld:%02ld",m,s];
}

+ (NSString *)convertSecondToHMSStr:(int)second {
    int d = second / (3600*24);
    second = second % (3600*24);
    int h = second / 3600;
    second = second % 3600;
    int m = second / 60;
    second = second % 60;
    int s = second;
    NSString *temp;
    if (d > 0) {
        
        temp = [NSString stringWithFormat:@"%d%@ %02d:%02d:%02d", d, NSLocalizedString(@"天", nil),h, m, s];
    }else {
        temp = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    }
    return temp;
}

@end
