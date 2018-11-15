//
//  SHAddressBookViewController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/7/20.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHAddressBookViewController.h"
#import <Contacts/Contacts.h>
#import "SHAddressBookCell.h"


static NSString *identityCell = @"SHAddressBookCell";
@interface SHAddressBookViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *phoneDic;
@property (nonatomic, copy) NSString *phoneNumber;

@end

@implementation SHAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
    
}

- (void)initBaseInfo
{
    self.navigationItem.title = @"通讯录";
    _phoneDic = [[NSMutableDictionary alloc] init];
    [self requestContactAuthorAfterSystemVersion9];
    
    [_tableView registerNib:[UINib nibWithNibName:identityCell bundle:nil] forCellReuseIdentifier:identityCell];
    _tableView.tableFooterView = [UIView new];
    
}

//请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9
{
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    SHLog(@"授权失败")
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    SHLog(@"授权成功")
                }
            }];
            
        } else if (status == CNAuthorizationStatusRestricted) {
            SHLog(@"用户拒绝")
            [self showAlertViewAboutNotAuthorAccessContact];
        } else if (status == CNAuthorizationStatusDenied) {
            SHLog(@"用户拒绝")
            [self showAlertViewAboutNotAuthorAccessContact];
        } else if (status == CNAuthorizationStatusAuthorized) {
            //有通讯录权限--进行下一步操作
            [self openContact];
        }
        
    } else {
        // Fallback on earlier versions
    }
    
}

//有通讯录权限--进行下一步操作
- (void)openContact
{
    //获取指定的字段，并不是要获取所有字段，需要指定具体字段
    if (@available(iOS 9.0, *)) {
        NSArray *keyToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keyToFetch];
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            //拼接姓名
            NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
            
            NSArray *phoneNumbers = contact.phoneNumbers;
            //NSArray<CNLabeledValue<CNPhoneNumber*>*>
            for (CNLabeledValue *labelValue in phoneNumbers) {
                //遍历一个人名下的多个号码
                //NSString *label = labelValue.label;
                CNPhoneNumber *phoneN = labelValue.value;
                _phoneNumber = phoneN.stringValue;
                //去掉电话中的特殊字符
                _phoneNumber = [_phoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                _phoneNumber = [_phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
                _phoneNumber = [_phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
                _phoneNumber = [_phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
                _phoneNumber = [_phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                _phoneNumber = [_phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                
            }
            
            [_phoneDic setObject:_phoneNumber forKey:name];
            
            
        }];
        
        //获取通讯录信息
        SHLog(@"%@", _phoneDic)
        
        //网络请求
        [self requestDataFromServiceWithDic:_phoneDic];
        
    } else {
        // Fallback on earlier versions
    }
    
}


//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
 *  发送请求，获取后台显示用户
 */
- (void)requestDataFromServiceWithDic:(NSDictionary *)dict
{
    
    
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[SHAddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //选中之后发送邀请短信
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
