//
//  NativeViewController.m
//  Runner
//
//  Created by JianFei Wang on 2019/8/28.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "NativeViewController.h"
#import "Router.h"

@interface NativeViewController ()

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    
    UIButton *containerCounterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [containerCounterButton setTitle:@"Open Flutter Counter Page In Container" forState:UIControlStateNormal];
    [containerCounterButton addTarget:self action:@selector(openCounterPageInContainer:) forControlEvents:UIControlEventTouchUpInside];
    [containerCounterButton sizeToFit];
    [self.view addSubview:containerCounterButton];
    
    UIButton *containerColorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [containerColorButton setTitle:@"Open Flutter Color Page In Container" forState:UIControlStateNormal];
    [containerColorButton addTarget:self action:@selector(openColorPageInContainer:) forControlEvents:UIControlEventTouchUpInside];
    [containerColorButton sizeToFit];
    [self.view addSubview:containerColorButton];

    containerCounterButton.frame = CGRectMake((screenWidth - containerCounterButton.bounds.size.width) / 2, 200, containerCounterButton.bounds.size.width, containerCounterButton.bounds.size.height);
    containerColorButton.frame = CGRectMake((screenWidth - containerColorButton.bounds.size.width) / 2, containerCounterButton.frame.origin.y + containerCounterButton.frame.size.height + 20, containerColorButton.bounds.size.width, containerColorButton.bounds.size.height);
    
    UIButton *counterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [counterButton setTitle:@"Open Flutter Counter Page" forState:UIControlStateNormal];
    [counterButton addTarget:self action:@selector(openCounterPage:) forControlEvents:UIControlEventTouchUpInside];
    [counterButton sizeToFit];
    [self.view addSubview:counterButton];
    
    UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton setTitle:@"Open Flutter Color Page" forState:UIControlStateNormal];
    [colorButton addTarget:self action:@selector(openColorPage:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton sizeToFit];
    [self.view addSubview:colorButton];
    
    counterButton.frame = CGRectMake((screenWidth - counterButton.bounds.size.width) / 2, containerColorButton.frame.origin.y + containerColorButton.frame.size.height + 20, counterButton.bounds.size.width, counterButton.bounds.size.height);
    colorButton.frame = CGRectMake((screenWidth - colorButton.bounds.size.width) / 2, counterButton.frame.origin.y + counterButton.frame.size.height + 20, colorButton.bounds.size.width, colorButton.bounds.size.height);
}

- (void)openCounterPageInContainer:(id)sender {
    [Router.sharedInstance openPage:@"/counter" params:@{ @"openInContainer": @(YES) } animated:YES completion:nil];
}

- (void)openColorPageInContainer:(id)sender {
    [Router.sharedInstance openPage:@"/colorPage" params:@{ @"openInContainer": @(YES), @"color": @(0xFFFF0000) } animated:YES completion:nil];
}

- (void)openCounterPage:(id)sender {
    [Router.sharedInstance openPage:@"/counter" params:nil animated:YES completion:nil];
}

- (void)openColorPage:(id)sender {
    [Router.sharedInstance openPage:@"/colorPage" params:@{ @"color": @(0xFFFF0000) } animated:YES completion:nil];
}

@end
