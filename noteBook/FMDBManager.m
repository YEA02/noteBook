//
//  FMDBManager.m
//  noteBook
//
//  Created by csdc-iMac on 2018/10/9.
//  Copyright © 2018年 K. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDatabase.h"

@interface FMDBManager () {
    FMDatabase *fMDatabase;
}
@end

@implementation FMDBManager
static FMDBManager *manager = nil;
static dispatch_once_t predicate;


+ (id)sharedDBManager{
    dispatch_once(&predicate, ^{
        if(manager == nil){
            manager = [[self alloc] init];
        }
    });
    return manager;
}
- (void)creatTable{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/myNote.db"];
    fMDatabase = [[FMDatabase alloc] initWithPath:path];
    BOOL isOpen = [fMDatabase open];
    if (isOpen) {
        NSLog(@"数据库打开成功!");
    } else {
        NSLog(@"数据库打开失败!");
    }
    
    NSString *sql = @"create table if not exists CellModel(ID integer primary key autoincrement, date varchar(256), content text)";
    if ([fMDatabase executeUpdate:sql]) {
        NSLog(@"表创建成功!");
        [fMDatabase close];
    } else {
        NSLog(@"表创建失败!");
    }
}

- (void)addNewNote:(CellModel *)note{
    BOOL isOpen = [fMDatabase open];
    if (isOpen) {
        NSLog(@"数据库打开成功!");
    } else {
        NSLog(@"数据库打开失败!");
    }
    
    NSString *sql = @"insert into CellModel(date,content) values(?,?)";
    NSString *date = note.date;
    NSString *newNote = note.content;
    if ([fMDatabase executeUpdate:sql, date, newNote]) {
        NSLog(@"数据插入成功!");
        
        [fMDatabase close];
    } else {
        NSLog(@"数据插入失败!");
    }
}

- (void)updateNote:(CellModel *)note{
    BOOL isOpen = [fMDatabase open];
    if (isOpen) {
        NSLog(@"数据库打开成功!");
    } else {
        NSLog(@"数据库打开失败!");
    }
    
    NSString *sql = [NSString stringWithFormat:@"update CellModel set content = '%@', date = '%@' where ID = '%zi'", note.content, note.date, note.ID];
    if ([fMDatabase executeUpdate:sql]) {
        NSLog(@"数据更新成功!");
        
        [fMDatabase close];
    } else {
        NSLog(@"数据更新失败!");
    }
}
- (void)deleteNote:(CellModel *)note{
    BOOL isOpen = [fMDatabase open];
    if (isOpen) {
        NSLog(@"数据库打开成功!");
    } else {
        NSLog(@"数据库打开失败!");
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from CellModel where date = '%@'", note.date];
    if ([fMDatabase executeUpdate:sql]) {
        NSLog(@"数据删除成功!");
        
        [fMDatabase close];
    } else {
        NSLog(@"数据删除失败!");
    }
}

- (NSArray *)selectNotes{
    BOOL isOpen = [fMDatabase open];
    if (isOpen) {
        NSLog(@"数据库打开成功!");
    } else {
        NSLog(@"数据库打开失败!");
    }
    
    NSString *sql = @"select * from CellModel";
    FMResultSet *set = [fMDatabase executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    while ([set next]) {
        CellModel *tmpNote = [[CellModel alloc] init];
        tmpNote.date = [set stringForColumn:@"date"];
        tmpNote.content = [set  stringForColumn:@"content"];
        tmpNote.ID = [set intForColumn:@"ID"];
        
        [array addObject:tmpNote];
    }
    
    [fMDatabase close];
    return array;
}
@end
