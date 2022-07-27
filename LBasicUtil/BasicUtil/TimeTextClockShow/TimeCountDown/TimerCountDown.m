//
//  TimerCountDown.m
//  Mask-IOS
//
//  Created by LN on 2021/8/12.
//

#import "TimerCountDown.h"

@interface TimerCountDown ()
@property(nonatomic, assign) int initTimeCount;
@property (nonatomic, assign, readwrite) int timeCount;
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, strong) NSDate *enterBgDate;
@property(nonatomic, assign, readwrite) BOOL isCounting;
@property (nonatomic, assign, readwrite) BOOL isPause;

@end

@implementation TimerCountDown

static TimerCountDown *_sharedInstance;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (NSInteger)restartTimer{
    [self startTimerWithTotalTime:self.timeCount];
    return self.timeCount;
}

- (void)startTimerWithTotalTime:(NSTimeInterval)total {
    [self removeNotifiTurnOff];
    
    if (self.initTimeCount==0) {
        self.initTimeCount = total;
    }
    
    self.isPause = NO;
    self.isCounting = YES;
    
    self.timeCount = total;
    
    if (!self.countTimer) {
        self.countTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeCountAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];

        [self addObserver:self forKeyPath:@"timeCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }else{
        [self.countTimer setFireDate:[NSDate distantPast]];
    }
    
}

- (void)applicationDidEnterBackgroundNotification {
    self.enterBgDate = [NSDate date];
}

- (void)applicationWillEnterForegroundNotification {
    
    if (self.isCounting) {
        NSDate *curDate = [NSDate date];
        
        NSTimeInterval interval = [curDate timeIntervalSinceDate:self.enterBgDate];
        
        if (self.timeCount-interval > 0) {
            self.timeCount -= interval;
        }else {
            self.timeCount = 0;// rac通知停止计时器
        }
        
    }
}

- (void)stopTimer {
    if (self.countTimer == nil) {
        return;
    }
    self.isPause = NO;
    self.isCounting = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidEnterBackgroundNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationWillEnterForegroundNotification];
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    
    self.timeCount = self.initTimeCount;//重置倒计时到初始位置
    NSLog(@"销毁countTimer=%i",self.timeCount);
    
    [self removeObserver:self forKeyPath:@"timeCount"];
}

- (void)pauseTimer {
    if (self.countTimer == nil) {
        return;
    }
    
    self.isPause = YES;
    self.isCounting = NO;
    [self.countTimer setFireDate:[NSDate distantFuture]];
    
    [self addNotifiTurnOff];
}

- (void)timeCountAction {
    if (self.timeCount <= 0) {
        self.timeCount = 0;// rac通知停止计时器
        [self addNotifiTurnOff];
    }else {
        self.timeCount--;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
//    NSLog(@"old : %@  new : %@",[change objectForKey:@"old"],[change objectForKey:@"new"]);
    if (self.TimeChange) {
        
        self.TimeChange([[change objectForKey:@"new"] intValue]);
    }
    
    if ([[change objectForKey:@"new"] intValue]<=0) {
        [[TimerCountDown sharedInstance] stopTimer];
    }
    
}

#pragma mark - 添加：执行完任意模式或暂停超过3分钟通知关机
- (void)addNotifiTurnOff{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(notifiTurnOff) withObject:nil afterDelay:180];
    });
}

- (void)notifiTurnOff{
    if (self.NotifiTurnOff) {
        self.NotifiTurnOff(@"暂停超过3分钟！设备自动关机！",YES);
    }
}

- (void)removeNotifiTurnOff{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifiTurnOff) object:nil];
    });
}
@end
