//
//  Order_ViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/3/16.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "Order_ViewController.h"
#import "SHRelCataModel.h"
#import "SHOrderLisrChildViewController.h"
#import "CCZSegementController.h"
#import "SH_SHSoundPlayer.h"

@interface Order_ViewController ()

@property (nonatomic, strong) NSMutableArray *cataArray;
@property (nonatomic, strong) CCZSegementController *inSegementController;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;



@end

@implementation Order_ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self loadCatagoaryData];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chechIsOpen:) name:@"checkIsOpen" object:nil];
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"需求大厅";
    //导航栏背景色
//    self.navigationController.navigationBar.barTintColor = navColor;
    _cataArray = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
    
    _receiveButton.backgroundColor = [navColor colorWithAlphaComponent:0.7f];
    _receiveButton.layer.cornerRadius = _receiveButton.height / 2;
    _receiveButton.clipsToBounds = YES;
    
    [self.view bringSubviewToFront:_receiveButton];
    
}

//重新加载
- (IBAction)loadingAgainBtnClick:(UIButton *)sender {
    [self loadCatagoaryData];
}


- (void)chechIsOpen:(NSNotification *)text
{
    //SHLog(@"%@", text.userInfo[@"isOpen"])
    NSString *isOpne = text.userInfo[@"isOpen"];
    if ([isOpne isEqual:@0]) {    //用户处于关闭接单状态
        SHLog(@"显示开启接单")
        [_receiveButton setTitle:@"开启接单" forState:UIControlStateNormal];
        [SH_AppDelegate closeLocationTimer];
//        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
////        player.isOpen = YES;
//        [player setDefaultWithVolume:-1.0 rate:0.4 pitchMultipier:-1.0];
//        [player play:@"您已开始接单"];
    } else if ([isOpne isEqual:@1]) { //用户处于开启接单状态
        SHLog(@"显示关闭接单")
        [_receiveButton setTitle:@"关闭接单" forState:UIControlStateNormal];
        [SH_AppDelegate openLocationTimer];
    }
}

/**
 *  加载分类数据
 */
- (void)loadCatagoaryData
{
    SHWeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHReleaServCatUrl params:nil success:^(id JSON, int code, NSString *msg) {
        //SHLog(@"%@", JSON)
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [_cataArray removeAllObjects];
        if (code == 0) {
            NSArray *array = [SHRelCataModel mj_objectArrayWithKeyValuesArray:JSON[@"categories"]];
            [_cataArray addObjectsFromArray:array];
            for (SHRelCataModel *model in array) {
                [_titleArray addObject:model.name];
                if ([model.name isEqualToString:@"家教"]) {
                    SHLog(@"家教的id----------%@", model.ID)
                }
            }
            
            //SHLog(@"%@", _cataArray)
            [weakSelf initInSegementControllerWith:_titleArray];
        }
    } failure:^(NSError *error) {
        SHLog(@"%@", error)
        if (error) {
            [MBProgressHUD hideHUDForView:weakSelf.view];
            _loadButton.hidden = NO;
            _imageV.hidden = NO;
        }
    }];
}

- (void)initInSegementControllerWith:(NSMutableArray *)array
{
    CGFloat status_H = [UIApplication sharedApplication].statusBarFrame.size.height +  44;
    CGRect rect = CGRectMake(self.view.x, status_H, SHScreenW, SHScreenH - 115);
    
    //NSArray *titleArray = @[@"全部", @"待付款", @"待服务", @"待确认", @"待评价"];
    //NSArray *orderStatusArr = @[@"",@"INIT",@"RECEIVE",@"UN_CONFIRMED",@"UN_EVALUATION"];
    NSMutableArray *childVCArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        SHOrderLisrChildViewController *vc = [[SHOrderLisrChildViewController alloc]init];
        vc.listType = SHNeedTingType;
        for (SHRelCataModel *model in _cataArray) {
            if ([array[i] isEqualToString:model.name]) {
                vc.idString = model.ID;
            }
        }
        [childVCArr addObject:vc];
    }
    self.inSegementController = [CCZSegementController segementControllerWithFrame:rect
                                                                            titles:array];
    [self.inSegementController setSegementViewControllers:[childVCArr copy]];
    self.inSegementController.normalColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.inSegementController.segementTintColor = [UIColor colorWithRed:0 / 255.0 green:158 / 255.0 blue:231 / 255.0 alpha:1];
    self.inSegementController.style = CCZSegementStyleFlush;
    [self addChildViewController:self.inSegementController];
    [self.view addSubview:self.inSegementController.view];
    
    [self.view bringSubviewToFront:_receiveButton];
    
}

//开启接单按钮
- (IBAction)startReceiveOrderClick:(UIButton *)sender {
    
    SHWeakSelf
    
    if ([SH_AppDelegate isPersonLogin]) {
        if ([AppDelegate isLocationServiceOpen]) {
            [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHOpenReceiveOrderUrl params:nil success:^(id JSON, int code, NSString *msg) {
                SHLog(@"%d", code)
                SHLog(@"%@", msg)
                if (code == 0) {
                    if ([weakSelf.receiveButton.currentTitle isEqualToString:@"开启接单"]) {
                        [weakSelf.receiveButton setTitle:@"关闭接单" forState:UIControlStateNormal];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:nil];
                        
//                        [SH_AppDelegate closeLocationTimer];
                        [SH_AppDelegate openLocationTimer];
                        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
                        //        player.isOpen = NO;
                        [player setDefaultWithVolume:SH_AppDelegate.personInfo.volume rate:0.4 pitchMultipier:-1.0];
                        [player play:@"您已开启接单"];
                    } else if ([weakSelf.receiveButton.currentTitle isEqualToString:@"关闭接单"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeOrderList" object:nil];
                        [weakSelf.receiveButton setTitle:@"开启接单" forState:UIControlStateNormal];
                        
//                        [SH_AppDelegate openLocationTimer];
                        [SH_AppDelegate closeLocationTimer];
                        SH_SHSoundPlayer *player = [SH_SHSoundPlayer SHSoundPlayerInit];
                        //        player.isOpen = NO;
                        [player setDefaultWithVolume:SH_AppDelegate.personInfo.volume rate:0.4 pitchMultipier:-1.0];
                        [player play:@"您已关闭接单"];
                    }
                }
            } failure:^(NSError *error) {
                
            }];
            
            
        } else {
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"开启接单需要您开启定位方便用户查看与您的位置距离" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            UIAlertAction *act2=[UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
//                if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
//                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                        [[UIApplication sharedApplication] openURL:url];
//                    }
//                } else {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
//                }
            }];
            [controller addAction:act1];
            [controller addAction:act2];
            [self presentViewController:controller animated:YES completion:^{
                
            }];
        }
        
    } else {
        [SH_AppDelegate userLogin];
    }
    
    
    
    
    
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
