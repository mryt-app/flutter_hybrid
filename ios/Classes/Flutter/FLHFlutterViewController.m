//
//  FLHFlutterViewController.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import "FLHFlutterViewController.h"

@interface FLHFlutterViewController ()

@end

@implementation FLHFlutterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

#pragma mark - Override

- (void)viewWillAppear:(BOOL)animated
{
//     Left blank intentionally.
//     Send AppLifecycleState.inactive in super, we will do it manually.
}

- (void)viewDidAppear:(BOOL)animated
{
//    Left blank intentionally.
//    Send AppLifecycleState.resumed in super, we will do it manually.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
//    Avoid super call intentionally.
//    Send AppLifecycleState.inactive in super, we will do it manually.
}

- (void)viewDidDisappear:(BOOL)animated
{
//    Avoid super call intentionally.
//    Send AppLifecycleState.paused in super, we will do it manually.
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (UIEdgeInsets)paddingEdgeInsets {
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (@available(iOS 11, *)) {
        edgeInsets = UIEdgeInsetsMake(0, self.view.safeAreaInsets.left, self.view.safeAreaInsets.bottom, self.view.safeAreaInsets.right);
    } else {
        edgeInsets = UIEdgeInsetsZero;
    }
    return edgeInsets;
}

- (void)installSplashScreenViewIfNecessary {
//    Override this to avoid unnecessary splash Screen.
}

#pragma mark - Custom view lifecycle

- (void)flh_viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)flh_viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)flh_viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)flh_viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

@end
