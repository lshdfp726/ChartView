//
//  DataModel.h
//  ChartView
//
//  Created by fns on 2017/8/14.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DataModel : NSObject
//图表model
@property (nonatomic, assign) CGFloat  sales;//销售额
@property (nonatomic, assign) CGFloat  saleRadio;//销售额占的比率
@property (nonatomic, assign) CGFloat  orderNumber;//订单量
@property (nonatomic, assign) CGFloat  orderNumberRadio;//订单量站的比率
@property (nonatomic, strong) NSString  *unit;//底部单位
@property (nonatomic, strong) NSString  *leftUnit;//左边坐标单位 根据chartViewData的最大值进一，然后除以4 ，被均分
@end
