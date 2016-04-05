//
//  UserPhotoTableViewCell.m
//  EnglishTalk
//
//  Created by DING FENG on 10/14/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "UserPhotoTableViewCell.h"
#import "EXPhotoViewer.h"

@implementation UserPhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imag0.userInteractionEnabled =YES;
    self.imag1.userInteractionEnabled =YES;
    self.imag2.userInteractionEnabled =YES;
    
    
    self.imag0.contentMode =UIViewContentModeScaleAspectFit;
    self.imag1.contentMode =UIViewContentModeScaleAspectFit;
    self.imag2.contentMode =UIViewContentModeScaleAspectFit;
    
    self.imag0.backgroundColor = [UIColor   lightTextColor];
    self.imag1.backgroundColor = [UIColor   lightTextColor];
    self.imag2.backgroundColor = [UIColor   lightTextColor];


    
    
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap0:)];
    [self.imag0 addGestureRecognizer:tap0];

    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
    [self.imag1 addGestureRecognizer:tap1];

    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
    [self.imag2 addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress0:)];
    [self.imag0 addGestureRecognizer:longPress0];
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress1:)];
    [self.imag1 addGestureRecognizer:longPress1];
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress2:)];
    [self.imag2 addGestureRecognizer:longPress2];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)tap0:(id)sender{
    
    NSMutableDictionary  *md =[[NSMutableDictionary alloc]  init];
    
    int  finalIndex = self.indexNum*3+0;
    [md  setObject:[NSString  stringWithFormat:@"%d",finalIndex] forKey:@"photoIndex"];
    
    if (self.imag0.image) {
        [md  setObject:self.imag0.image forKey:@"photo"];
        [EXPhotoViewer showImageFrom:self.imag0 index:finalIndex imgUrlArray:self.imgUrlArray];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_PhontoCellTaped" object:nil userInfo:md];
}
-(void)tap1:(id)sender{
    
    NSMutableDictionary  *md =[[NSMutableDictionary alloc]  init];

    int  finalIndex = self.indexNum*3+1;
    [md  setObject:[NSString  stringWithFormat:@"%d",finalIndex] forKey:@"photoIndex"];
    if (self.imag1.image) {
        [md  setObject:self.imag1.image forKey:@"photo"];
        [EXPhotoViewer showImageFrom:self.imag1 index:finalIndex imgUrlArray:self.imgUrlArray];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_PhontoCellTaped" object:md userInfo:md];
}

-(void)tap2:(id)sender{
    
    NSMutableDictionary  *md =[[NSMutableDictionary alloc]  init];
    int  finalIndex = self.indexNum*3+2;
    [md  setObject:[NSString  stringWithFormat:@"%d",finalIndex] forKey:@"photoIndex"];
    if (self.imag2.image) {
        [md  setObject:self.imag2.image forKey:@"photo"];
        [EXPhotoViewer showImageFrom:self.imag2 index:finalIndex imgUrlArray:self.imgUrlArray];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_PhontoCellTaped" object:nil userInfo:md];
}




-(void)longPress0:(UILongPressGestureRecognizer*)sender{
    
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        //Do Whatever You want on End of Gesture
        NSMutableDictionary  *md =[[NSMutableDictionary alloc]  init];
        int  finalIndex = self.indexNum*3+0;
        [md  setObject:[NSString  stringWithFormat:@"%d",finalIndex] forKey:@"photoIndex"];
        if (self.imag0.image) {
            [md  setObject:self.imag0.image forKey:@"photo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_PhontoCellLongPressed" object:nil userInfo:md];
        }
    }
    else if (sender.state == UIGestureRecognizerStatePossible){
        NSLog(@"nUIGestureRecognizerStateEnded.");
    }
}
-(void)longPress1:(UILongPressGestureRecognizer*)sender{
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        //Do Whatever You want on End of Gesture
        NSMutableDictionary  *md =[[NSMutableDictionary alloc]  init];
        int  finalIndex = self.indexNum*3+1;
        [md  setObject:[NSString  stringWithFormat:@"%d",finalIndex] forKey:@"photoIndex"];
        
        
        if (self.imag1.image) {
            [md  setObject:self.imag1.image forKey:@"photo"];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_PhontoCellLongPressed" object:nil userInfo:md];
        }
        
    }
    else if (sender.state == UIGestureRecognizerStatePossible)
    {
        NSLog(@"nUIGestureRecognizerStateEnded.");

    }

}
-(void)longPress2:(UILongPressGestureRecognizer*)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //Do Whatever You want on End of Gesture
        NSLog(@"UIGestureRecognizerStateBegan.");
        NSMutableDictionary  *md =[[NSMutableDictionary alloc]  init];
        int  finalIndex = self.indexNum*3+2;
        [md  setObject:[NSString  stringWithFormat:@"%d",finalIndex] forKey:@"photoIndex"];
        
        if (self.imag2.image) {
            [md  setObject:self.imag2.image forKey:@"photo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_PhontoCellLongPressed" object:nil userInfo:md];
        }
    }
    else if (sender.state == UIGestureRecognizerStatePossible)
    {
        NSLog(@"nUIGestureRecognizerStateEnded.");

    }
}


@end
