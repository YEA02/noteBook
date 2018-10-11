//
//  DetailViewController.h
//  noteBook
//
//  Created by csdc-iMac on 2018/9/17.
//  Copyright © 2018年 K. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveProtocol <NSObject>  //创建协议
-(void) saveNote:(NSString *)time and:(NSString *)content;   //声明方法
@end

@interface DetailViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSMutableAttributedString *detailText;
@property UITextView *texi;
@property UILabel *timeLabel;
@property (nonatomic,strong)  NSString *time;
@property (nonatomic,strong)  NSString *currentTime;
@property (nonatomic,weak) id<SaveProtocol>delegate;  //声明协议变量 
@end
