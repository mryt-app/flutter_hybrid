//
//  UIViewController+Utility.m
//  Runner
//
//  Created by JianFei Wang on 2019/8/28.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UIViewController (Utility)

+ (UIViewController *)rootViewController {
    return [[UIApplication sharedApplication].keyWindow rootViewController];
}

+ (UIViewController *)topViewController {
    UIViewController *topVC = nil;
    UIViewController *currentVC = [self rootViewController];
    if ([currentVC isKindOfClass:UINavigationController.class]) {
        if (currentVC.presentedViewController == nil) {
            UINavigationController *navi = (UINavigationController *)currentVC;
            topVC = navi.topViewController;
        } else {
            while (currentVC.presentedViewController != nil) {
                currentVC = currentVC.presentedViewController;
            }
            topVC = currentVC;
        }
    } else if ([currentVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarVC = (UITabBarController *)currentVC;
        UINavigationController *selectVC = tabbarVC.selectedViewController;
        if (selectVC.presentedViewController == nil) {
            topVC = selectVC.topViewController;
        } else {
            UIViewController *vc = selectVC;
            while (vc.presentedViewController != nil) {
                vc = vc.presentedViewController;
            }
            topVC = vc;
        }
    } else {
        topVC = currentVC;
    }
    return topVC;
}

+ (UINavigationController *)currentNavigationController {
    UIViewController *topVC = [self topViewController];
    return [topVC navigationController];
}

@end
