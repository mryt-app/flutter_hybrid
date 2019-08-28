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
}

- (IBAction)navigateToFlutterCounterPage:(id)sender {
    [Router.sharedInstance openPage:@"/counter" params:nil animated:YES completion:nil];
}

- (IBAction)navigateToFlutterColorPage:(id)sender {
    [Router.sharedInstance openPage:@"/colorPage" params:@{ @"color": @(0xFFFF0000) } animated:YES completion:nil];
}

@end
