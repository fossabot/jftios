//
//  SHCatagoryCell.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/7.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHCatagoryCell.h"
#import "SHCatagoryListModel.h"
#import "SHOrderViewController.h"
#import "SDPhotoBrowser.h"

@interface SHCatagoryCell () <SDPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImgv;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *evaluateL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) IBOutlet UILabel *subtitleL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIButton *makeOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceL;


@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imagesArrayV;
@property (weak, nonatomic) IBOutlet UIImageView *easeImgV;//空闲view
@property (weak, nonatomic) IBOutlet UIImageView *authoriseImgV;//认证imgV
@property (weak, nonatomic) IBOutlet UIView *pictureBGView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;

@end


@implementation SHCatagoryCell

- (void)setListModel:(SHCatagoryListModel *)listModel
{
    _listModel = listModel;
    [_headImgv sd_setImageWithURL:[NSURL URLWithString:listModel.providerAvatar] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _titleL.text = listModel.providerNickName;
    _evaluateL.text = [NSString stringWithFormat:@"%ld", (long)listModel.creditScore];
    //SHLog(@"%.2f", listModel.distance)
    _distanceL.text = [NSString stringWithFormat:@"%.2f km", listModel.distance];
    _subtitleL.text = [NSString stringWithFormat:@"标题：%@", listModel.serveSupply[@"title"]];
    _contentL.text = [NSString stringWithFormat:@"描述：%@", listModel.serveSupply[@"description"]];
    _priceL.text = [NSString stringWithFormat:@"%@元/%@", listModel.serveSupply[@"price"], listModel.serveSupply[@"unit"]];
    NSArray *imgArr = _listModel.serveSupply[@"imageList"];
    //SHLog(@"%@", imgArr)
    for (NSInteger i = 0; i < imgArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(90 * i, 0, 80, 80)];
        
        imgView.tag = i;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageViewClick:)];
        [imgView addGestureRecognizer:backTap];
        imgView.userInteractionEnabled = YES;
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] placeholderImage:[UIImage imageNamed:NoImagePlaceHolder]];
        [_pictureBGView addSubview:imgView];
    }
    
    
    if (listModel.providerId == SH_AppDelegate.personInfo.userId) {
        _followBtn.hidden = YES;
        _phoneBtn.hidden = YES;
        _makeOrderBtn.hidden = YES;
        _chatBtn.hidden = YES;
    }
    
    for (int i = 0; i < listModel.creditScore; i++) {
        UIImageView *imageV = _imagesArrayV[i];
        imageV.image = [UIImage imageNamed:@"evaXing"];
    }
    
}

- (void)backImageViewClick:(UITapGestureRecognizer *)tap
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    //设置容器视图，父视图
    browser.sourceImagesContainerView = _pictureBGView;
    browser.currentImageIndex = tap.view.tag;
    NSArray *imgArr = _listModel.serveSupply[@"imageList"];
    browser.imageCount = imgArr.count;
    browser.delegate = self;
    [browser show];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headImgv.layer.cornerRadius = _headImgv.height / 2;
    _headImgv.clipsToBounds = YES;
    
    _evaluateL.layer.cornerRadius = 3;
    _evaluateL.clipsToBounds = YES;
    _contentL.textColor = SHColorFromHex(0x9a9a9a);
    _priceL.textColor = SHColorFromHex(0xd43c33);
    _distanceL.textColor = SHColorFromHex(0x9a9a9a);
    
    [_makeOrderBtn setTitleColor:SHColorFromHex(0x12b1f5) forState:UIControlStateNormal];
    [_makeOrderBtn setBackgroundColor:SHColorFromHex(0xa2e2fb)];
    _makeOrderBtn.layer.cornerRadius = 6;
    _makeOrderBtn.clipsToBounds = YES;
    [_chatBtn setTitleColor:SHColorFromHex(0xfa9f47) forState:UIControlStateNormal];
    [_chatBtn setBackgroundColor:SHColorFromHex(0xfbe7ca)];
    _chatBtn.layer.cornerRadius = 6;
    _chatBtn.clipsToBounds = YES;
    
    
}

//关注按钮
- (IBAction)followBtnClick:(UIButton *)sender {
    
}

//打电话
- (IBAction)phoneBtnClick:(UIButton *)sender {
    [self callPhoneStr:_listModel.providerPhone];
}


//立即下单
- (IBAction)makeOrderBtnClick:(UIButton *)sender {
    
    SHOrderViewController *vc = [[SHOrderViewController alloc] init];
    vc.listModel = _listModel;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}



-(void)callPhoneStr:(NSString*)phoneStr  {
    NSString *str2 = [[UIDevice currentDevice] systemVersion];
    
    if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
    {
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    if (@available(iOS 10.0, *)) {
                        [app openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil                                                                                ];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [[self viewController].navigationController presentViewController:alert animated:YES completion:nil];
        
    }else {
        NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
        
        NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:@"是否拨打电话" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
            if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                UIApplication *app = [UIApplication sharedApplication];
                if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                    if (@available(iOS 10.0, *)) {
                        [app openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil                                                                                ];
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [[self viewController].navigationController presentViewController:alert animated:YES completion:nil];
    }
    
}



#pragma mark -- 遍历视图，找到UIViewController
- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    UIViewController *vc = nil;
    return vc;
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index

{
    NSArray *imgArr = _listModel.serveSupply[@"imageList"];
    //拿到显示的图片的高清图片地址
    NSURL *url = [NSURL URLWithString:imgArr[index]];
    
    return url;
    
}

//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//
//{
//
//
//    return cell.imageView.image;
//
//}














- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
