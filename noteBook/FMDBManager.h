//
//  FMDBManager.h
//  noteBook
//
//  Created by csdc-iMac on 2018/10/9.
//  Copyright © 2018年 K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface FMDBManager : NSObject

+ (id)sharedDBManager;
- (void)creatTable;
- (void)addNewNote:(CellModel *)note;
- (void)updateNote:(CellModel *)note;
- (void)deleteNote:(CellModel *)note;
- (NSArray *)selectNotes;


@end
