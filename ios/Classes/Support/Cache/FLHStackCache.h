//
//  FLHStackCache.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FLHStackCache;
@protocol FLHStackCacheObject <NSObject>

@required
@property (nonatomic, copy) NSString *key;

- (BOOL)writeToFileWithKey:(NSString *)key
                     queue:(dispatch_queue_t)queue
                     cache:(FLHStackCache *)cache
                completion:(void (^)(NSError *err,NSString *path))completion;

+ (BOOL)loadFromFileWithKey:(NSString *)key
                      queue:(dispatch_queue_t)queue
                      cache:(FLHStackCache *)cache
                 completion:(void (^)(NSError *err ,id<FLHStackCacheObject>))completion;

- (BOOL)removeCachedFileWithKey:(NSString *)key
                          queue:(dispatch_queue_t)queue
                          cache:(FLHStackCache *)cache
                     completion:(void (^)(NSError *, NSString *))completion;

@end

@interface FLHStackCache : NSObject

/**
 * Num of objects allowed in memory.
 * Default value is set to 2.
 */
@property (nonatomic, assign) NSUInteger inMemoryLimit;

#pragma mark - basic operations

- (void)pushObject:(id<FLHStackCacheObject>)obj forKey:(NSString *)key;
- (id<FLHStackCacheObject>)removeObjectForKey:(NSString *)key;
- (void)invalidateObjectForKey:(NSString *)key;
- (void)clearAllObjects;
- (id<FLHStackCacheObject>)objectForKey:(NSString *)key;
- (BOOL)isEmpty;

#pragma mark - Disk thing

/**
 * Target cache directory.
 * Subclass must override this method.
 */
- (NSString *)cacheDir;

@end

NS_ASSUME_NONNULL_END
