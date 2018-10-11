//
//  DetailViewController.m
//  noteBook
//
//  Created by csdc-iMac on 2018/9/17.
//  Copyright © 2018年 K. All rights reserved.
//

#import "DetailViewController.h"
#import "SVProgressHUD.h"
#define KCompressibilityFactor 280.00

@interface DetailViewController ()

@end

@implementation DetailViewController

{  
    NSTimer *timeNow;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"查看事件";
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;  //界面会自动下移64像素到navigationBar下方
    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    imgV.image=[UIImage imageNamed: @"note.png"];
    imgV.userInteractionEnabled=YES;   //起初imageView上的textview不能输入文字，百度之后发现是因为imageView默认是不响应事件的，所以要加上这句语句
    [self.view addSubview:imgV];
    
    self.texi=[[UITextView alloc]initWithFrame:CGRectMake(40,110, self.view.bounds.size.width-80, self.view.bounds.size.height-80)];
    self.texi.backgroundColor=[UIColor clearColor];
    [self.texi setFont:[UIFont systemFontOfSize:20]];
    self.texi.attributedText=self.detailText;  //通过上一界面传递过来的detailtext中的文本赋值
    [imgV addSubview:self.texi];
    
    self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-200)/2, self.view.bounds.size.height-64-30, 200, 30)];
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    self.timeLabel.text=self.time;
    [imgV addSubview:self.timeLabel];
    timeNow=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(getTime) userInfo:nil repeats:YES];   //加入计时器并且时间在走
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:saveBtn];
   
    UIButton *picBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [picBtn setTitle:@"插入图片" forState:UIControlStateNormal];
    [picBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [picBtn addTarget:self action:@selector(pic:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn2=[[UIBarButtonItem alloc]initWithCustomView:picBtn];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: rightBtn,rightBtn2,nil] ];
    
    //自定义返回按键的值
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    
    // Do any additional setup after loading the view.
}

-(void)getTime{
    self.currentTime=nil;
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"MM/dd/YY HH:mm:ss";
    self.currentTime=[formatter stringFromDate:date];

}

- (void)pic:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"设备不支持访问相册"];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak __typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];   //获取选择的图片
        UIImage *newImage = [self getJPEGImagerImg:image];  //压缩图片
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:weakSelf.texi.attributedText];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        textAttachment.image = newImage;
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [string insertAttributedString:textAttachmentString atIndex:weakSelf.texi.selectedRange.location];
        weakSelf.texi.attributedText = string;
        
    }];
    
}

#pragma mark - 压缩一张图片 最大宽高1280 类似于微信算法
- (UIImage *)getJPEGImagerImg:(UIImage *)image{
    CGFloat oldImg_WID = image.size.width;
    CGFloat oldImg_HEI = image.size.height;
    //CGFloat aspectRatio = oldImg_WID/oldImg_HEI;//宽高比
    if(oldImg_WID > KCompressibilityFactor || oldImg_HEI > KCompressibilityFactor){
        //超过设置的最大宽度 先判断那个边最长
        if(oldImg_WID > oldImg_HEI){
            //宽度大于高度
            oldImg_HEI = (KCompressibilityFactor * oldImg_HEI)/oldImg_WID;
            oldImg_WID = KCompressibilityFactor;
        }else{
            oldImg_WID = (KCompressibilityFactor * oldImg_WID)/oldImg_HEI;
            oldImg_HEI = KCompressibilityFactor;
        }
    }
    UIImage *newImg = [self imageWithImage:image scaledToSize:CGSizeMake(oldImg_WID, oldImg_HEI)];
    NSData *dJpeg = nil;
    if (UIImagePNGRepresentation(newImg)==nil) {
        dJpeg = UIImageJPEGRepresentation(newImg, 0.5);
    }else{
        dJpeg = UIImagePNGRepresentation(newImg);
    }
    return [UIImage imageWithData:dJpeg];
}

#pragma mark - 根据宽高压缩图片
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)save{

    [self.delegate saveNote:_currentTime and:self.texi.text];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

