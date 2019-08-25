//
//  FLHStackCacheImageObject.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import "FLHStackCacheImageObject.h"

@interface FLHStackCacheImageObject ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation FLHStackCacheImageObject
@synthesize key;

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    return self;
}

#pragma mark - Public

+ (BOOL)loadFromFileWithKey:(NSString *)key
                      queue:(dispatch_queue_t)queue
                      cache:(FLHStackCache *)cache
                 completion:(void (^)(NSError *, id<FLHStackCacheObject>))completion {
    dispatch_async(queue, ^{
        UIImage *image = [[UIImage alloc]
                          initWithContentsOfFile:[self filePathByKey:key dirPath:cache.cacheDir]];
        if (completion) {
            if (image) {
                FLHStackCacheImageObject *ob = [[FLHStackCacheImageObject alloc] initWithImage:image];
                ob.key = key;
                completion(nil, ob);
            } else {
                completion([NSError new], nil);
            }
        }
    });
    
    return YES;
}

- (BOOL)writeToFileWithKey:(NSString *)key
                     queue:(dispatch_queue_t)queue
                     cache:(FLHStackCache *)cache
                completion:(void (^)(NSError *, NSString *))completion {
    if (!_image) {
        return NO;
    }
    
    dispatch_async(queue, ^{
        NSData *imgData = UIImagePNGRepresentation(self.image);
        NSString *filePath =
        [FLHStackCacheImageObject filePathByKey:key dirPath:cache.cacheDir];
        [imgData writeToFile:filePath atomically:YES];
        if (completion) {
            completion(nil, key);
        }
    });
    
    return YES;
}

- (BOOL)removeCachedFileWithKey:(NSString *)key
                          queue:(dispatch_queue_t)queue
                          cache:(FLHStackCache *)cache
                     completion:(void (^)(NSError *, NSString *))completion {
    if (!key) {
        return NO;
    }
    
    dispatch_async(queue, ^{
        NSString *filePath =
        [FLHStackCacheImageObject filePathByKey:key dirPath:cache.cacheDir];
        NSError *err = nil;
        [NSFileManager.defaultManager removeItemAtPath:filePath error:&err];
        if (completion) {
            completion(err, key);
        }
    });
    
    return YES;
}

#pragma mark - Private

+ (NSString *)filePathByKey:(NSString *)key dirPath:(NSString *)dirPath {
    NSString *fileName = [key stringByReplacingOccurrencesOfString:@"/" withString:@""];
    fileName = [key stringByReplacingOccurrencesOfString:@":" withString:@""];
    return [dirPath stringByAppendingPathComponent:fileName];
}

@end
