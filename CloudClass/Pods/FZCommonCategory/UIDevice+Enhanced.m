//
//  UIDevice+NIEEnhance.m


#import <sys/utsname.h>

#import "UIDevice+Enhanced.h"

static NSString *_machineName;

@implementation UIDevice (Enhanced)

- (NSString *)machineName {
    if (!_machineName) {
        struct utsname systemInfo;
        uname(&systemInfo);
        _machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }
    return _machineName;
}

- (BOOL)machineNameInList:(NSArray *)machineNameList {
    return [[NSSet setWithArray:machineNameList] containsObject:[self machineName]];
}

- (BOOL)isSimulator {
    return [self machineNameInList:@[@"i386", @"x86_64"]];
}

- (BOOL)isIPhone4 {
    return [self machineNameInList:@[@"iPhone3,1", @"iPhone3,2", @"iPhone3,3"]];
}

- (BOOL)isIPhone4S {
    return [self machineNameInList:@[@"iPhone4,1"]];
}

- (BOOL)isIPhone4Or4S {
    return [self isIPhone4] || [self isIPhone4S];
}

- (BOOL)isIPhone5 {
    return [self machineNameInList:@[@"iPhone5,1", @"iPhone5,2"]];
}

- (BOOL)isIPhone5C {
    return [self machineNameInList:@[@"iPhone5,3", @"iPhone5,4"]];
}

- (BOOL)isIPhone5S {
    return [self machineNameInList:@[@"iPhone6,1", @"iPhone6,2"]];
}

- (BOOL)isIPhone5Or5COr5S {
    return [self isIPhone5] || [self isIPhone5C] || [self isIPhone5S];
}

- (BOOL)isIPhone6 {
    return [self machineNameInList:@[@"iPhone7,2"]];
}

- (BOOL)isIPhone6Plus {
    return [self machineNameInList:@[@"iPhone7,1"]];
}

@end
