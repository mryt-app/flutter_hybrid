//
//  FLHFlutterViewManager.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Foundation/Foundation.h>

@class FlutterViewController;
@class FlutterEngine;

NS_ASSUME_NONNULL_BEGIN

/**
 * Manage the sole `FlutterViewController`
 */
@protocol FLHFlutterManager <NSObject>

@required

- (FlutterViewController *)flutterViewController;

- (FlutterEngine *)flutterEngine;

/**
 * AppLifecycleState.paused
 * The FlutterViewController's parentViewController is nil(isn't visible to user).
 */
- (void)pause;
/**
 * AppLifecycleState.resumed
 * The FlutterViewController is visible and responding to user input.
 * On the first Flutter page is readying to show, we also think it is resumed.
 */
- (void)resume;
/**
 * AppLifecycleState.inactive
 * The FlutterViewController is transitioning.
 */
- (void)inactive;

@end

NS_ASSUME_NONNULL_END
