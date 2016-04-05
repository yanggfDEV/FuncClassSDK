//
//  FZPhotosViewerViewController
//
//  Created by CyonLeu on 15/1/13.
//

#import <SDWebImage/SDImageCache.h>
#import <Masonry/Masonry.h>
#import <Mantle/MTLJSONAdapter.h>

#import "FZPhotosViewerViewController.h"
#import "FZUIImageScrollView.h"
#import "FZPhotosViewerCollectionViewCell.h"
#import "FZTransitonAnimationImageView.h"
#import "MBProgressHUD.h"
#import "FZLocalization.h"
#import "FCChatCache.h"
#define PX_MARK_TO_REAL(x) ((x)/(640.0/320.0))
#define P2P(x) (PX_MARK_TO_REAL(x))

/**
 * @guangfu yang
 *
 **/
static NSString *const dnSaveButtonTintNormalColor = @"#89ca30";

static NSString *const kFZPhotosViewerCollectionViewCell = @"FZPhotosViewerCollectionViewCell";

@interface FZPhotosViewerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) FZTransitonAnimationImageView *backgroundImageView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (assign, nonatomic) BOOL edgeControlHidden;
//@property (assign, nonatomic) BOOL shadowHidden;
//view control
@property (assign, nonatomic) BOOL tapToExit;  //Default is YES;
@property (assign, nonatomic) BOOL onlyShowPageNumber; //Default is YES;

@property (strong, nonatomic) UILabel *pageLabel;
@property (strong, nonatomic) UIImageView *shadowImageView;

/**
 * @guangfu yang
 * 自定义一个导航栏
 **/
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UILabel *naviViewtitle;

@end

@implementation FZPhotosViewerViewController


#pragma mark - Life & Circle

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index shareData:(NSDictionary *)shareData{
    self = [super init];
    if (self) {
        self.tapToExit = YES;
        self.onlyShowPageNumber = YES;
        self.photosArray = photos;

        if (photos.count > index) {
            self.currentIndex = index;
        } else {
            self.currentIndex = 0;
        }

    }
    return self;
}

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index {
    return [self initWithPhotos:photos currentIndex:index shareData:nil];
}


- (instancetype)initWithEntryParams:(NSDictionary *)entryParams{
    NSArray *photos = [MTLJSONAdapter modelsOfClass:[FZPhotosViewerModel class] fromJSONArray:entryParams[@"images"] error:nil];
    self = [self initWithPhotos:photos currentIndex:0];
    if(self){
//        [self configWithEntryParams:entryParams];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupView];
    [self initNavigationItem];
    //tap to exit
//    if (self.tapToExit) {
//        self.tapToExit = YES;
//        self.navigationController.navigationBarHidden = YES;
//    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    
    [self scrollToCurrentIndex];
    
    if (self.photosArray.count <= 1 && self.onlyShowPageNumber) {
        self.shadowImageView.hidden = YES;
    } else {
        self.shadowImageView.hidden = NO;
    }
    
    self.tabBarController.tabBar.hidden = YES;
    
//    if (self.tapToExit && !self.navigationController.navigationBarHidden) {
//        self.tapToExit = YES;
//        self.navigationController.navigationBarHidden = YES;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.tapToExit && !self.navigationController.navigationBarHidden) {
//        self.tapToExit = YES;
//        self.navigationController.navigationBarHidden = YES;
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[SDImageCache sharedImageCache] clearMemory];
    
}

/**
 * @guangfu yang 15-12-29
 * 添加保存按钮 隐藏返回按钮
 *
 **/

- (void)initNavigationItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存"  style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    item.tintColor = [UIColor colorWithRed:137 / 255.0 green:202 / 255.0 blue:48 / 255.0 alpha:1];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setUserInteractionEnabled:NO];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = itemBack;
    
}

- (void)save {
    
     [self saveImageToPhotos];
}

