//
//  UIDevice+NIEEnhance.h

#import <UIKit/UIKit.h>

@interface UIDevice (Enhanced)

- (NSString *)machineName;

- (BOOL)isSimulator;

- (BOOL)isIPhone4;
- (BOOL)isIPhone4S;
- (BOOL)isIPhone4Or4S;

- (BOOL)isIPhone5;
- (BOOL)isIPhone5C;
- (BOOL)isIPhone5S;
- (BOOL)isIPhone5Or5COr5S;

- (BOOL)isIPhone6;

- (BOOL)isIPhone6Plus;


@end
