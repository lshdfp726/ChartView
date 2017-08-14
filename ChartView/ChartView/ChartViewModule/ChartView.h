//
//  ChartView.h
//  FnscoDataServerApp
//
//  Created by fns on 2017/7/27.
//  Copyright © 2017年 fnsco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface ChartView : UIView
- (instancetype)initWithQuene:(dispatch_queue_t)queue;
@property (nonatomic, strong) NSArray <DataModel *>*dataModel;

@end