- (void)setupView {
    /**
     * @guangfu yang 15-12-29
     * 自定义导航栏
     **/
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    self.naviView = [[UIView alloc] init];
    [self.view addSubview:self.naviView];
    self.naviView.backgroundColor = [UIColor whiteColor];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    self.naviViewtitle = [[UILabel alloc] init];
    self.naviViewtitle.tintColor = [UIColor blackColor];
    self.naviViewtitle.font = [UIFont systemFontOfSize:17];
    [self.naviView addSubview:self.naviViewtitle];
    self.naviViewtitle.textAlignment = NSTextAlignmentCenter;
    [self.naviViewtitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.naviView.mas_centerX);
        make.centerY.equalTo(self.naviView.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [saveBtn setTitleColor:[UIColor colorWithRed:137 / 255.0 green:202 / 255.0 blue:48 / 255.0 alpha:1] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview: saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.naviView.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.trailing.equalTo(self.naviView).offset(-15);
    }];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.backgroundImageView = [[FZTransitonAnimationImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.transitonAnimation = YES;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    [self.view addSubview:self.backgroundImageView];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 65);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.f;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65) collectionViewLayout:layout];
    self.layout = layout;
    
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:kFZPhotosViewerCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kFZPhotosViewerCollectionViewCell];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self.view addSubview:collectionView];

    
    //    CGFloat bottomControlHeight = 44.f;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.leading.equalTo(self.view).with.offset(0.0f);
        make.trailing.equalTo(self.view).with.offset(0.0f);
        make.top.equalTo(self.naviView.mas_bottom).with.offset(0.0f);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    self.collectionView = collectionView;
    
    UILabel *pageLabel = [[UILabel alloc] init];
    pageLabel.backgroundColor = [UIColor clearColor];
    pageLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:pageLabel];
    self.pageLabel = pageLabel;
    self.pageLabel.hidden = YES;
    self.pageLabel.font = [UIFont systemFontOfSize:P2P(28)];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    
    //添加描述文字背景阴影遮罩
    UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    [self.view addSubview:shadowImageView];
    shadowImageView.hidden = YES;
    self.shadowImageView = shadowImageView;
//    self.shadowImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    self.shadowImageView.backgroundColor = [UIColor clearColor];
    self.shadowImageView.layer.cornerRadius = P2P(32);
    
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(P2P(108)));
        make.height.equalTo(@(P2P(67)));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-P2P(25));
    }];
    
    [self.view bringSubviewToFront:self.pageLabel];
   
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.center.equalTo(self.shadowImageView);
    }];
    
}


//- (BOOL)prefersStatusBarHidden {
//    return self.edgeControlHidden;
//}

- (void)scrollToCurrentIndex {
    if (self.photosArray.count > 0 && self.currentIndex < self.photosArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            [cell layoutIfNeeded];
        }
        [self setPageIndex:self.currentIndex descWithItem:self.photosArray[self.currentIndex]];
    }
}

- (NSString *)pageName {
    return @"图片选择器";
}

#pragma mark - show

- (void)showHintWithText:(NSString *)text {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hub.mode = MBProgressHUDModeText;
    //    hub.labelText = text;
    hub.detailsLabelText = text;
    hub.detailsLabelFont = [UIFont systemFontOfSize:14.0];
    hub.removeFromSuperViewOnHide = YES;
    [hub show:YES];
    [hub hide:YES afterDelay:2];
}

#pragma mark Proprety set&get

- (void)setControlHidden:(BOOL)isHidden {
    
    if (self.tapToExit) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
//    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationFade];
//    self.edgeControlHidden = isHidden;
//    [self.navigationController setNavigationBarHidden:isHidden animated:NO];
//    self.shadowImageView.hidden = (isHidden|self.shadowHidden);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.backgroundImageView.hidden = isHidden;
//        self.pageLabel.alpha = (isHidden ? 0 : 1);
//    } completion:^(BOOL finished) {
//        //        self.bottomContainerView.hidden = isHidden;
//    }];
    
}

//- (void)setBottomControlHidden:(BOOL)bottomControlHidden {
//    _bottomControlHidden = bottomControlHidden;
//}


- (void)setOnlyShowPageNumber:(BOOL)onlyShowPageNumber {
    _onlyShowPageNumber = onlyShowPageNumber;
}

- (void)setTapToExit:(BOOL)tapToExit {
    _tapToExit = tapToExit;
}

