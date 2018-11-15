//
//  SHPersonalInfoVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/28.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHPersonalInfoVController.h"
#import "TakeOrSelectPhotoUtil.h"
#import "ImageUtil.h"
#import "SHAddressManagerVController.h"
#import "SH_DateTimePickerView.h"
#import "SHCatagoryView.h"
#import "SHModifyInfoVController.h"

#import "SHBirthdayPickerView.h"

@interface SHPersonalInfoVController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, TakeOrSelectPhotoUtilDelegate, SHDateTimePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *sectionArray;

@property (nonatomic, strong) UIImagePickerController *imagePicker; //声明全局的UIImagePickerController

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UILabel *nickNameL;
@property (weak, nonatomic) IBOutlet UILabel *sexL;
@property (weak, nonatomic) IBOutlet UILabel *birthdayL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;

@property (nonatomic, strong) SHBirthdayPickerView *birthPView;
@property (nonatomic, strong) SH_DateTimePickerView *datePickView;          //时间选择器
@property (nonatomic, strong) SHCatagoryView *catagoryView;




@end

@implementation SHPersonalInfoVController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SHLog(@"%@-%@", SH_AppDelegate.personInfo.mobile, SH_AppDelegate.personInfo.introduce)
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    [self loadPersonalInfoData];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"个人资料";
    
    
}

