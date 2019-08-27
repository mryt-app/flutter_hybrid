//
//  FLHMessenger.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/27.
//

#import <Flutter/Flutter.h>

@protocol FLHMessenger <NSObject>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, weak) FlutterMethodChannel *methodChannel;

- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)methodChannel;
- (void)handleMethodCall:(NSString *)method arguments:(id)arguments result:(FlutterResult)result;

@end
