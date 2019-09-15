//
//  DemoFlutterContainerViewController.m
//  Runner
//
//  Created by JianFei Wang on 2019/9/14.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "DemoFlutterContainerViewController.h"

@interface DemoFlutterContainerViewController ()

@end

@implementation DemoFlutterContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"go_back_button"] style:UIBarButtonItemStyleDone target:self action:@selector(popOrClose)];
}

@end
