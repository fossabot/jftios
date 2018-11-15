//
//  SHSettingViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/4/27.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSettingViewController.h"

#import "SHClearCacheTool.h"
#import "SHAddressManagerVController.h"
#import "SHModifyPsdVController.h"
#import "SHModifyPayPsdVController.h"
#import "SHGetRedPackageVController.h"
#import "SHHelpViewController.h"
#import "SHAboutUSViewController.h"
#import "SHNewsSettingVController.h"

@interface SHSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *sectionOneArray;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *sectionTwoArray;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *sectionThrArray;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;



@property (weak, nonatomic) IBOutlet UILabel *cachesLabel;

@end

@implementation SHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    [self calculateCaches];
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"设置";
    
    _tableview.tableFooterView = _footerView;
    _tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _logoutButton.layer.cornerRadius = _logoutButton.height / 2;
    _logoutButton.clipsToBounds = YES;
    
    //获取版本信息
    // 获取当前App的基本信息字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    _versionLabel.text = [NSString stringWithFormat:@"V %@", app_Version];
    
}



#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _sectionOneArray.count;
    } else if (section == 1) {
        return _sectionTwoArray.count;
    } else if (section == 2) {
        return _sectionThrArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        return _sectionOneArray[indexPath.row];
    } else if (indexPath.section == 1) {
        return _sectionTwoArray[indexPath.row];
    } else if (indexPath.section == 2) {
        return _sectionThrArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {                   //修改收货地址
            [self modifyGetGoodsAddressFunction];
        } else if (indexPath.row == 1) {            //修改登录密码
            [self modifyLoginPsdFunction];
        } else if (indexPath.row == 2) {            //修改支付密码
            [self modifyPayPsdFunction];
        } else if (indexPath.row == 3) {
            //[self modifyPayPsdFunction];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {                   //帮助
            [self helpCenterFunction];
        } else if (indexPath.row == 1) {            //关于我们
            [self aboutSGInfoFunction];
        } else if (indexPath.row == 2) {
            SHLog(@"版本信息")
        } else if (indexPath.row == 3) {            //分享给朋友
            [self shareToFriendFunction];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {                   //清除缓存
            [self clearSavedFunction];
        } else if (indexPath.row == 1) {            //新消息通知
            SHLog(@"新消息通知")
            [self newsSettingFunction];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHScreenW, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

#pragma mark - 方法
//退出登录
- (IBAction)logoutBtnClick:(UIButton *)sender {
    SHWeakSelf
    [[SG_HttpsTool sharedSG_HttpsTool] postWithURL:SHLogoutUrl params:nil success:^(id JSON, int code, NSString *msg) {
        SHLog(@"%d", code)
        SHLog(@"%@", msg)
        if (code == 0) {
            [MBProgressHUD showMBPAlertView:@"退出成功" withSecond:2.0];
            [SH_AppDelegate userLogout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHLogoutSuccess" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

//修改收货地址
- (void)modifyGetGoodsAddressFunction
{
    SHAddressManagerVController *vc = [[SHAddressManagerVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//修改登录密码
- (void)modifyLoginPsdFunction
{
    SHModifyPsdVController *vc = [[SHModifyPsdVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//修改支付密码
- (void)modifyPayPsdFunction
{
    SHModifyPayPsdVController *vc = [[SHModifyPayPsdVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//帮助中心
- (void)helpCenterFunction
{
    SHHelpViewController *vc = [[SHHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//关于我们
- (void)aboutSGInfoFunction
{
    SHAboutUSViewController *vc = [[SHAboutUSViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//版本信息
- (void)versionInformationFunction
{}

//分享给朋友
- (void)shareToFriendFunction
{
    SHLog(@"分享")
    SHGetRedPackageVController *vc = [[SHGetRedPackageVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//清除缓存
- (void)clearSavedFunction
{
    SHLog(@"清除缓存")
    SHWeakSelf
    //Document文件夹：
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    //Library文件夹：
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    
    //Library/Caches:
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    //Library/Preferences:
    //NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *preferencePath = [libraryPath stringByAppendingString:@"/Preferences"];
    
    //tmp：
    NSString *tmpPath = NSTemporaryDirectory();
    
    NSInteger messageDoc = [SHClearCacheTool getCacheSizeWithFilePath:docPath];
    NSInteger messageLib = [SHClearCacheTool getCacheSizeWithFilePath:libraryPath];
    NSInteger messageCache = [SHClearCacheTool getCacheSizeWithFilePath:cachesPath];
    NSInteger messagePre = [SHClearCacheTool getCacheSizeWithFilePath:preferencePath];
    NSInteger messageTmp = [SHClearCacheTool getCacheSizeWithFilePath:tmpPath];
    SHLog(@"缓存文件的大小：%ld--%ld__%ld__%ld__%ld", (long)messageDoc, (long)messageLib, (long)messageCache, (long)messagePre, (long)messageTmp)
    
    //8.将文件夹大小转换为M/KB/B
    NSString *totleStr = nil;
    //大小
    NSInteger totalSize = messagePre;
    if (totalSize > 1000 * 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fM", totalSize / 1000.00f / 1000.00f];
    } else if (totalSize > 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fKB", totalSize / 1000.00f];
    } else {
        totleStr = [NSString stringWithFormat:@"%.2fB", totalSize / 1.00f];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:totleStr preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
       
        [SHClearCacheTool clearCacheWithFilePath:docPath];
        [SHClearCacheTool clearCacheWithFilePath:libraryPath];
        [SHClearCacheTool clearCacheWithFilePath:cachesPath];
        [SHClearCacheTool clearCacheWithFilePath:preferencePath];
        [SHClearCacheTool clearCacheWithFilePath:tmpPath];
        _cachesLabel.text = @"暂无缓存";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}

//计算缓存
- (void)calculateCaches
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //Library文件夹：
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    //Library/Caches:
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    //Library/Preferences:
    //NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *preferencePath = [libraryPath stringByAppendingString:@"/Preferences"];
    //tmp：
    NSString *tmpPath = NSTemporaryDirectory();
    NSInteger messageDoc = [SHClearCacheTool getCacheSizeWithFilePath:docPath];
    NSInteger messageLib = [SHClearCacheTool getCacheSizeWithFilePath:libraryPath];
    NSInteger messageCache = [SHClearCacheTool getCacheSizeWithFilePath:cachesPath];
    NSInteger messagePre = [SHClearCacheTool getCacheSizeWithFilePath:preferencePath];
    NSInteger messageTmp = [SHClearCacheTool getCacheSizeWithFilePath:tmpPath];
    SHLog(@"缓存文件的大小：%ld--%ld__%ld__%ld__%ld", (long)messageDoc, (long)messageLib, (long)messageCache, (long)messagePre, (long)messageTmp)
    //8.将文件夹大小转换为M/KB/B
    NSString *totleStr = nil;
    //大小
    NSInteger totalSize = messagePre;
    if (totalSize > 1000 * 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fM", totalSize / 1000.00f / 1000.00f];
    } else if (totalSize > 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fKB", totalSize / 1000.00f];
    } else {
        totleStr = [NSString stringWithFormat:@"%.2fB", totalSize / 1.00f];
    }
    _cachesLabel.text = totleStr;
}

//新消息提醒
- (void)newsSettingFunction
{
    SHNewsSettingVController *vc = [[SHNewsSettingVController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
