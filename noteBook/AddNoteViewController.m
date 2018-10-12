//
//  AddNoteViewController.m
//  noteBook
//
//  Created by csdc-iMac on 2018/9/13.
//  Copyright © 2018年 K. All rights reserved.
//

#import "AddNoteViewController.h"
#define KCompressibilityFactor 280.00

@interface AddNoteViewController ()
@end

@implementation AddNoteViewController
{
    NSTimer *timeNow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加新事件";
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;  //界面会自动下移64像素到navigationBar下方
    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    imgV.image=[UIImage imageNamed: @"note.png"];
    imgV.userInteractionEnabled=YES;   //起初imageView上的textview不能输入文字，百度之后发现是因为imageView默认是不响应事件的，所以要加上这句语句
    [self.view addSubview:imgV];
    
    self.tex=[[UITextView alloc]initWithFrame:CGRectMake(40,110, self.view.bounds.size.width-80, self.view.bounds.size.height-80)];
    self.tex.backgroundColor=[UIColor clearColor];
    [self.tex setFont:[UIFont systemFontOfSize:20]];
    [imgV addSubview:self.tex];
    
    self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-200)/2, self.view.bounds.size.height-64-30, 200, 30)];
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    [imgV addSubview:self.timeLabel];
    timeNow=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(getTime) userInfo:nil repeats:YES];   //加入计时器并且时间在走
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:saveBtn];

    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightBtn,nil] ];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftBtn;

}

-(void)getTime{
    NSString *currentTime=nil;
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"MM/dd/YYYY HH:mm:ss";
    currentTime=[formatter stringFromDate:date];
    self.timeLabel.text= currentTime;
}

-(void)save{
    [self.delegate addNote:self];   //代理方法中传的是self
    
    [self.navigationController popViewControllerAnimated:YES];
}






-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{ //点击空白区域，收回键盘
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
