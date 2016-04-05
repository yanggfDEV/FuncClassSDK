//
//  UIView+Snapshot.m

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
