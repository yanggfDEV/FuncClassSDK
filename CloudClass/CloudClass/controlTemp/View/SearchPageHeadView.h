//
//  SearchPageHeadView.h
//  EnglishTalk
//
//  Created by DING FENG on 1/5/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ValueChangedBlock_search)(NSString *type,NSString *level,NSString *sort);

@interface SearchPageHeadView : UITableViewCell



@property (weak, nonatomic) IBOutlet UIButton *searchButton;



//--------------------------------------------------------


@property (weak, nonatomic) IBOutlet UIButton *typeBtn0;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn3;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn4;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn5;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn6;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn7;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn8;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn9;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn10;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn11;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn12;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn13;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn14;










//--------------------------------------------------------


@property (weak, nonatomic) IBOutlet UIButton *levelBtn0;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn1;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn2;
@property (weak, nonatomic) IBOutlet UIButton *levelBtn3;

//--------------------------------------------------------

@property (weak, nonatomic) IBOutlet UIButton *sortBtn0;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn1;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn2;



@property (nonatomic,strong)  NSString  *type;
@property (nonatomic,strong)  NSString  *level;
@property (nonatomic,strong)  NSString  *sort;
@property (nonatomic,strong)  ValueChangedBlock_search  valueChangedBlock;

@property (weak, nonatomic) IBOutlet UIView *blackline;

@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIButton *arrowbtn;

-(void)defaultLevel:(NSString*)level   sort:(NSString *)sort;



@end
