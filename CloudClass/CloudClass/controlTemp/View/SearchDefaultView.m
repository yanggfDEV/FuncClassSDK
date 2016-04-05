//
//  SearchDefaultView.m
//  EnglishTalk
//
//  Created by DING FENG on 9/24/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "SearchDefaultView.h"

@implementation SearchDefaultView


-(id)init
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"SearchDefaultView" owner:nil options:nil];
    self = [nibContents lastObject];
    return self;
}


- (IBAction)hashTagTap:(UIButton *)sender {
    
    
    
    
    
//    {
//        "status": 1,
//        "data": [
//                 {
//                     "nature_id": "294",
//                     "nature_title": "电影",
//                     "course_num": "7"
//                 },
//                 {
//                     "nature_id": "303",
//                     "nature_title": "演讲",
//                     "course_num": "6"
//                 },
//                 {
//                     "nature_id": "302",
//                     "nature_title": "发音",
//                     "course_num": "1"
//                 },
//                 {
//                     "nature_id": "301",
//                     "nature_title": "名人",
//                     "course_num": "4"
//                 },
//                 {
//                     "nature_id": "300",
//                     "nature_title": "节日",
//                     "course_num": "8"
//                 },
//                 {
//                     "nature_id": "299",
//                     "nature_title": "搞笑",
//                     "course_num": "6"
//                 },
//                 {
//                     "nature_id": "298",
//                     "nature_title": "歌曲",
//                     "course_num": "3"
//                 },
//                 {
//                     "nature_id": "297",
//                     "nature_title": "动漫", 
//                     "course_num": "6"
//                 }, 
//                 {
//                     "nature_id": "296", 
//                     "nature_title": "剧集", 
//                     "course_num": "5"
//                 }, 
//                 {
//                     "nature_id": "295", 
//                     "nature_title": "教育", 
//                     "course_num": "1"
//                 }
//                 ], 
//        "msg": ""
//    }

    
    NSString  *title =sender.titleLabel.text;
    NSString  *nature_id;
    
    
    if ([title isEqualToString:@"电影"]) {
        nature_id =@"294";
    }else  if ([title isEqualToString:@"演讲"]) {
        nature_id =@"303";

    }else  if ([title isEqualToString:@"发音"]) {
        nature_id =@"302";

    }else  if ([title isEqualToString:@"名人"]) {
        nature_id =@"301";

    }else  if ([title isEqualToString:@"节日"]) {
        nature_id =@"300";

    }else  if ([title isEqualToString:@"搞笑"]) {
        nature_id =@"299";

    }else  if ([title isEqualToString:@"歌曲"]) {
        nature_id =@"298";

    }else  if ([title isEqualToString:@"动漫"]) {
        nature_id =@"297";

    }else  if ([title isEqualToString:@"剧集"]) {
        nature_id =@"296";

    }else  if ([title isEqualToString:@"教育"]) {
        nature_id =@"295";

    }else  if ([title isEqualToString:@"记录"]) {
        nature_id =@"294";

    }else  if ([title isEqualToString:@"考试"]) {
        nature_id =@"304";

    }
    
    
    
    __weak SearchDefaultView *weakSelf = self;
    if (self.hashTagBlock) {
        weakSelf.hashTagBlock(nature_id);
    }
}





@end
