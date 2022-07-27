//
//  LSLiderViewController.m
//  LBasicUtil
//
//  Created by LN on 2021/9/7.
//

#import "LSLiderViewController.h"
#import "IACircularSlider.h"
#import "TimerCountDown.h"
#import "NSDate+time.h"

@interface LSLiderViewController ()
@property(nonatomic, strong) IACircularSlider *circleSlider;
@property(nonatomic, strong) UIButton *beginBtn;
@property (nonatomic, strong) UILabel *timeLabel;


@property(nonatomic, strong) UISlider *slider1;
@property(nonatomic, strong) UISlider *slider2;
@property(nonatomic, strong) UISwitch *switchBtn;
@property(nonatomic, strong) UISlider *slider3;
@property(nonatomic, strong) UISlider *slider4;
@end

@implementation LSLiderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.circleSlider];
    [self.view addSubview:self.beginBtn];
    [self.view addSubview:self.timeLabel];

    [self.view addSubview:self.slider1];
    [self.view addSubview:self.slider2];
    [self.view addSubview:self.switchBtn];
    [self.view addSubview:self.slider3];
    [self.view addSubview:self.slider4];
    
    self.timeLabel.text = [NSDate convertSecondToHMSStr:self.circleSlider.maximumValue];
    
    __weak __typeof(self)weakSelf = self;
    [[TimerCountDown sharedInstance] setTimeChange:^(int timeSecondCount) {
        weakSelf.timeLabel.text = [NSDate convertSecondToHMSStr:timeSecondCount];
        [weakSelf.circleSlider updateProgressWithValue:timeSecondCount];
        if (timeSecondCount == 0 ) {
            [weakSelf.beginBtn setSelected:NO];
        }
    }];
    

    
}

- (void)viewDidLayoutSubviews{
//    [self.circleSlider setFrame:CGRectMake(100, 100, 200, 200)];
    [self.timeLabel setCenter:CGPointMake(CGRectGetMidX(_circleSlider.frame), CGRectGetMidY(_circleSlider.frame))];
}

#pragma mark - 控件懒加载
- (IACircularSlider *)circleSlider{
    if (_circleSlider==nil) {
        _circleSlider = [[IACircularSlider alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
        _circleSlider.trackHighlightedTintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        _circleSlider.thumbTintColor = [UIColor whiteColor];
        _circleSlider.trackTintColor = [UIColor blueColor];
        _circleSlider.thumbHighlightedTintColor = [UIColor whiteColor];
        _circleSlider.trackWidth = 12.5f;
        _circleSlider.thumbWidth = 25.0f;
        _circleSlider.maximumValue = 60;
        _circleSlider.minimumValue = 0.0f;
        _circleSlider.spaceValue = 1;
        _circleSlider.startAngle = M_PI;
        _circleSlider.endAngle = 0;
        _circleSlider.clockwise = YES;
        [_circleSlider updateProgressWithValue:_circleSlider.maximumValue];
        
        CGPoint start = CGPointMake(0, 0);
        CGPoint end = CGPointMake(200, 0);
        
        [_circleSlider setGradientColorForHighlightedTrackWithFirstColor:[UIColor colorWithRed:229.0/255.0f green:172.0/255.0f blue:168.0f/255.0f alpha:1.0f] secondColor:[UIColor colorWithRed:229.0/255.0f green:172.0/255.0f blue:168.0f/255.0f alpha:1.0f] colorsLocations:CGPointMake(0.1, 1.0) startPoint:start andEndPoint:end];
        
        [_circleSlider addTarget:self action:@selector(handleValue:) forControlEvents:UIControlEventValueChanged];
    
    }
    return _circleSlider;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"00:00:00";
        _timeLabel.textColor = [UIColor blueColor];
        _timeLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        [_timeLabel sizeToFit];
        _timeLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_timeLabel.frame)+10, CGRectGetHeight(_timeLabel.frame)+10);
    }
    return _timeLabel;
}

- (UIButton *)beginBtn{
    if (_beginBtn == nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 100, 50)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor blueColor]];
        [btn setTitle:@"开始倒计时" forState:UIControlStateNormal];
        [btn setTitle:@"结束倒计时" forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(beginOrStopCountdown:) forControlEvents:UIControlEventTouchUpInside];
        _beginBtn = btn;
    }
    return _beginBtn;
}

- (void)beginOrStopCountdown:(UIButton *)sender{
    [sender setSelected:!sender.isSelected];
    if (sender.isSelected) {
        NSTimeInterval secound = self.circleSlider.value;
        [[TimerCountDown sharedInstance] startTimerWithTotalTime:secound];
    }else{
        [[TimerCountDown sharedInstance] stopTimer];
    }
}

- (void)handleValue:(IACircularSlider*)circleSlider{
    if (self.beginBtn.isSelected) {
        [self beginOrStopCountdown:self.beginBtn];
    }
    int timeCount = circleSlider.value;
    self.timeLabel.text = [NSDate convertSecondToHMSStr:timeCount];
}

#pragma mark - 下半部调整进度方法
- (UISlider *)slider1{
    if (_slider1==nil) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 400, 200, 50)];
        [slider addTarget:self action:@selector(trackW:) forControlEvents:UIControlEventValueChanged];
        slider.minimumValue = 1;
        slider.maximumValue = 50;
        _slider1 = slider;
    }
    return _slider1;
}

- (UISlider *)slider2{
    if (_slider2==nil) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 460, 200, 50)];
        [slider addTarget:self action:@selector(thumbWidth:) forControlEvents:UIControlEventValueChanged];
        slider.minimumValue = 1;
        slider.maximumValue = 50;
        _slider2 = slider;
    }
    return _slider2;
}

- (UISwitch *)switchBtn{
    if (_switchBtn == nil) {
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(10, 520, 100, 50)];
        [_switchBtn addTarget:self action:@selector(switch1:) forControlEvents:UIControlEventValueChanged];
        [_switchBtn setOn:YES];
    }
    return _switchBtn;
}

- (UISlider *)slider3{
    if (_slider3==nil) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 580, 200, 50)];
        [slider addTarget:self action:@selector(topChanged:) forControlEvents:UIControlEventValueChanged];
        slider.minimumValue = 0;
        slider.maximumValue = 6.28;
        _slider3 = slider;
    }
    return _slider3;
}

- (UISlider *)slider4{
    if (_slider4==nil) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 640, 200, 50)];
        [slider addTarget:self action:@selector(botChanged:) forControlEvents:UIControlEventValueChanged];
        slider.minimumValue = 0;
        slider.maximumValue = 6.28;
        _slider4 = slider;
    }
    return _slider4;
}



- (void)trackW:(UISlider *)sender {
    _circleSlider.trackWidth = sender.value;
}

- (void)thumbWidth:(UISlider *)sender {
    _circleSlider.thumbWidth = sender.value;
}

- (void)switch1:(UISwitch *)sender {
    self.circleSlider.clockwise = sender.isOn;
}

- (void)topChanged:(UISlider *)sender {
    self.circleSlider.endAngle = sender.value;
}
- (void)botChanged:(UISlider *)sender {
    self.circleSlider.startAngle = sender.value;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

