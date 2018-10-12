//
//  ViewController.m
//  noteBook
//
//  Created by csdc-iMac on 2018/9/13.
//  Copyright © 2018年 K. All rights reserved.
//

#import "ViewController.h"
#import "CellModel.h"
#import "FMDBManager.h"

@interface ViewController ()
@property (nonatomic,strong) AddNoteViewController *addVC;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *ediBtn;
@property (nonatomic,retain) UISearchController *searchController;
@property (nonatomic,strong) DetailViewController *detailVC;
@property (nonatomic,strong) NSMutableArray *textArray;
@property (nonatomic,strong) NSMutableArray *searchArray;
@end

@implementation ViewController
{
    FMDBManager *manager;
    NSInteger deleteIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor darkGrayColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=@"记事本";
    
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addBtn addTarget:self action:@selector(addnew) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    addBtn.titleLabel.font=[UIFont systemFontOfSize:24];
    [addBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-30)  collectionViewLayout:layout];  //刚开始没有UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init]; 和collectionViewLayout:layout  报错“UICollectionView must be initialized with a non-nil layout parameter”
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[NoteCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];   //注册cell
    //没有这一句也会报错 “could not dequeue a view of kind: UICollectionElementKindCell with identifie”
    layout.minimumLineSpacing=10;
    
    self.ediBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.ediBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.ediBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.ediBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithCustomView:self.ediBtn];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    //搜索栏
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate=self;
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.placeholder=@"请输入要搜索的内容";
    self.searchController.searchBar.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40);
    self.definesPresentationContext=YES;
    self.searchController.dimsBackgroundDuringPresentation=NO;
    self.searchController.obscuresBackgroundDuringPresentation=NO;
    [self.view addSubview:self.searchController.searchBar];
    
    self.dataArray=[[NSMutableArray alloc]init];  //创建数组
    self.searchArray=[[NSMutableArray alloc]init];
    manager = [FMDBManager sharedDBManager];
    [manager creatTable];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *array = [manager selectNotes];
    self.dataArray=(NSMutableArray *)array;
}

-(void)addNote:(AddNoteViewController *)addVC{   //增加新的记事本 ,实现协议定义的方法
//    NoteCollectionViewCell *cell=[[NoteCollectionViewCell alloc]init];
//    cell.tex.text=note;    //无效的想法
   //删除过记事本之后，新增加的有删除按键？？？？不删除就没事 → 因为删除过后，新增加的记事本是从重用队列中取，根本没经过notecollectionviewcell的init方法，而设定deletebutton为隐藏属性的createUI方法是写在init中的，所以新增加的有deletebutton
    CellModel *tempNote=[[CellModel alloc] init];   //加入新的model
    tempNote.date = addVC.timeLabel.text;
    tempNote.content = addVC.tex.text;
    
    [manager addNewNote:tempNote];
    [self.dataArray addObject:tempNote];   //往数据源中添加model
    [self.collectionView reloadData];  //刷新界面
}

