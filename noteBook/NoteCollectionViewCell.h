//
//  NoteCollectionViewCell.h
//  noteBook
//
//  Created by csdc-iMac on 2018/9/14.
//  Copyright © 2018年 K. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@class NoteCollectionViewCell;
@protocol NoteCollectionViewCellDelegate <NSObject>  
@optional
-(void)deleteNote:(NoteCollectionViewCell *)noteCollectionViewCell;
@end

@interface NoteCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIButton *ediBtn;
@property (nonatomic,strong) UILabel *tex;
@property (nonatomic,weak) id <NoteCollectionViewCellDelegate> delegate;
-(void)shake;
-(void)shakeOff;

@end
