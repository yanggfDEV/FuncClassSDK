//
//  CouserAlbumCell.m
//  EnglishTalk
//
//  Created by DING FENG on 10/9/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "CouserAlbumCell.h"
#import <AFNetworking.h>
#import <FZNetWorkManager.h>
#import "ProgressHUD.h"

@implementation CouserAlbumCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
//    @property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
//    @property (weak, nonatomic) IBOutlet UIButton *downBtn;
//    @property (weak, nonatomic) IBOutlet UIImageView *heartIcon;
//    @property (weak, nonatomic) IBOutlet UIImageView *downIcon;

    

    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)collectionBtn:(UIButton *)sender {
    
    [sender  setTitle:@"已收藏" forState:UIControlStateNormal];
    [sender  setTitleColor:[UIColor colorWithRed:151./255 green:207./255 blue:60./255 alpha:1] forState:UIControlStateNormal];
    self.heartIcon.image = [self.heartIcon.image  imageWithColor:[UIColor colorWithRed:151./255 green:207./255 blue:60./255 alpha:1]];

    NSString *course_id = [self.courseInfoDict  objectForKey:@"id"]; ;
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"course_collect"];
    NSDictionary *parameters = [@{} mutableCopy];
    [parameters setValue:course_id forKey:@"course_id"];
    
    [[FZNetWorkManager sharedInstance] POST:urlString parameters:parameters responseDtoClassType:nil success:^(id responseObject) {
        if ([responseObject  isKindOfClass:[NSDictionary class]])
        {
            if ([responseObject objectForKey:@"status"]==0)
            {
                [ProgressHUD showError:[responseObject objectForKey:@"msg"]];
            }else{
                [ProgressHUD showSuccess:[responseObject objectForKey:@"msg"]];
            }
        }
    } failure:^(id responseObject, NSError *error) {
        [ProgressHUD showError:@"操作失败，请重试"];
    }];
    
    
    
    
}
- (IBAction)downLoadBtn:(id)sender {
    /*这个地方 同步和异步 用法*/
    if ([[LocalCourseCenter  sharedInstance].LocalCourseDictionary.allKeys   containsObject:[self.courseInfoDict   objectForKey:@"id"]]) {
        [ProgressHUD  showSuccess:@"这课你已经缓存了！"];
        return;
    }
    CourseLoader   *Cl = [[CourseLoader alloc]  init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [Cl  downloadCourse:self.courseInfoDict];
        if ([[LocalCourseCenter  sharedInstance].LocalCourseDictionary.allKeys   containsObject:[self.courseInfoDict   objectForKey:@"id"]])
        {
            NSLog(@"怎么回事！！！ 有了  ");
        }else
        {
            NSLog(@"怎么回事！！！还木有  ");
            dispatch_sync(dispatch_get_main_queue(), ^
                          {
                              [ProgressHUD  showError:@"同学！下载没成功请再试一下!"];
                              ((UIButton *)sender).selected=NO;
                              
                          });
        }
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseLoader" object:Cl userInfo:nil];
    [ProgressHUD  showSuccess:@"已经添加到缓存列表！"];
}
-(void)layoutSubviews{

    //id = 702;
    if ( [[self.courseInfoDict   objectForKey:@"is_collect"]    intValue]==0) {
    }else{
        [self.collectionBtn  setTitle:@"已收藏" forState:UIControlStateNormal];
        [self.collectionBtn  setTitleColor:[UIColor colorWithRed:151./255 green:207./255 blue:60./255 alpha:1] forState:UIControlStateNormal];
        
        self.heartIcon.image = [self.heartIcon.image  imageWithColor:[UIColor colorWithRed:151./255 green:207./255 blue:60./255 alpha:1]];

    }
    if ([[LocalCourseCenter  sharedInstance].LocalCourseDictionary.allKeys   containsObject:[self.courseInfoDict   objectForKey:@"id"]])
    {
        [self.downBtn  setTitle:@"已下载" forState:UIControlStateNormal];
        [self.downBtn  setTitleColor:[UIColor colorWithRed:151./255 green:207./255 blue:60./255 alpha:1] forState:UIControlStateNormal];
        self.downIcon.image = [self.downIcon.image  imageWithColor:[UIColor colorWithRed:151./255 green:207./255 blue:60./255 alpha:1]];
    }
}
@end
