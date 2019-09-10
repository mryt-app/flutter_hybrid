//
//  Router.m
//  Runner
//
//  Created by JianFei Wang on 2019/8/28.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "Router.h"
#import "UIViewController+Utility.h"
#import "DemoFlutterViewController.h"

@interface Router ()

@property (nonatomic, readonly) UINavigationController *navigationController;

@end

@implementation Router
@synthesize flutterCanPop;

+ (instancetype)sharedInstance {
    static Router *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [Router new];
    });
    return _instance;
}

- (void)openPage:(NSString *)route params:(NSDictionary *)params animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    BOOL present = [params[@"present"] boolValue];
    DemoFlutterViewController *flutterVC = [[DemoFlutterViewController alloc] initWithRoute:route params:params];
    if (present) {
        [self.navigationController presentViewController:flutterVC animated:animated completion:^{
            if (completion) {
                completion(YES);
            }
        }];
    } else {
        [self.navigationController pushViewController:flutterVC animated:animated];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)closePage:(NSString *)pageId params:(NSDictionary *)params animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    DemoFlutterViewController *flutterVC = (DemoFlutterViewController *)self.navigationController.presentedViewController;
    if ([flutterVC isKindOfClass:FLHFlutterContainerViewController.class] &&
        [flutterVC.uniqueID isEqual:pageId]) {
      [flutterVC dismissViewControllerAnimated:animated
                                    completion:^{
                                    }];
    } else {
      [self.navigationController popViewControllerAnimated:animated];
    }
}

- (UINavigationController *)navigationController {
    return [UIViewController currentNavigationController];
}

@end
