//
//  FLHFlutterViewController.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLHFlutterViewController : FlutterViewController

- (void)flh_viewWillAppear:(BOOL)animated;
- (void)flh_viewDidAppear:(BOOL)animated;
- (void)flh_viewWillDisappear:(BOOL)animated;
- (void)flh_viewDidDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