- (void)loadPersonalInfoData
{
    SHWeakSelf
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHInfoUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%@", JSON)
        if (code == 0) {
            NSDictionary *dic = JSON[@"user"];
            //[[SG_HttpsTool sharedSG_HttpsTool] downloadImage:dic[@"avatar"] place:nil imageView:weakSelf.headImgV];
            //SHLog(@"用户头像：\n%@", dic[@"avatar"])
            [weakSelf.headImgV sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"defaultHead"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
            [weakSelf.headImgV sd_setImageWithURL:dic[@"avatar"] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
            NSArray *array = [dic[@"birthday"] componentsSeparatedByString:@" "];
            weakSelf.birthdayL.text = array[0];
            weakSelf.signatureL.text = dic[@"introduce"];
            weakSelf.phoneL.text = dic[@"mobile"];
            weakSelf.nickNameL.text = dic[@"nickName"];
            SHLog(@"%@", dic[@"introduce"])
            SHLog(@"%@", dic[@"nickName"])
            if ([dic[@"gender"] integerValue] == 1) {
                self.sexL.text = @"男";
            } else if ([dic[@"gender"] integerValue] == 2) {
                self.sexL.text = @"女";
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}




#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        return _sectionArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self modifyHeaderImage];
        } else if (indexPath.row == 1) {
            [self modifySignature];
        } else if (indexPath.row == 2) {
            [self modifyNickname];
        } else if (indexPath.row == 3) {
            [self modifySex];
        } else if (indexPath.row == 4) {
            [self modifyBirthday];
        } else if (indexPath.row == 5) {
            [self modifyPhone];
        } else if (indexPath.row == 6) {
            [self modifyGetGoodsAddress];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



#pragma mark - function
//头像
- (void)modifyHeaderImage
{
    //自定义消息框
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    sheet.tag = 2550;
    [sheet showInView:self.view];
}

//签名        限制字数    18个字以内
- (void)modifySignature
{
    SHWeakSelf
    SHModifyInfoVController *vc = [[SHModifyInfoVController alloc] init];
    vc.modifyType = SHModifySignatureType;
    vc.infoBlock = ^(NSString *infomation) {
        weakSelf.signatureL.text = infomation;
        [weakSelf modifySignatureAndNickname:infomation];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//昵称        限制字数    8个字以内
- (void)modifyNickname
{
    SHWeakSelf
    SHModifyInfoVController *vc = [[SHModifyInfoVController alloc] init];
    vc.modifyType = SHModifyNicknameType;
    vc.infoBlock = ^(NSString *infomation) {
        weakSelf.nickNameL.text = infomation;
        [weakSelf modifyNickName:infomation];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//性别
- (void)modifySex
{
    SHWeakSelf
    _catagoryView = [[SHCatagoryView alloc] initWithArray:@[@"男",@"女"]];
    _catagoryView.type = SHAdvertisementType;
    _catagoryView.catagoarySelectBlock = ^(NSString *leftString, NSString *rightString, NSString *string) {
        SHLog(@"%@_%@_%@", leftString, rightString, string)
        _sexL.text = string;
        [weakSelf changeSexWith:string];
        
    };
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:_catagoryView];
    
}

//出生日期
- (void)modifyBirthday
{
    SHWeakSelf
    SHBirthdayPickerView *pView = [[SHBirthdayPickerView alloc] init];
    self.birthPView = pView;
    _birthPView.selectBlock = ^(NSString *result) {
        [weakSelf modifyBirthdayWith:result];
    };
    
    [self.view addSubview:_birthPView];
    
    [_birthPView showPickerView];
}

//手机号
- (void)modifyPhone
{}

//收货地址
- (void)modifyGetGoodsAddress
{
    SHAddressManagerVController *vc = [[SHAddressManagerVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeSexWith:(NSString *)string {
    SHWeakSelf
    NSDictionary *dic = nil;
    if ([string isEqualToString:@"男"]) {
        dic = @{
                @"gender":@(1)
                };
    } else if ([string isEqualToString:@"女"]) {
        dic = @{
                @"gender":@(2)
                };
    }
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateInfo params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"修改成功" withSecond:2.0];
            weakSelf.sexL.text = string;
            if ([string isEqualToString:@"男"]) {
                SH_AppDelegate.personInfo.sex = sSH_personSexTypeMan;
            } else if ([string isEqualToString:@"女"]) {
                SH_AppDelegate.personInfo.sex = sSH_personSexTypeWoman;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)modifyBirthdayWith:(NSString *)string{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"birthday":string
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateInfo params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        if (code == 0) {
            NSArray *array = [string componentsSeparatedByString:@" "];
            weakSelf.birthdayL.text = array[0];
            [MBProgressHUD showMBPAlertView:@"修改成功" withSecond:2.0];
        } else {
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"修改失败"];
    }];
}

//修改个人签名
- (void)modifySignatureAndNickname:(NSString *)string
{
    NSDictionary *dic = @{
                          @"introduce":string
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateInfo params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"修改成功" withSecond:2.0];
            SH_AppDelegate.personInfo.introduce = string;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyInfo" object:nil];
        } else {
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"修改失败"];
    }];
}

//修改昵称
- (void)modifyNickName:(NSString *)nickName
{
    NSDictionary *dic = @{
                          @"nickName":nickName
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateInfo params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"修改成功" withSecond:2.0];
            SH_AppDelegate.personInfo.nickName = nickName;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyInfo" object:nil];
        } else {
            [MBProgressHUD showError:@"修改失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"修改失败"];
    }];
}

#pragma mark - 消息框代理实现
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2550) {
        NSUInteger sourceType = 0;
        //判断系统是否支持相机
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (buttonIndex == 0) {
                SHLog(@"1")
                //拍照
                [self pickImageFromCamera:YES];
            } else if (buttonIndex == 1) {
                SHLog(@"2")
                //相册
                [self pickImageFromAlbum:YES];
                
            } else if (buttonIndex == 2) {
                SHLog(@"3")
                return;
            }
            
        } else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }
}



//拍照
- (void)pickImageFromCamera:(BOOL)allowEdit
{
    [[TakeOrSelectPhotoUtil sharedInstanse] takePhotoFromViewController:self ImagePickerMode:kImagePickerModePhoto AllowsEditing:allowEdit];
}

//相册
- (void)pickImageFromAlbum:(BOOL)allowEdit
{
    [[TakeOrSelectPhotoUtil sharedInstanse] selectPhotoFromViewController:self AllowsEditing:allowEdit];
}

#pragma mark - 相册协议
- (void)didFinishTakeOrSelectPhoto:(NSDictionary *)photoInfo
{
    [self uploadHeadImage:photoInfo];
}

- (void)uploadHeadImage:(NSDictionary *)photoInfo
{
    UIImage *headPhoto = [photoInfo objectForKey:UIImagePickerControllerEditedImage];
    //裁剪图片为正方向
    UIImage *scaleImage = [ImageUtil image:headPhoto fillSize:CGSizeMake(240, 240)];
    //压缩图片
    UIImage *compressImage = [ImageUtil comparessImageFromOriginalImage:scaleImage];
    //NSData *imageData = UIImageJPEGRepresentation(compressImage, 1);
    [SG_HttpsTool uploadImageWithURL:imageUrlString image:scaleImage success:^(id JSON, int code, NSString *msg) {
        
        if (code == 0) {
            NSDictionary *dic = JSON[@"data"];
            NSString *string = [NSString stringWithFormat:@"%@%@", imageSuccessUrl, dic[@"url"]];
            [self uploadBackImageUrl:string];
        }
    } failure:^(NSError *error) {

    }];
    
}

- (void)uploadBackImageUrl:(NSString *)imageString
{
    SHWeakSelf
    NSDictionary *dic = @{
                          @"avatar":imageString
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateInfo params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"头像修改成功" withSecond:2.0];
            [weakSelf.headImgV sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
            SH_AppDelegate.personInfo.avatar = imageString;
            if (weakSelf.modifyBlock) {
                weakSelf.modifyBlock(imageString);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SHDateTimePickerViewDelegate
- (void)didClickFinishDateTimePickerView:(NSString *)date {
    SHLog(@"选择：%@", date)
    SHWeakSelf
    NSDictionary *dic = @{
                          @"birthday":date
                          };
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHUpdateInfo params:dic success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        if (code == 0) {
            weakSelf.birthdayL.text = date;
        }
    } failure:^(NSError *error) {
        
    }];
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
