//
//  SHShowAlbumVC.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHShowAlbumVC.h"

#import "SHShowAlbumCell.h"
#import "SHSelfImage.h"
#import "NSObject+SHPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+SH.h"
static NSString * const SHOWCELL = @"SHShowAlbumCell";
@interface SHShowAlbumVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    //右边的完成按钮
    UIButton *selectBtn;
}

//显示图片的collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
//所有需要显示的图片
@property (nonatomic, strong) NSMutableArray *dataArray;
//选中的图片
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation SHShowAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    [self setNavItemButton];
    
    
}

- (void)initBaseInfo {
    self.title = @"图 片";
    _dataArray = [NSMutableArray array];
    _selectedArray = [NSMutableArray array];
    
    //多少照片
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library callAllPhoto:_group result:^(SHSelfImage *image) {
        [_dataArray addObject:image];
    }];
    
    //加载所有图片
    [self initCollectionView];
}

/**
 *  加载九宫格图片
 */
- (void)initCollectionView {
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self setFlowOut]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    if (_color) {
        _collectionView.backgroundColor = _color;
    }
    [_collectionView registerNib:[UINib nibWithNibName:SHOWCELL bundle:nil] forCellWithReuseIdentifier:SHOWCELL];
    [self.view addSubview:_collectionView];
}

/**
 *  格式
 *  @return return value description
 */
- (UICollectionViewFlowLayout *)setFlowOut {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    //每一行显示图片个数
    NSInteger rowCount = SHRowNumPicture;
    if (_listCount && _listCount > 0) {
        rowCount = _listCount;
    }
    layOut.itemSize = CGSizeMake(self.view.frame.size.width / rowCount, self.view.frame.size.width / rowCount);
    //行间距，列间距
    layOut.minimumLineSpacing = 0;
    layOut.minimumInteritemSpacing = 0;
    return layOut;
}


/**
 *  自定义导航栏按钮
 */
- (void)setNavItemButton {
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectBtn.userInteractionEnabled = NO;
    selectBtn.frame = CGRectMake(0, 0, 40, 30);
    [selectBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(successChose) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

/**
 *  完成按钮选定      把选择的图片传送过去
 *  这里控制选中图片的个数
 */
- (void)successChose {
    if (self.selectedArray.count <= SHMaxSelectedPicture) {
        //把选中的图片传送过去
        NSDictionary *dic = @{
                              @"cellImage":self.selectedArray
                              };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushImage" object:nil userInfo:dic];
        //退出模态
        [self dismissViewControllerAnimated:YES completion:^{
            //这一步确保退出到显示界面的时候显示相册控制器一定退出
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        SHLog(@"最多只能选中4张")
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //显示相册和相机
    if (_showStyle == ENUM_Camera) {
        return self.dataArray.count + 1;
    } else {
        return self.dataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SHShowAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SHOWCELL forIndexPath:indexPath];
    //数据
    NSInteger cellIndex;
    if (_showStyle == ENUM_Camera) {
        //如果是相机模式，那么就要改变cell与数组的显示坐标对应
        cellIndex = indexPath.row - 1;
    } else {
        cellIndex = indexPath.row;
    }
    cell.selectBtn.tag = cellIndex;
    //按钮选中块
    SHWeakSelf
    cell.selectedBlock = ^(NSInteger index) {
        //把选中的图片放到一个数组里面
        [weakSelf.selectedArray addObject:[weakSelf.dataArray objectAtIndex:index]];
        selectBtn.userInteractionEnabled = YES;
    };
    
    //取消选定
    cell.cancelBlock = ^(NSInteger index) {
        //找出取消的cell
        SHSelfImage *oldImage = [weakSelf.dataArray objectAtIndex:index];
        //从选中的数组中移除
        for (SHSelfImage *newImage in weakSelf.selectedArray) {
            if (newImage == oldImage) {
                //移除
                [weakSelf.selectedArray removeObject:newImage];
                //判断完成按钮是否可以使用
                if (weakSelf.selectedArray.count <= 0) {
                    selectBtn.userInteractionEnabled = NO;
                }
                return;
            }
        }
        
    };
    
    if (_showStyle == ENUM_Camera) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"carema"];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.selectBtn.hidden = YES;
        } else {
            SHSelfImage *image = [_dataArray objectAtIndex:cellIndex];
            cell.imageView.image = image;
            cell.selectBtn.hidden = NO;
        }
    } else {
        SHSelfImage *image = [_dataArray objectAtIndex:cellIndex];
        cell.imageView.image = image;
    }
    return cell;
}

/**
 *  选择
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showStyle == ENUM_Camera && indexPath.row == 0) {
        //选择相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //初始化
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置可以编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        //进入照相界面
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - 相机代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //图片
    UIImage *image;
    //判断是不是从相机过来的
    if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
        //关闭相机
        [picker dismissViewControllerAnimated:YES completion:nil];
        //获取照相的图片信息info
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //通过判断picker的sourceType，如果是拍照则保存到相册去，非常重要的一步，不然，无法获取到照相的照片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

/**
 *  确定相机图片保存到系统相册后，进行图片获取
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    SHLog(@"以保存")
    //操作获得的照片，这是直接显示，
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library afterCameraAsset:^(ALAsset *asset) {
        SHSelfImage *image = [[SHSelfImage alloc] initWithCGImage:asset.thumbnail];
        image.asset = asset;
        //通知传值
        NSDictionary *dict = @{@"saveImage":image};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SAVEIMAGE" object:nil userInfo:dict];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
