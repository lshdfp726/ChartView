//
//  ShowDetailView.h
//  FnscoDataServerApp
//
//  Created by fns on 2017/8/2.
//  Copyright © 2017年 fnsco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
@interface ShowDetailView : UIView
@property (nonatomic, strong) DataModel *dataModel;
@property (nonatomic, strong) UIImageView *backImageView;
@end
