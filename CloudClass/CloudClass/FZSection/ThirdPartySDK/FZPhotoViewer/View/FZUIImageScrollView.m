//
//  FZUIImageScrollView
//  ImageScroll
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "FZUIImageScrollView.h"

@interface FZUIImageScrollView()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic, readwrite) UIImage *image;
@property (strong, nonatomic, readwrite) UIImageView *imageView;
@property (assign, nonatomic) CGFloat maxViewZoomScale;

@property (strong, nonatomic) UITapGestureRecognizer *singleTapGesture;

@end


@implementation FZUIImageScrollView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.bounces = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.singleTapEanble = YES;
    self.delegate = self;

    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapGesture];
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTapGesture];
    self.singleTapGesture = singleTapGesture;
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self addGestureRecognizer:longPressGesture];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    self.minimumZoomScale = 1.0;
    self.maxImageZoomScale = 1.0f;
}

- (CGSize)calculateImageViewOriginSize:(UIImage *)image {
    if (image == nil || self.frame.size.width == 0 || self.frame.size.height == 0) {
        return CGSizeMake(0, 0);
    }
    CGFloat scaleWidth = image.size.width / self.frame.size.width;
    CGFloat scaleHeight = image.size.height / self.frame.size.height;
    
    CGFloat biggerScale = 0;
    
    CGSize resultSize;
    if (scaleWidth <= 1 && scaleHeight <= 1) {
        resultSize = CGSizeMake(image.size.width, image.size.height);
    } else if (scaleWidth > scaleHeight) {
        biggerScale = scaleWidth;
        CGFloat resultWidth = self.frame.size.width;
        CGFloat resultHeight = image.size.height / scaleWidth;
        resultSize = CGSizeMake(resultWidth, resultHeight);
    } else {
        biggerScale = scaleHeight;
        CGFloat resultHeight = self.frame.size.height;
        CGFloat resultWidth = image.size.width / scaleHeight;
        resultSize = CGSizeMake(resultWidth, resultHeight);
    }
    
    self.maxViewZoomScale = (biggerScale > 1 ? biggerScale * self.maxImageZoomScale : self.maxImageZoomScale);
    
    return resultSize;
}

- (void)handleSingleTap:(UIGestureRecognizer *)gesture {
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (self.longPressGestureBlock) {
        self.longPressGestureBlock([gesture locationInView:self], gesture.state);
    }
}

- (void)setStatus:(FZImageViewZoomStatus)status {
    _status = status;
    if (FZImageViewZoomStatusNormal == status) {
        [self setZoomScale:1.0 animated:YES];
    }
}

- (void)setSingleTapEanble:(BOOL)singleTapEanble {
    _singleTapEanble = singleTapEanble;
    [self.singleTapGesture setEnabled:singleTapEanble];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
    if (self.status == FZImageViewZoomStatusNormal) {
        if (self.maxViewZoomScale > 1.0) {
            CGRect zoomRect = [self zoomRectForScale:self.maxViewZoomScale withCenter:[gesture locationInView:gesture.view]];
            [self zoomToRect:zoomRect animated:YES];
            
            self.status = FZImageViewZoomStatusExpand;
        }
    } else {
        self.status = FZImageViewZoomStatusNormal;
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height =  self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);

    return zoomRect;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (self.contentSize.height < self.frame.size.height) {
        CGRect tempFrame = self.imageView.frame;
        CGPoint newOrigin = CGPointMake(tempFrame.origin.x, (self.frame.size.height - self.contentSize.height) / 2);
        tempFrame.origin = newOrigin;
        self.imageView.frame = tempFrame;
    } else {
        CGRect tempFrame3 = self.imageView.frame;
        CGPoint newOrigin3 = CGPointMake(tempFrame3.origin.x, 0);
        tempFrame3.origin = newOrigin3;
        self.imageView.frame = tempFrame3;
    }
    
    if (self.contentSize.width < self.frame.size.width) {
        CGRect tempFrame2 = self.imageView.frame;
        CGPoint newOrigin2 = CGPointMake((self.frame.size.width - self.contentSize.width) / 2, tempFrame2.origin.y);
        tempFrame2.origin = newOrigin2;
        self.imageView.frame = tempFrame2;
    } else {
        CGRect tempFrame4 = self.imageView.frame;
        CGPoint newOrigin4 = CGPointMake(0, tempFrame4.origin.y);
        tempFrame4.origin = newOrigin4;
        self.imageView.frame = tempFrame4;
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

//当滑动结束时
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    if (scale > 1.0f) {
        self.status = FZImageViewZoomStatusExpand;
    } else {
        self.status = FZImageViewZoomStatusNormal;
    }
}

- (void)setImageWithURL:(NSURL *)url
            placeholder:(UIImage *)placeholderImage
         completedBlock:(void(^)(UIImage *image))completedBlock {
    self.image = placeholderImage;
    [self updateScrollViewZoomScaleWithImage:placeholderImage];
    
    [self.imageView sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            self.image = image;
            [self updateScrollViewZoomScaleWithImage:image];
        }
        
        if (completedBlock) {
            completedBlock(image);
        }
    }];
}


- (void)setMaxImageZoomScale:(CGFloat)maxImageZoomScale {
    _maxImageZoomScale = maxImageZoomScale;
    [self calculateImageViewOriginSize:self.image];
}

- (void)updateScrollViewZoomScaleWithImage:(UIImage *)image {
    if (image == nil || self.frame.size.width == 0 || self.frame.size.height == 0) {
        return;
    }
    CGSize showSize = [self calculateImageViewOriginSize:image];
    if (showSize.width == 0 || showSize.height == 0) {
        return;
    }
    self.imageView.frame = CGRectMake((self.frame.size.width - showSize.width) / 2, (self.frame.size.height - showSize.height) / 2, showSize.width, showSize.height);
    self.contentSize = self.imageView.bounds.size;
    self.maximumZoomScale = self.maxViewZoomScale;
}

#pragma mark - Override 

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    if (self.status != NIEImageViewZoomStatusExpand) {
////        [self updateScrollViewZoomScaleWithImage:self.image];
//        self.imageView.center = self.center;
//     }
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    
    if (self.status != FZImageViewZoomStatusExpand) {
        [self updateScrollViewZoomScaleWithImage:self.image];
        self.imageView.center = self.center;
    }
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.status != FZImageViewZoomStatusExpand) {
        [self updateScrollViewZoomScaleWithImage:self.image];
        self.imageView.center = self.center;
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.status != FZImageViewZoomStatusExpand) {
        [self updateScrollViewZoomScaleWithImage:self.image];
        self.imageView.center = self.center;
    }
}
@end
