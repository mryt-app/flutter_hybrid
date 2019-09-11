//
//  FLHMessenger.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import <Flutter/Flutter.h>

/**
 * The framework is communited with Flutter via a `MethodChannel`.
 * According to functions, messages are handled by respective messenger.
 */
@protocol FLHMessenger <NSObject>

/**
 * Name of the messenger.
 * All methods should start with the name.
 */
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, weak) FlutterMethodChannel *methodChannel;

/**
 * Handle messages of this messenger.
 * @param method The name of the messenger has been removed from the method.
 */
- (void)handleMethodCall:(NSString *)method arguments:(id)arguments result:(FlutterResult)result;

@end
