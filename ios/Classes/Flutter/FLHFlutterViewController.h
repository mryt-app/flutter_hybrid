//
//  FLHFlutterViewController.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * In `FlutterViewController`, send AppLifecycleState message on page lifecyle method.
 * Corresponding relation:
 * viewWillAppear: AppLifecycleState.inactive
 * viewDidAppear: AppLifecycleState.resumed
 * viewWillDisappear: AppLifecycleState.inactive
 * viewDidDisappear: AppLifecycleState.paused
 * So, we override lifecycle methods to control flutter app's lifecycle.
 * See also: https://github.com/flutter/engine/blob/master/shell/platform/darwin/ios/framework/Source/FlutterViewController.mm
 */
@interface FLHFlutterViewController : FlutterViewController

/**
 * Call super.viewWillAppear:
 */
- (void)flh_viewWillAppear:(BOOL)animated;
/**
 * Call super.viewDidAppear:
 */
- (void)flh_viewDidAppear:(BOOL)animated;
/**
 * Call super.flh_viewWillDisappear:
 */
- (void)flh_viewWillDisappear:(BOOL)animated;
/**
 * Call super.viewDidDisappear:
 */
- (void)flh_viewDidDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
