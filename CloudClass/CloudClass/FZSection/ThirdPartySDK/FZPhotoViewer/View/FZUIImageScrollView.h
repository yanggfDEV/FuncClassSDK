//
//  FZUIImageScrollView
//
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FZImageViewZoomStatus) {
    FZImageViewZoomStatusNormal,
    FZImageViewZoomStatusExpand
};

@interface FZUIImageScrollView : UIScrollView

@property (assign, nonatomic) CGFloat maxImageZoomScale;//default is 1.0
@property (assign, nonatomic) FZImageViewZoomStatus status;
@property (strong, nonatomic, readonly) UIImage *image;
@property (copy, nonatomic) void (^singleTapBlock)(void);
@property (copy, nonatomic) void (^longPressGestureBlock)(CGPoint point, UIGestureRecognizerState state);
@property (assign, nonatomic) BOOL singleTapEanble; //default is YES

@property (strong, nonatomic, readonly) UIImageView *imageView;

- (void)setImageWithURL:(NSURL *)url
            placeholder:(UIImage *)placeholderImage
         completedBlock:(void(^)(UIImage *image))completedBlock;


@end
