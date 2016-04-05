//
//  FZSetUserInformationViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZSetUserInformationViewController.h"
#import "FZUserCenterSectionModel.h"
#import "FZUserCenterModel.h"
#import "FZUserInformationCell.h"
#import "FZPersonCenterConstants.h"
#import "FZSetNickNameViewController.h"
#import "UIViewController+ActionSheet.h"
#import "FZPersonCenterService.h"
#import "FZUpYunSignModel.h"
#import "UpYun.h"

@interface FZSetUserInformationViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *personSectionsArray;
@property (assign, nonatomic) NSInteger choicePhotoType;//(0:头像操作 1:背景操作)
@property (nonatomic, strong) FZPersonCenterService *service;
@property (nonatomic, strong) FZUpYunSignModel *signModel;

@end

@implementation FZSetUserInformationViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"personCenter_title");
    [self initialization];
    [self getUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self noHorizontalScreen];
}

- (void)noHorizontalScreen{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        //orientation
        [[UIApplication sharedApplication]
         setStatusBarOrientation:UIInterfaceOrientationPortrait
         animated:NO];
        
        [[UIDevice currentDevice]
         setValue:[NSNumber
                   numberWithInteger:UIInterfaceOrientationPortrait]
         forKey:@"orientation"];
    }
}


#pragma mark - initialization
- (void)initialization {
    self.service = [[FZPersonCenterService alloc] init];
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 52.0f;
    self.tableView.backgroundColor = css.colorOfBackground;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"FZUserInformationCell" bundle:nil] forCellReuseIdentifier:kFCUserInformationCellIndentifier];
    
    self.view.backgroundColor = css.colorOfBackground;
}

- (void)getUserInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cloudClass_config" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *sectionJSONArray = jsonDictionary[@"config_data"];
    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:[FZUserCenterSectionModel class] fromJSONArray:sectionJSONArray error:nil];
    self.personSectionsArray = [modelArray mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FZUserCenterSectionModel *centerSectionModel = [self.personSectionsArray objectAtIndex:section];
    return centerSectionModel.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZUserInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:kFCUserInformationCellIndentifier];
    FZUserCenterSectionModel *centerSectionModel = [self.personSectionsArray objectAtIndex:indexPath.section];
    FZUserCenterModel *userCenterModel = [centerSectionModel.cellModels objectAtIndex:indexPath.row];
    [cell setCellData: userCenterModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self setHeadImage];
        } else if (indexPath.row == 1) {
            [self setNickName];
        }
    }
}

#pragma mark -- 编辑个人信息
//修改头像
- (void)setHeadImage {
    self.choicePhotoType = 0;
    [self choicePhoto:@"头像操作"];
}

//修改昵称
- (void)setNickName {
    WEAKSELF
    FZSetNickNameViewController *setNickNameVC = [[FZSetNickNameViewController alloc] init];
    setNickNameVC.setNickNameSuccessBlock = ^() {
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:setNickNameVC animated:YES];
}

#pragma mark 图片选择
- (void)choicePhoto:(NSString*)tipTitle{
    [self noHorizontalScreen];
    NSArray *titles = @[@"取消", @"从相册选择", @"拍照"];
    
    ClickCompletion cancle = ^(){
        NSLog(@"取消了。。。。。。。");
    };
    ClickCompletion album = ^(){
        NSLog(@"从相册选择。。。。。。。");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //资源类型为图片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = NO;
        [self  presentViewController:picker animated:YES completion:nil];
    };
    ClickCompletion photograph = ^(){
        NSLog(@"拍照。。。。。。。");
        //资源类型为照相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有相机
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = NO;
            //资源类型为照相机
            picker.sourceType = sourceType;
            [self  presentViewController:picker animated:YES completion:nil];
        }else {
            NSLog(@"该设备无摄像头");
        }
    };
    
    [self showActionSheetTitle:nil clickCompletionTitles:titles clickCompletions:@[cancle, album, photograph]];
}

#pragma mark UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInf{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        if (self.choicePhotoType == 0) {
            width = 200;
            height = 200;
        } else {
            CGFloat maxWidth = 750;
            if (width > height) {
                if(width > maxWidth){
                    CGFloat scale = maxWidth / width;
                    height = scale * height;
                    width = maxWidth;
                }
            } else {
                if (height > maxWidth) {
                    CGFloat scale = maxWidth / height;
                    width = scale * width;
                    height = maxWidth;
                }
            }
            
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [image drawInRect:CGRectMake(0, 0, width, height)];
        UIImage* scaleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (scaleImage) {
            if (self.choicePhotoType == 0) {
                NSData *data = UIImageJPEGRepresentation((scaleImage), 1);
                [self uploadAvatar:data];
            } else {
//                NSData *data = UIImageJPEGRepresentation((scaleImage), 0.4);
//                [self uploadBackgroud:data];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片格式错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//上传头像
- (void)uploadAvatar:(NSData *)data {
    WEAKSELF
    [self.service getUpyunSign:^(NSInteger statusCode, NSString *message, id dataObject) {
        if (statusCode == kFZRequestStatusCodeSuccess) {
            weakSelf.signModel = dataObject;
            [weakSelf uploadUpYun:data];
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
    }];
}

- (void)uploadUpYun:(NSData *)image {
    UpYun *upYun = [[UpYun alloc] init];
    upYun.bucket = self.signModel.pic[@"bucket"];
    NSString *policy = self.signModel.pic[@"policy"];
    NSString *signature = self.signModel.pic[@"sign"];
    WEAKSELF
    upYun.successBlocker = ^(id data) {
        [weakSelf uploadImage:data[@"url"]];
    };
    upYun.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"error" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    };
    [upYun uploadFile:image policy:policy signature:signature];
}

- (void)uploadImage:(NSString *)photoUrl {
    WEAKSELF
    [self startProgressHUDWithText:LOCALSTRING(@"person_set_headimage")];
    BOOL isSetNickName = NO;
    [self.service setUsetInfo:isSetNickName nickName:nil avatar:photoUrl success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            [weakSelf showHUDHintWithText:LOCALSTRING(@"person_set_head_success")];
            NSDictionary *dictionary = dataObject;
            [FZLoginUser setAvatar:dictionary[@"avatar"]];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"person_set_head_failure")];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
