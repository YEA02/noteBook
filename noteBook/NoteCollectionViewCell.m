//
//  NoteCollectionViewCell.m
//  noteBook
//
//  Created by csdc-iMac on 2018/9/14.
//  Copyright © 2018年 K. All rights reserved.
//

#import "NoteCollectionViewCell.h"

@implementation NoteCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

-(void)createUI{
   
    self.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"note"]];   //背景图片
    self.deleteBtn=[[UIButton alloc]init];
    self.deleteBtn.frame=CGRectMake(0, 10, 35, 35);
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteBtn];
    self.tex=[[UILabel alloc]initWithFrame:self.bounds];
    self.tex.textAlignment=NSTextAlignmentCenter; 
    [self.contentView addSubview:self.tex];
}


-(void)deleteClick{
    if([self.delegate respondsToSelector:@selector(deleteNote:)]){  //respondsToSelector方法判断该方法是否被响应
        [self.delegate deleteNote:self];  //如果方法被响应，调用代理的方法
    }
}


-(void)shake{
        srand([[NSDate date] timeIntervalSince1970]);
        float rand=(float)random();
        CFTimeInterval t=rand*0.0000000001;
        [UIView animateWithDuration:0.1 delay:t options:0  animations:^ {
            self.transform=CGAffineTransformMakeRotation(-0.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^ {
                self.transform=CGAffineTransformMakeRotation(0.05);
            } completion:nil];
        }];
}

-(void)shakeOff{
       [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^ {
        self.transform=CGAffineTransformIdentity;
       } completion:nil];

}

@end
