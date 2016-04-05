
#import "MBProgressHUD.h"
@interface MBProgressHUD (FZ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;


+ (void)showDetailText:(NSString *)detailText icon:(NSString *)icon view:(UIView *)view;
+ (void)showDetailSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showDetailSuccess:(NSString *)success;


@end
