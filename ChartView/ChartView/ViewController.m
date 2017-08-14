//
//  ViewController.m
//  ChartView
//
//  Created by fns on 2017/8/14.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"
#import "DataModel.h"
@interface ViewController ()
@property (nonatomic, strong) ChartView *chartV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //图表部分
    self.chartV = [[ChartView alloc] initWithQuene:dispatch_get_main_queue()];
    self.chartV.backgroundColor = [ColorHex colorWithHexString:@"0xffffff"];
    [self.view addSubview:self.chartV];
    [self.chartV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(100.0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height/2);
    }];
    
    
    [self requestData];
}


- (void)requestData {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 7; i ++) {
        DataModel *model = [[DataModel alloc] init];
        model.sales = arc4random() % 10000;
        model.orderNumber = arc4random() & 1000;
        model.unit  = [NSString stringWithFormat:@"8.%u",arc4random()%30];
        [dataArray addObject:model];
    }
    
    //整理sale，获取坐标最大坐标
    NSString *maxOrderNumberStr = [NSString stringWithFormat:@"%@",[dataArray valueForKeyPath:@"@max.orderNumber"]];
    NSString *leftUnitStr = [self leftUintDispose:[dataArray valueForKeyPath:@"@max.sales"]];//
    [dataArray enumerateObjectsUsingBlock:^(NSObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DataModel *model     = (DataModel *)obj;
        model.leftUnit         = leftUnitStr;
        model.saleRadio        = 1 - (model.sales/(leftUnitStr.floatValue == 0?[@(1) floatValue]:leftUnitStr.floatValue));//如果没有值 除数不能为0， iOS 坐标值是反的所以比率越大 实际值其实越小，1 - 比率
        model.orderNumberRadio = 1 - (model.orderNumber/(maxOrderNumberStr.floatValue == 0?[@(1) floatValue]:maxOrderNumberStr.floatValue));
    }];
    
    [self.chartV setDataModel:dataArray];
}

//字符串最高位+1 ，其他位数清零!当时产品的需求
- (NSString *)leftUintDispose:(id)leftUnit {
    NSString *leftStr = [NSString stringWithFormat:@"%@",leftUnit];
    if (!leftStr) {
        NSLog(@"字符串为空值");
        return @"";
    }
    NSInteger length = 0;
    NSString  *first  = @"";
    if ([leftStr containsString:@"."]) {//包含小数点,截取整数部分
        if (leftStr.floatValue < 1) {
            leftStr  = @"1";
        } else {
            leftStr  = [NSString stringWithFormat:@"%ld",(long)leftStr.integerValue];
            length   = leftStr.length - 1;
            first    = [leftStr substringToIndex:1];
            leftStr  = [NSString stringWithFormat:@"%ld",first.integerValue + 1];
        }
    } else {
        length = leftStr.length - 1;
        first = [leftStr substringToIndex:1];
    }
    
    leftStr = [NSString stringWithFormat:@"%ld",first.integerValue + 1];
    for (NSInteger i = 0; i < length; i ++) {//尾数添0
        leftStr = [leftStr stringByAppendingString:@"0"];
    }
    return leftStr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
