//
//  UIView+Screenshot.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/24.
//

#import "UIView+Screenshot.h"
#import "FLHMemoryInspector.h"

@implementation UIView (Screenshot)

- (CGFloat)flh_screenshotScale {
    NSDictionary<NSNumber *, NSNumber *> *scalesForMemoryCondition =
    @{
      @(FLHMemoryConditionAboutToDie): @(0),
      @(FLHMemoryConditionExtremelyLow): @(0.75),
      @(FLHMemoryConditionLowMemory): @(1),
      @(FLHMemoryConditionNormal): @(2),
      @(FLHMemoryConditionUnknown): @([FLHMemoryInspector.sharedInstance smallMemoryDevice] ? 1 : 2),
      };
    FLHMemoryCondition memoryCondition = [FLHMemoryInspector.sharedInstance currentCondition];
    return [scalesForMemoryCondition[@(memoryCondition)] floatValue];
}

- (UIImage *)flh_screenshot {
    CGFloat scale = [self flh_screenshotScale];
    CGFloat zeroThreshold = 0.000001;
    if (fabs(scale) < zeroThreshold) {
        return [UIImage new];
    }
    
    CGRect rect = self.bounds;
    CGSize snapshotSize = rect.size;
    UIGraphicsBeginImageContextWithOptions(snapshotSize, NO, scale);
    
    [self drawViewHierarchyInRect:rect
                    afterScreenUpdates:NO];
    
    UIImage *snapImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapImage;
}

@end
