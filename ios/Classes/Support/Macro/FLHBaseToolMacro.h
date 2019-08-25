//
//  FLHBaseToolMacro.h
//  Pods
//
//  Created by JianFei Wang on 2019/8/23.
//

#ifndef FLHBaseToolMacro_h
#define FLHBaseToolMacro_h

// General tools
#define guard(CONDITION) if (CONDITION) {}

// Singleton

#undef AS_SINGLETON
#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;

#undef DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once(&once, ^{ __singleton__ = [super allocWithZone:zone]; } ); \
return __singleton__; \
}

#undef AS_WEAK_SINGLETON
#define AS_WEAK_SINGLETON( __class ) \
+ (__class *)getInstance;

#undef DEF_WEAK_SINGLETON
#define DEF_WEAK_SINGLETON( __class ) \
+ (__class *)getInstance \
{ \
static __weak __class * __singleton__; \
__class *currentInstance = __singleton__; \
@synchronized (self) { \
if (currentInstance == nil) { \
currentInstance = [[[self class] alloc] init]; \
__singleton__ = currentInstance; \
} \
} \
return currentInstance; \
} \

// Tools
#define MB(_v_) (_v_*1024*1024)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif /* FLHBaseToolMacro_h */
