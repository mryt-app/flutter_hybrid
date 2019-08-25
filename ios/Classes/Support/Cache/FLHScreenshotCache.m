//
//  FLHScreenshotCache.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import "FLHScreenshotCache.h"

@implementation FLHScreenshotCache

DEF_SINGLETON(FLHScreenshotCache)

- (NSString *)cacheDir {
    static NSString *cachePath = nil;
    if (!cachePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                             NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];
        cachePath = [cacheDirectory stringByAppendingPathComponent:@"FlutterScreenshots"];
    }
    
    BOOL dir = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath
                                              isDirectory:&dir]) {
        NSError *eror = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&eror];
        if (eror) {
            NSLog(@"%@", eror);
        }
    }
    return cachePath;
}

@end
