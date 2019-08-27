//
//  FLHHybridPageLifecycle.h
//  Pods
//
//  Created by JianFei Wang on 2019/8/27.
//

#ifndef FLHHybridPageLifecycle_h
#define FLHHybridPageLifecycle_h

typedef NS_ENUM(NSUInteger, FLHHybridPageLifecycle) {
    FLHHybridPageLifecycleDidInit,
    FLHHybridPageLifecycleWillAppear,
    FLHHybridPageLifecycleDidAppear,
    FLHHybridPageLifecycleWillDisappear,
    FLHHybridPageLifecycleDidDisappear,
    FLHHybridPageLifecycleWillDealloc,
};

#endif /* FLHHybridPageLifecycle_h */
