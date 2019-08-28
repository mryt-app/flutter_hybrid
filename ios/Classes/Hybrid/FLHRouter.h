//
//  FLHRouter.h
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FLHRouter <NSObject>

@optional
// Could flutter module pop
@property (nonatomic, assign) BOOL canPop;

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
