//
//  AddNoteViewController.h
//  noteBook
//
//  Created by csdc-iMac on 2018/9/13.
//  Copyright © 2018年 K. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddNoteViewController;
@protocol AddProtocol <NSObject>  //创建协议
-(void) addNote:(AddNoteViewController *) addVC;   //声明方法
@end

@interface AddNoteViewController : UIViewController
@property UITextView *tex;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,weak) id<AddProtocol>delegate;  //声明协议变量
@end
