//
//  FLHMemoryInspector.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Foundation/Foundation.h>
#import "FLHBaseToolMacro.h"

#define kFLHMemoryInspectorChangedNotification @"__FlutterMemoryInspectorChangedNotification__"
#define kFLHMemoryInspectorKeyCondition @"condition"

typedef NS_ENUM(NSUInteger,FLHMemoryCondition) {
    FLHMemoryConditionUnknown,
    FLHMemoryConditionNormal,
    FLHMemoryConditionLowMemory,
    FLHMemoryConditionExtremelyLow,
    FLHMemoryConditionAboutToDie,
};

NS_ASSUME_NONNULL_BEGIN

@interface FLHMemoryInspector : NSObject

AS_SINGLETON(FLHMemoryInspector)

- (FLHMemoryCondition)currentCondition;
- (int64_t)currentFootPrint;
- (int64_t)deviceMemory;
- (BOOL)smallMemoryDevice;

@end

NS_ASSUME_NONNULL_END