- (void)handleLongPressGesturePoint:(CGPoint)point state:(UIGestureRecognizerState)state {
    if (state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:!self.isEnglish?@"取消":@"Cancel" destructiveButtonTitle:nil otherButtonTitles:!self.isEnglish?@"保存图片":@"Save image", nil];
        [actionSheet showInView:self.view];
    }
}


- (void)setPageIndex:(NSUInteger)index descWithItem:(FZPhotosViewerModel *)item {
    NSString *desc = (item.desc && item.desc.length > 0 ? item.desc : self.desc);
    if (self.photosArray.count > 1) {
        [self updatePageString:[NSString stringWithFormat:@"%d/%d ", (int)(index + 1), (int)self.photosArray.count] desc:desc];
    } else {
        [self updatePageString:nil desc:desc];
    }
}

- (void)updatePageString:(NSString *)pageString desc:(NSString *)text {
//    self.pageLabel.text = pageString;
    self.naviViewtitle.text = pageString;
}

- (void)saveImageToPhotos {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    FZPhotosViewerCollectionViewCell *cell = (FZPhotosViewerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell && cell.blurSourceImage) {
        UIImageWriteToSavedPhotosAlbum(cell.blurSourceImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error) {
        [self showHintWithText:!self.isEnglish?LOCALSTRING(@"common_saveImageFailure"):@"Save to album failed."];
    }
    else {
        [self showHintWithText:!self.isEnglish?LOCALSTRING(@"common_saveImageSuccess"):@"Saved to album."];
    }
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FZPhotosViewerCollectionViewCell *cell = (FZPhotosViewerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kFZPhotosViewerCollectionViewCell forIndexPath:indexPath];
    
    typeof(self) __weak weakSelf = self;
    cell.didSelectBlock = ^(FZPhotosViewerCollectionViewCell *selectedCell) {
        [weakSelf setControlHidden:!weakSelf.edgeControlHidden];
        //        [selectedCell setBackgroundImageViewHidden:self.edgeControlHidden];
    };
    
    cell.longPressGestureBlock = ^(CGPoint point, UIGestureRecognizerState state) {
        [weakSelf handleLongPressGesturePoint:point state:state];
    };
    
    cell.index = indexPath.item;
    cell.imageCompletedBlock = ^(UIImage *image, NSUInteger index, NSString *url) {
       
    };
    
    FZPhotosViewerModel *item = self.photosArray[indexPath.item];
    //    [cell setBackgroundImageViewHidden:self.edgeControlHidden];
    [cell updateCellInfoForData:item];
    
    [cell layoutIfNeeded];
    
    return cell;
}

#pragma mark -  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setControlHidden:!self.edgeControlHidden];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    NSIndexPath *indexPath = [self currentVisiableIndexPathWithOffset:offset];
    if (!indexPath || self.currentIndex == indexPath.item) {
        return;
    }
    self.currentIndex = indexPath.item;
    
    FZPhotosViewerModel *item = self.photosArray[indexPath.item];
    [self setPageIndex:indexPath.item descWithItem:item];
    
    if (self.currentIndex >= 1) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    } else {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    }
}

- (NSIndexPath *)currentVisiableIndexPathWithOffset:(CGPoint)offset {
    NSIndexPath *resultIndexPath = nil;
    NSArray *visiableItems = [self.collectionView indexPathsForVisibleItems];
    if (visiableItems && visiableItems.count > 0) {
        resultIndexPath = [visiableItems lastObject];
        NSArray *visiableCells = [self.collectionView visibleCells];
        for (UICollectionViewCell *cell in visiableCells) {
            CGPoint cellOrign = cell.frame.origin;
            if (CGPointEqualToPoint(cellOrign, offset)) {
                resultIndexPath = [self.collectionView indexPathForCell:cell];
                break;
            }
        }
    }
    
    return resultIndexPath;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //保存
        [self saveImageToPhotos];
    }
    else if (buttonIndex == 1){
        //取消
    }
}

#pragma mark - 限制图片横屏显示
- (BOOL)shouldAutorotate
{
    return NO;
}
@end
