//
//  TimerCountDown.h
//  Mask-IOS
//
//  Created by LN on 2021/8/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerCountDown : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, assign, readonly) int timeCount;
@property(nonatomic, copy) void (^TimeChange)(int timeSecondCount);

@property (nonatomic, assign, readonly) BOOL isCounting;
@property (nonatomic, assign, readonly) BOOL isPause;

/** 执行完任意模式或暂停超过3分钟通知关机*/
@property(nonatomic, copy) void (^NotifiTurnOff)(NSString * _Nullable showText, BOOL isActiveTurnOff);

- (void)startTimerWithTotalTime:(NSTimeInterval)total;
- (NSInteger)restartTimer;
- (void)stopTimer;
- (void)pauseTimer;

@end

NS_ASSUME_NONNULL_END
