//
//  BasicViewController.m
//  LBasicUtil
//
//  Created by LN on 2021/8/30.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
