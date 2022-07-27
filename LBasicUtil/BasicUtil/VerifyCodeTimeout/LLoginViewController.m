//
//  LLoginViewController.m
//  LBasicUtil
//
//  Created by LN on 2021/9/6.
//

#import "LLoginViewController.h"
#import "SendVerifyCodeBtn.h"

@interface LLoginViewController ()

@end

@implementation LLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SendVerifyCodeBtn *getCode = [[SendVerifyCodeBtn alloc] initWithFrame: CGRectMake(10, 10, 100, 60)];
    [self.view addSubview:getCode];
    getCode.sendCodeBlock = ^{
        //接口访问
    };
}

@end
