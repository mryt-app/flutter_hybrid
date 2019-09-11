//
//  FLHRouter.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The platform(iOS) should implements this protocol to route pages.
 * The route and params is fully customized, the framework hasn't restrictions.
 */
@protocol FLHRouter <NSObject>

@optional

@property (nonatomic, assign) BOOL flutterCanPop;

- (void)openPage:(NSString *)route
          params:(nullable NSDictionary *)params
        animated:(BOOL)animated
      completion:(nullable void (^)(BOOL finished))completion;

- (void)closePage:(NSString *)pageId
           params:(nullable NSDictionary *)params
         animated:(BOOL)animated
       completion:(nullable void (^)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