-(void)saveNote:(NSString *)time and:(NSString *)content{
    CellModel *tempNote=self.dataArray[deleteIndexPath];  //取出当前被修改的model
//    CellModel *tempNote = [[CellModel alloc] init];   //新建model错误，因为可能存在赋值不完整、数据缺失的情况，所以还是选择修改model ，而不是新建model并赋值
    tempNote.date = time;
    tempNote.content = content;
    [self.dataArray replaceObjectAtIndex:deleteIndexPath withObject:tempNote];
    [manager updateNote:tempNote];
//    [self.dataArray addObject:note];  //错误写法，因为是更新cell值，所以是用replaceObjectAtIndex，修改当前项数据
    
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.searchController.active){
        return self.searchArray.count;
    }else{
        return self.dataArray.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{

    NoteCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    if(self.searchController.active){
        cell.tex.text=self.searchArray[indexPath.row];
    }else{
        CellModel *tempNote=nil;
        tempNote = self.dataArray[indexPath.row];
        cell.tex.text=tempNote.content;
    }
    if([self.ediBtn.titleLabel.text isEqualToString: @"编辑"]) {
        cell.deleteBtn.hidden = YES;  //重新加载页面就会进入这个方法，要么是在cellForItem里面判断要么是在cell文件定义的方法中判断
    }else {
        cell.deleteBtn.hidden = NO;
    }
    cell.delegate=self;   //设置代理
    return cell;
}


-(void)deleteNote:(NoteCollectionViewCell *)noteCollectionViewCell{  //实现代理的方法
    NSIndexPath *indexPath=[self.collectionView indexPathForCell:noteCollectionViewCell];   //获取当前cell所在位置
    [manager deleteNote:self.dataArray[indexPath.row]];
    [self.dataArray removeObjectAtIndex:indexPath.row];   //删除数据源中具体项

    NSArray *cellArray=[self.collectionView visibleCells];
    for(NoteCollectionViewCell *cell in cellArray){
        [cell shake];  //加上这语句删除了一个cell之后可以继续抖动了
    }
    [self.collectionView reloadData];
    NSLog(@"点击删除第%ld个",(long)indexPath.row+1);
}

-(CGSize)collectionView:(UICollectionView *) collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(80, 100);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(12, 12, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.detailVC=[[DetailViewController alloc]init];
    deleteIndexPath=indexPath.row;   //声明一个全局变量，用于存储选中的当前行行数
    self.detailVC.delegate=self;  //记得写delegate
    CellModel *tmpNote = nil;
    tmpNote = self.dataArray[indexPath.row];
    self.detailVC.detailText=tmpNote.content;
    self.detailVC.time=tmpNote.date;
//    self.detailVC.texi.text=self.dataArray[indexPath.row];  //为什么显示不出来 ？？ → 界面间的跳转只能传递值，比如上面用的是detailText来存放传递的值，不能直接为下一界面的textfield赋值
    
    [self.navigationController pushViewController:self.detailVC animated:YES];
    
}

-(void)edit:(UIButton *)sender{

    if([self.ediBtn.titleLabel.text isEqualToString: @"编辑"]){  //编辑时cell抖动，显示删除按键
        self.navigationItem.rightBarButtonItem.enabled=NO;  //使右边的增加按键无效
        [self.ediBtn setTitle:@"完成" forState:UIControlStateNormal];
        NSArray *cellArray=[self.collectionView visibleCells];
        for(NoteCollectionViewCell *cell in cellArray){
            [cell shake];
            cell.deleteBtn.hidden=NO;
        }
    }else{   //停止抖动，隐藏删除按键
        self.navigationItem.rightBarButtonItem.enabled=YES;   //使右边的增加按键有效
        [self.ediBtn setTitle:@"编辑" forState:UIControlStateNormal];
        NSArray *cellArray=[self.collectionView visibleCells];
        for(NoteCollectionViewCell *cell in cellArray){
            [cell shakeOff];
//             cell.deleteBtn.hidden=YES;   //隐藏删除按键
        }
        [self.collectionView reloadData];
    }
}


-(void) addnew{
    self.addVC=[[AddNoteViewController alloc]init];
    self.addVC.delegate=self;   //记得声明代理
    [self.navigationController pushViewController:self.addVC animated:YES];
}

-(NSMutableArray *)textArray {   //重写textarray的get方法
   self.textArray=[[NSMutableArray alloc]init];
    NSUInteger count= self.dataArray.count;
    for(int i=0; i<count; i++){
        CellModel *tempNote=self.dataArray[i];
        [_textArray addObject:tempNote.content];
    }
    return _textArray;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{   //搜索过滤
    NSString *searchString=self.searchController.searchBar.text;
    if(self.searchArray.count >0){
        [self.searchArray removeAllObjects];
    }
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchString];
    
//    self.textArray=[[NSMutableArray alloc]init];  //每次搜索的时候新建
//    NSUInteger count= self.dataArray.count;
//    for(int i=0; i<count; i++){
//        CellModel *tempNote=nil;
//        tempNote = self.dataArray[i];
//        [self.textArray addObject:tempNote.content];
//    }
    self.searchArray=[NSMutableArray arrayWithArray:[self.textArray filteredArrayUsingPredicate:predicate]];  //过滤数据
    
    [self.collectionView reloadData];   //刷新表格
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
