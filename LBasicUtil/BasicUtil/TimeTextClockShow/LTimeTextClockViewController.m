//
//  LTimeTextClockViewController.m
//  LBasicUtil
//
//  Created by LN on 2021/9/6.
//

#import "LTimeTextClockViewController.h"
#import "TimerCountDown.h"

@interface LTimeTextClockViewController ()
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UILabel * countDownLabel;
@end

@implementation LTimeTextClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *countDownText = [[UILabel alloc] init];
    countDownText.textAlignment = NSTextAlignmentCenter;
    [countDownText setFont:[UIFont systemFontOfSize:17]];
    countDownText.textColor = [UIColor blackColor];
    [countDownText setText:@"倒计时"];
    [countDownText sizeToFit];
    [self.view addSubview:countDownText];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 60, 60)];
    [playButton setBackgroundColor:[UIColor blueColor]];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playButton setTitle:@"开始" forState:UIControlStateNormal];
    [playButton setTitle:@"停止" forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(playButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    self.playButton = playButton;
    
    
    _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 200, 40)];
    _countDownLabel.text = [NSDate convertSecondToHMSStr:[TimerCountDown sharedInstance].timeCount];;
    [_countDownLabel setFont:[UIFont systemFontOfSize:40 weight:UIFontWeightBold]];
    _countDownLabel.textColor = [UIColor blackColor];
    [self.view addSubview:_countDownLabel];
    
    
    
    __weak __typeof(self)weakSelf = self;
    [[TimerCountDown sharedInstance] setTimeChange:^(int timeSecondCount) {
        weakSelf.countDownLabel.text = [NSDate convertSecondToHMSStr:timeSecondCount];

        if (timeSecondCount == 0 ) {
            [weakSelf.playButton setSelected:NO];
        }
    }];
    
}

- (void)playButtonOnClicked:(UIButton *)sender{
    if (!sender.isSelected) {

        [sender setSelected:!sender.isSelected];
        [[TimerCountDown sharedInstance] startTimerWithTotalTime:60*60];
        
    }else{
        NSLog(@"点击了结束按钮");
        [sender setSelected:!sender.isSelected];
        
        [[TimerCountDown sharedInstance] stopTimer];
    }
}

@end
