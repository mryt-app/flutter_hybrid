//
//  FLHMemoryInspector.m
//  flutter_hybrid
//
//  Created by JianFei Wang on 2019/8/23.
//

#import "FLHMemoryInspector.h"

#include <mach/mach.h>
#include <stdlib.h>
#include <sys/sysctl.h>

@interface FLHMemoryInspector ()

@property (nonatomic, assign) FLHMemoryCondition currentCondition;

@end

@implementation FLHMemoryInspector

DEF_SINGLETON(FLHMemoryInspector)

static bool isHighterThanIos9()
{
    bool ret = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0.0");
    return ret;
}

static int64_t memoryFootprint()
{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (result != KERN_SUCCESS)
        return -1;
    return vmInfo.phys_footprint;
}

static int64_t _memoryWarningLimit()
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine =(char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone5,1"])    return MB(600);
    if ([platform isEqualToString:@"iPhone5,2"])    return MB(600);
    if ([platform isEqualToString:@"iPhone5,3"])    return MB(600);
    if ([platform isEqualToString:@"iPhone5,4"])    return MB(600);
    if ([platform isEqualToString:@"iPhone6,1"])    return MB(600);
    if ([platform isEqualToString:@"iPhone6,2"])    return MB(600);
    if ([platform isEqualToString:@"iPhone7,1"])    return MB(600);
    if ([platform isEqualToString:@"iPhone7,2"])    return MB(600);
    if ([platform isEqualToString:@"iPhone8,1"])    return MB(1280);
    if ([platform isEqualToString:@"iPhone8,2"])    return MB(1280);
    if ([platform isEqualToString:@"iPhone8,4"])    return MB(1280);
    if ([platform isEqualToString:@"iPhone9,1"])    return MB(1280);
    if ([platform isEqualToString:@"iPhone9,2"])    return MB(1950);
    if ([platform isEqualToString:@"iPhone9,3"])    return MB(1280);
    if ([platform isEqualToString:@"iPhone9,4"])    return MB(1950);
    if ([platform isEqualToString:@"iPhone10,1"])   return MB(1280);
    if ([platform isEqualToString:@"iPhone10,2"])   return MB(1950);
    if ([platform isEqualToString:@"iPhone10,3"])   return MB(1950);
    if ([platform isEqualToString:@"iPhone10,4"])   return MB(1280);
    if ([platform isEqualToString:@"iPhone10,5"])   return MB(1950);
    if ([platform isEqualToString:@"iPhone10,6"])   return MB(1950);
    
    return 0;
}

- (int64_t)deviceMemory
{
    int64_t size = [NSProcessInfo processInfo].physicalMemory;
    return size;
}

- (BOOL)smallMemoryDevice
{
    if ([self deviceMemory] <= MB(1024)) {
        return YES;
    } else {
        return NO;
    }
}

- (FLHMemoryCondition)currentCondition
{
    FLHMemoryCondition newCondition = FLHMemoryConditionUnknown;
    int64_t memoryLimit = _memoryWarningLimit();

    if (!isHighterThanIos9() || memoryLimit <= 0) {
      newCondition = FLHMemoryConditionUnknown;
    } else if (memoryFootprint() < memoryLimit * 0.40) {
      newCondition = FLHMemoryConditionNormal;
    } else if (memoryFootprint() < memoryLimit * 0.60) {
      newCondition = FLHMemoryConditionLowMemory;
    } else if (memoryFootprint() < memoryLimit * 0.80) {
      newCondition = FLHMemoryConditionExtremelyLow;
    } else {
      newCondition = FLHMemoryConditionAboutToDie;
    }

    if (newCondition != self.currentCondition) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFLHMemoryInspectorChangedNotification
                                                            object:@{kFLHMemoryInspectorKeyCondition:@(newCondition)}];
    }
    
    self.currentCondition = newCondition;
    
    return newCondition;
}

- (int64_t)currentFootPrint
{
    return memoryFootprint();
}

@end
