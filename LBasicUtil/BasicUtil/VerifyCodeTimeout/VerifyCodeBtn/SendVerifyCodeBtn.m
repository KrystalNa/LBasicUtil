//
//  SendVerifyCodeBtn.m
//  Mask-IOS
//
//  Created by LN on 2021/8/18.
//

#import "SendVerifyCodeBtn.h"

@interface SendVerifyCodeBtn()
{
    NSInteger countSecond;
    NSTimer *countDownTimer;
}
@property(nonatomic, strong) UIButton *sendBtn;
@end

@implementation SendVerifyCodeBtn

- (void)setIsEnabled:(BOOL)isEnabled{
    _isEnabled = isEnabled;
    
    if (self.sendBtn.isEnabled) {
        [self.sendBtn setEnabled:isEnabled];
    }
}

- (UIButton *)sendBtn{
    if (_sendBtn==nil) {
        UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(senBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn = btn;
    }
    return _sendBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    [self addSubview:self.sendBtn];
    
}

- (void)senBtnClick:(UIButton *)sender{
    [sender setEnabled:NO];
    //开启定时器
    [self buttonCountTimer];
    
    if (self.sendCodeBlock) {
        self.sendCodeBlock();
    }
}

- (void)buttonCountTimer{
    countSecond=60;
    [self.sendBtn setTitle:[NSString stringWithFormat:@"%lu秒后重试",(unsigned long)countSecond] forState:UIControlStateNormal];
    
    countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

- (void)timeFireMethod{
    countSecond--;
    if (countSecond!=0) {
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%lu秒后重试",(unsigned long)countSecond] forState:UIControlStateNormal];
    }else{
        [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.sendBtn.enabled=YES;
        [countDownTimer invalidate];
    }
}
@end
