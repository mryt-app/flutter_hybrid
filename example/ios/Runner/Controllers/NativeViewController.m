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
    
    UIButton *counterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [counterButton setTitle:@"Open Flutter Counter Page" forState:UIControlStateNormal];
    [counterButton addTarget:self action:@selector(navigateToFlutterCounterPage:) forControlEvents:UIControlEventTouchUpInside];
    [counterButton sizeToFit];
    [self.view addSubview:counterButton];
    
    UIButton *colorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [colorButton setTitle:@"Open Flutter Color Page" forState:UIControlStateNormal];
    [colorButton addTarget:self action:@selector(navigateToFlutterColorPage:) forControlEvents:UIControlEventTouchUpInside];
    [colorButton sizeToFit];
    [self.view addSubview:colorButton];

    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    counterButton.frame = CGRectMake((screenWidth - counterButton.bounds.size.width) / 2, 200, counterButton.bounds.size.width, counterButton.bounds.size.height);
    colorButton.frame = CGRectMake((screenWidth - colorButton.bounds.size.width) / 2, counterButton.frame.origin.y + counterButton.frame.size.height + 20, colorButton.bounds.size.width, colorButton.bounds.size.height);
}

- (void)navigateToFlutterCounterPage:(id)sender {
    [Router.sharedInstance openPage:@"/counter" params:nil animated:YES completion:nil];
}

- (void)navigateToFlutterColorPage:(id)sender {
    [Router.sharedInstance openPage:@"/colorPage" params:@{ @"color": @(0xFFFF0000) } animated:YES completion:nil];
}

@end
