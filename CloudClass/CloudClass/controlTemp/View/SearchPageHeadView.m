//
//  SearchPageHeadView.m
//  EnglishTalk
//
//  Created by DING FENG on 1/5/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import "SearchPageHeadView.h"

@interface SearchPageHeadView()

{
    
    NSString  *_level;
    NSString  *_sort;
    NSString  *_type;
    
}

@end


@implementation SearchPageHeadView
@synthesize level=_level;
@synthesize sort =_sort;
@synthesize type =_type;


- (void)awakeFromNib {
    // Initialization code

    
    
    self.levelBtn0.tag =100;
    self.levelBtn1.tag =101;
    self.levelBtn2.tag =102;
    self.levelBtn3.tag =103;
    
    self.sortBtn0.tag =106;
    self.sortBtn1.tag =104;
    self.sortBtn2.tag =105;
    
    
    
    
    self.typeBtn0.tag =0;
    self.typeBtn1.tag =1;
    self.typeBtn2.tag =2;
    self.typeBtn3.tag =3;
    self.typeBtn4.tag =4;
    self.typeBtn5.tag =5;
    self.typeBtn6.tag =6;
    self.typeBtn7.tag =7;
    self.typeBtn8.tag =8;
    self.typeBtn9.tag =9;
    self.typeBtn10.tag =10;
    self.typeBtn11.tag =11;
    self.typeBtn12.tag =12;
    self.typeBtn13.tag =13;
    self.typeBtn14.tag =14;
    
    
    self.typeBtn0.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn0.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn1.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn1.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn2.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn2.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn3.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn3.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn4.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn4.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn5.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn5.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn6.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn6.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn7.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn7.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn8.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn8.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn9.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn9.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn10.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn10.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn11.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn11.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn12.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn12.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn13.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn13.layer.masksToBounds = YES; // 隐藏边界
    self.typeBtn14.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.typeBtn14.layer.masksToBounds = YES; // 隐藏边界
    
    
    
    self.levelBtn1.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.levelBtn1.layer.masksToBounds = YES; // 隐藏边界
    self.levelBtn2.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.levelBtn2.layer.masksToBounds = YES; // 隐藏边界
    self.levelBtn3.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.levelBtn3.layer.masksToBounds = YES; // 隐藏边界
    
    
    
    self.sortBtn1.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.sortBtn1.layer.masksToBounds = YES; // 隐藏边界
    self.sortBtn2.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.sortBtn2.layer.masksToBounds = YES; // 隐藏边界
    self.sortBtn0.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.sortBtn0.layer.masksToBounds = YES; // 隐藏边界
    self.levelBtn0.layer.cornerRadius = 15;  // 将图层的边框设置为圆脚
    self.levelBtn0.layer.masksToBounds = YES; // 隐藏边界
    
    
    
    
    
    [self.typeBtn0  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn1  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn2  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn3  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn4  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn5  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn6  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn7  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn8  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn9  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn10 addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn11 addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn12 addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn13 addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn14 addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];



    
    [self.levelBtn1  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.levelBtn2  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.levelBtn3  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.sortBtn1  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.sortBtn2  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.sortBtn0  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.levelBtn0  addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    self.backgroundColor = [UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0.95];
    self.bottomBar.hidden = YES;
    self.bottomBar.backgroundColor = [UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0];
    
    
    
    self.level =@"0";
    self.sort =@"0";
    self.type =@"0";
    
    
    self.backgroundColor =[UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0.95];
    self.contentView.backgroundColor =[UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0];

    
}

-(void)defaultLevel:(NSString*)level   sort:(NSString *)sort{
    self.level = level;
    self.sort =sort;
}



-(void)setType:(NSString *)type{

    _type = type;
    
    
    [self  deSelectTypeBtn];
    
    
    
    for (UIView  *v  in  self.contentView.subviews) {
        
        if ([v   isKindOfClass:[UIButton   class]]) {
            
            if ([type  intValue]<=14) {
                
                UIButton  *b = (UIButton  *)v;
                if (b.tag ==[type  intValue]) {
                    b.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
                    [b  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
                }
            }
        }
    }

    
    

}

-(void)setSort:(NSString *)sort{
    _sort =sort;
    
    
    switch ([_sort  intValue]) {
        case 0:
        {
            [self  deSelectSortBtn];
            
            self.sortBtn0.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
            [self.sortBtn0  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            
        }
            
            break;
            
        case 1:
        {
            [self  deSelectSortBtn];
            
            self.sortBtn1.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
            [self.sortBtn1  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            
        }
            
            break;
        case 2:
        {
            [self  deSelectSortBtn];
            
            self.sortBtn2.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
            [self.sortBtn2  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            
        }
            
            break;
            
            
        default:
            break;
    }
    
}
-(void)setLevel:(NSString *)level{
    _level =level;
    
    switch ([_level  intValue]) {
            
        case 0:
        {
            [self  deSelectLevelBtn];
            
            self.levelBtn0.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
            [self.levelBtn0  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            
        }
            break;
        case 1:
        {
            [self  deSelectLevelBtn];
            
            self.levelBtn1.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
            [self.levelBtn1  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            
        }
            break;
        case 2:
        {
            [self  deSelectLevelBtn];
            
            self.levelBtn2.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
            [self.levelBtn2  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            
        }
            
            break;
        case 3:
        {
            [self  deSelectLevelBtn];
            
            self.levelBtn3.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
            [self.levelBtn3  setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)btnTaped:(UIButton *)sender{
    
    
    switch (sender.tag) {
            
        case 100:
            self.level=@"0";
            break;
        case 101:
            self.level=@"1";
            break;
        case 102:
            self.level=@"2";
            break;
        case 103:
            self.level=@"3";
            break;
        case 104:
            self.sort =@"1";
            break;
        case 105:
            self.sort =@"2";
            break;
        case 106:
            self.sort=@"0";
            break;
        default:
            self.type= [NSString  stringWithFormat:@"%ld",(long)sender.tag];
            break;
    }
    self.valueChangedBlock(_type,_level,_sort);
}

-(void)deSelectLevelBtn{
    self.levelBtn0.backgroundColor = [UIColor  whiteColor];
    self.levelBtn1.backgroundColor = [UIColor  whiteColor];
    self.levelBtn2.backgroundColor = [UIColor  whiteColor];
    self.levelBtn3.backgroundColor = [UIColor  whiteColor];
    [self.levelBtn0  setTitleColor:[UIColor colorWithRed:131./255 green:131./255 blue:131./255 alpha:1] forState:UIControlStateNormal];
    [self.levelBtn1  setTitleColor:[UIColor colorWithRed:131./255 green:131./255 blue:131./255 alpha:1] forState:UIControlStateNormal];
    [self.levelBtn2  setTitleColor:[UIColor colorWithRed:131./255 green:131./255 blue:131./255 alpha:1] forState:UIControlStateNormal];
    [self.levelBtn3  setTitleColor:[UIColor colorWithRed:131./255 green:131./255 blue:131./255 alpha:1] forState:UIControlStateNormal];
}

-(void)deSelectSortBtn{
    
    self.sortBtn0.backgroundColor = [UIColor  whiteColor];
    self.sortBtn1.backgroundColor = [UIColor  whiteColor];
    self.sortBtn2.backgroundColor = [UIColor  whiteColor];
    
    [self.sortBtn0  setTitleColor:[UIColor colorWithRed:131./255 green:131./255 blue:131./255 alpha:1] forState:UIControlStateNormal];
    [self.sortBtn1  setTitleColor:[UIColor colorWithRed:131./255 green:131./255 blue:131./255 alpha:1] forState:UIControlStateNormal];
    [self.sortBtn2  setTitleColor:[UIColor colorWithRed:131./255 green:131./255 blue:131./255 alpha:1] forState:UIControlStateNormal];
    
}

-(void)deSelectTypeBtn{
    
    
    for (UIView  *v  in  self.contentView.subviews) {
        
        if ([v   isKindOfClass:[UIButton   class]]) {
            UIButton *b = (UIButton  *)v;
            
            if (b.tag <=14) {
                b.backgroundColor = [UIColor  whiteColor];
                [b  setTitleColor:[UIColor colorWithRed:131./255 green:131./255 blue:131./255 alpha:1] forState:UIControlStateNormal];
                NSLog(@"   btn   %ld   ",(long)b.tag);

            }
        }
    }
}


@end
