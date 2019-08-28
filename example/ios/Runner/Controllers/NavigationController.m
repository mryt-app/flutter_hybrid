//
//  NavigationController.m
//  Runner
//
//  Created by JianFei Wang on 2019/8/28.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@property (nonatomic, copy) NSString *callerDesc;

@end

@implementation NavigationController

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearCallerDesc) object:nil];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSString *currentCallerDesc = [self getCallerDesc];
    if (self.callerDesc == nil ||
        currentCallerDesc == nil ||
        ![self.callerDesc isEqualToString:currentCallerDesc]) {
        self.callerDesc = currentCallerDesc;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearCallerDesc) object:nil];
        [self performSelector:@selector(clearCallerDesc) withObject:nil afterDelay:3];
        
        if (self.viewControllers.count != 0) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        
        return [super pushViewController:viewController animated:animated];
    } else {
        self.callerDesc = currentCallerDesc;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearCallerDesc) object:nil];
        [self performSelector:@selector(clearCallerDesc) withObject:nil afterDelay:3];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.callerDesc = nil;
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.callerDesc = nil;
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    self.callerDesc = nil;
    return [super popToRootViewControllerAnimated:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].statusBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    });
    
    [super viewWillAppear:animated];
}

//Add this private instance method to the class you want to trace from
- (NSString *)getCallerDesc
{
    //Go back 2 frames to account for calling this helper method
    //If not using a helper method use 1
    NSArray* stack = [NSThread callStackSymbols];
    if (stack &&
        stack.count > 2) {
        return [stack objectAtIndex:2];
    } else {
        return nil;
    }
}

- (void)clearCallerDesc {
    self.callerDesc = nil;
}

@end
