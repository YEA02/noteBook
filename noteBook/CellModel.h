//
//  CellModel.h
//  noteBook
//
//  Created by csdc-iMac on 2018/10/9.
//  Copyright © 2018年 K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *date;
@property (nonatomic, assign) NSInteger ID;
@end
