//
//  OBHomeViewController.m
//  OBImageCutFree
//
//  Created by oneBool on 2016/10/21.
//  Copyright © 2016年 oneBool. All rights reserved.
//

#import "OBHomeViewController.h"
#import "OBCutView.h"
#import "OBResultViewController.h"
@interface OBHomeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic ,strong) UIImagePickerController *picker;
@property (nonatomic , strong) UIImageView *imageViewToCut;
@property (nonatomic , strong) OBCutView *drawingView;
@property (nonatomic , strong) UIImage *resultImage;
@end

@implementation OBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OBTouchesEnded) name:@"kOBTouchesEnd" object:nil];
    self.drawingView.strokeColor = [UIColor yellowColor];
}
-(void)OBTouchesEnded{
    NSLog(@"收到通知");
    float scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(self.imageViewToCut.bounds.size, NO, scale);
    UIBezierPath *path = self.drawingView.path;
    [path addClip];
    [self.imageViewToCut.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], CGRectMake(self.drawingView.path.bounds.origin.x* scale, self.drawingView.path.bounds.origin.y * scale, self.drawingView.path.bounds.size.width *scale, self.drawingView.path.bounds.size.height *scale));
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    NSLog(@"%@",image);
    CGImageRelease(imageRef);    
    OBResultViewController *resultVC = [[OBResultViewController alloc]init];
    resultVC.resultImage = image;
    [self.navigationController pushViewController:resultVC animated:YES];
    [self.drawingView.path removeAllPoints];
}

-(void)selectorImage{
    NSLog(@"come here");
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"选择图像来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionTakePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseLogoFromTakingPhoto];
    }];
    UIAlertAction *actionPhotoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseLogoFromPhotoLibrary];
        NSLog(@"相");
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertVc addAction:actionTakePhoto];
    [alertVc addAction:actionPhotoLibrary];
    [alertVc addAction:actionCancel];
    [self presentViewController:alertVc animated:YES completion:^{}];
}
/**
 点击相册后调用
 */
-(void)chooseLogoFromPhotoLibrary{
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    //设置选择后的图片可被编辑
    //self.picker.allowsEditing = YES;
    [self presentViewController:self.picker animated:YES completion:^{

    }];
}

/**
 点击照相后调用
 */
-(void)chooseLogoFromTakingPhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.picker.delegate = self;
        //设置拍照后的图片可被编辑
        //self.picker.allowsEditing = YES;
        self.picker.sourceType = sourceType;
        [self presentViewController:self.picker animated:YES completion:^{
            
        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

/**
 照片选择代理方法
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:^{}];
//    NSLog(@"===========>%@",info);
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    self.imageViewToCut.image = image;
}
/**
 加载控件
 */
-(void)setupUI{
    [self setupNavBar];
    [self setupImageView];
    [self setupView];
}
/**
 设置导航栏
 */
-(void)setupNavBar{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:246/255.0 green:60/255.0 blue:27/255.0 alpha:1];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"选取照片" style:UIBarButtonItemStylePlain target:self action:@selector(selectorImage)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/**
 设置图片视图
 */
-(void)setupImageView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    CGRect imageFrame = imageView.frame;
    imageFrame.origin.y += 64;
    imageView.frame = imageFrame;
    imageView.image = [UIImage imageNamed:@"backImage.jpg"];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor colorWithRed:246/255.0 green:60/255.0 blue:27/255.0 alpha:0.6];
    self.imageViewToCut = imageView;
}

-(void)setupView{
    OBCutView *view = [[OBCutView alloc]initWithFrame:self.imageViewToCut.frame];
    view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:view];
    self.drawingView = view;
    
}

/**
 懒加载picker
 @return picker
 */
-(UIImagePickerController *)picker{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
    }
    return _picker;
}
-(UIImage *)resultImage{
    if (_resultImage == nil) {
        _resultImage = [[UIImage alloc]init];
    }
    return _resultImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
