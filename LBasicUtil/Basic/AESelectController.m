//
//  AESelectController.m
//  ArtPlatform
//
//  Created by LN on 2021/1/18.
//  Copyright © 2021 SPPT. All rights reserved.
//

#import "AESelectController.h"

@implementation AESelectController
+ (UIViewController *)getCurrentVC {

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];

    if (window.windowLevel != UIWindowLevelNormal){

        NSArray *windows = [[UIApplication sharedApplication] windows];

        for(UIWindow * tmpWin in windows){

            if (tmpWin.windowLevel == UIWindowLevelNormal){

                window = tmpWin;

                break;

            }

        }

    }

    UIViewController *result = window.rootViewController;

    while (result.presentedViewController) {

        result = result.presentedViewController;

    }

    if ([result isKindOfClass:[UITabBarController class]]) {

        result = [(UITabBarController *)result selectedViewController];

    }

    if ([result isKindOfClass:[UINavigationController class]]) {

        result = [(UINavigationController *)result topViewController];

    }

    return result;

    

}
@end
