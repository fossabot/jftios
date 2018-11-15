//
//  SHSearchVController.m
//  SGMJ
//
//  Created by 数荟科技 on 2018/6/14.
//  Copyright © 2018年 数荟科技. All rights reserved.
//

#import "SHSearchVController.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import "SHSearchAddCell.h"

static NSString *identityID = @"SHSearchAddCell";
@interface SHSearchVController () <BMKPoiSearchDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BMKPoiSearch *searcher;

@property(nonatomic,strong) NSArray<BMKPoiInfo *> *dataList;//信息

@end

@implementation SHSearchVController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_searchTF becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _searcher.delegate = nil;
    [_searchTF resignFirstResponder];
}

- (BMKPoiSearch *)searcher
{
    if (!_searcher) {
        _searcher = [[BMKPoiSearch alloc] init];
        _searcher.delegate = self;
    }
    return _searcher;
}

- (NSArray *)dataList {
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseInfo];
    
}

- (void)initBaseInfo
{
    _tableView.layer.cornerRadius = 10;
    _tableView.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_tableView registerNib:[UINib nibWithNibName:identityID bundle:nil] forCellReuseIdentifier:identityID];
    
    [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _searchTF.returnKeyType = UIReturnKeySearch;
}

#pragma mark - textFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    SHLog(@"%@", textField.text)
    
    //请求参数类 BMKCitySearchOption
    BMKPOICitySearchOption *citySearchOption = [[BMKPOICitySearchOption alloc] init];
    citySearchOption.pageSize = 15;
    citySearchOption.city = self.cityName;
    citySearchOption.keyword = textField.text;
//    [_dataList removeAllObjects];
    //发起城市内POI检索
    BOOL flag = [self.searcher poiSearchInCity:citySearchOption];
    if (flag) {
        SHLog(@"城市内检所发送成功")
    } else {
        //城市内检索发送失败
//        [_dataList removeAllObjects];
        [_tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //搜索方法
    if (textField.text.length > 0) {
        [textField resignFirstResponder];
        //请求参数类 BMKCitySearchOption
        
        BMKPOICitySearchOption *citySearchOption = [[BMKPOICitySearchOption alloc] init];
        citySearchOption.pageSize = 15;
        citySearchOption.city = self.cityName;
        citySearchOption.keyword = textField.text;
//        [_dataList removeAllObjects];
        
        //发起城市内POI检索
        BOOL flag = [self.searcher poiSearchInCity:citySearchOption];
        if (flag) {
            SHLog(@"城市内检索发送成功")
        } else {
//            [_dataList removeAllObjects];
            [_tableView reloadData];
        }
    }
    return YES;
}

#pragma mark - PoiSearchDeleage
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    SHLog(@"%d", errorCode)
    if (errorCode == BMK_OPEN_NO_ERROR) {
        //在此处理正常结果
        _dataList = poiResult.poiInfoList;
//        SHLog(@"%@",poiResult.cityList);
        [_tableView reloadData];
    } else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        //起始点有歧义

        [_tableView reloadData];
    } else {
        //抱歉，未找到结果

        [_tableView reloadData];
    }
}


#pragma mark - UITableViewDelegate && dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SHSearchAddCell *cell = [tableView dequeueReusableCellWithIdentifier:identityID];
    if (!cell) {
        cell = [[SHSearchAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityID];
    }
    cell.firstAddL.text = _dataList[indexPath.row].name;
    cell.secondAddL.text = _dataList[indexPath.row].address;
    cell.secondAddL.textColor = SHColorFromHex(0x9a9a9a);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    !_chooseAddress ?: _chooseAddress(_dataList[indexPath.row].pt);
    SHLog(@"点击：%f-%f", _dataList[indexPath.row].pt.latitude,_dataList[indexPath.row].pt.longitude)
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


- (IBAction)cancelButtonClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
