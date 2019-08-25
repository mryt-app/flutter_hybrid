//
//  FLHStackCache.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import "FLHStackCache.h"

@interface FLHStackCache ()

@property (nonatomic, strong) NSMutableArray<NSString *> *objectKeys;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *objectTypes;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<FLHStackCacheObject>> *inMemoryObjects;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *loadingObjects;
@property (nonatomic, strong) dispatch_queue_t queueIO;

@end

@implementation FLHStackCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _objectKeys = [NSMutableArray new];
        _inMemoryObjects = [NSMutableDictionary new];
        _loadingObjects = [NSMutableDictionary new];
        _objectTypes = [NSMutableDictionary new];
        _queueIO = dispatch_queue_create("cn.missfresh.stackCache", NULL);
        _inMemoryLimit = 2;
    }
    return self;
}

#pragma mark - basic operations

- (void)pushObject:(id<FLHStackCacheObject>)obj forKey:(NSString *)key {
    if (!obj || key.length <= 0) {
        return;
    }
    
    if (![_objectKeys containsObject:key]) {
        [_objectKeys addObject:key];
    }
    
    obj.key = key;
    _objectTypes[key] = obj.class;
    _inMemoryObjects[key] = obj;
    
    for (NSUInteger i = _objectKeys.count - _inMemoryObjects.count;
         i < _objectKeys.count && _inMemoryObjects.count > _inMemoryLimit; i++) {
        
        NSString *keyToSave = _objectKeys[i];
        if (_inMemoryObjects[keyToSave]) {
            id<FLHStackCacheObject> ob = _inMemoryObjects[keyToSave];
            [_inMemoryObjects removeObjectForKey:keyToSave];
            [ob writeToFileWithKey:keyToSave
                             queue:_queueIO
                             cache:self
                        completion:^(NSError *err, NSString *path) {
                            if (err) {
                                NSLog(@"Caching object to file failed!");
                            }
                        }];
        }
    }
}

- (id<FLHStackCacheObject>)removeObjectForKey:(NSString *)key {
    if ([self isEmpty]) {
        return nil;
    }
    
    if (![_objectKeys containsObject:key]) {
        return nil;
    }
    
    id ob = _inMemoryObjects[key];
    
    [_objectKeys removeObject:key];
    [_objectTypes removeObjectForKey:key];
    [_inMemoryObjects removeObjectForKey:key];
    
    [self _preloadIfNeeded];
    
    return ob;
}

- (void)invalidateObjectForKey:(NSString *)key {
    if (!key || [self isEmpty]) {
        return;
    }
    
    if (![_objectKeys containsObject:key]) {
        return;
    }
    
    id<FLHStackCacheObject> ob = _inMemoryObjects[key];
    [ob removeCachedFileWithKey:key
                          queue:_queueIO
                          cache:self
                     completion:^(NSError *err, NSString *k){
                     }];
    [_inMemoryObjects removeObjectForKey:key];
    
    [self _preloadIfNeeded];
}

- (void)clearAllObjects {
    [self.objectKeys removeAllObjects];
    [self.inMemoryObjects removeAllObjects];
    [self.objectTypes removeAllObjects];
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.cacheDir error:&err];
    if (err) {
        NSLog(@"fail to remove cache dir %@",err);
    }
}

- (id<FLHStackCacheObject>)objectForKey:(NSString *)key {
    return _inMemoryObjects[key];
}

- (BOOL)isEmpty {
    return _objectKeys.count <= 0;
}

#pragma mark - Disk thing

- (NSString *)cacheDir
{
    @throw [NSException exceptionWithName:@"Invalid callback" reason:@"Please override this method." userInfo:nil];
    return nil;
}

#pragma mark - Private

- (void)_preloadIfNeeded
{
    for (NSString *key in self.objectKeys.reverseObjectEnumerator) {
        Class typeClass = _objectTypes[key];
        id cache = _inMemoryObjects[key];
        if (typeClass && !cache &&
            [typeClass conformsToProtocol:@protocol(FLHStackCacheObject)]) {
            _loadingObjects[key] = @(YES);
            
            [typeClass
             loadFromFileWithKey:key
             queue:_queueIO
             cache:self
             completion:^(NSError *err, id<FLHStackCacheObject> ob) {
                 [self.loadingObjects removeObjectForKey:key];
                 if (ob && !err) {
                     if (self.objectTypes[key]) {
                         self.inMemoryObjects[key] = ob;
                     }
                 } else {
                     NSLog(@"preload object from file failed!");
                 }
             }];
        }
        
        if (_inMemoryObjects.count + _loadingObjects.count >= _inMemoryLimit) {
            break;
        }
    }
}

@end
