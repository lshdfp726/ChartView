//
//  ShowDetailView.m
//  FnscoDataServerApp
//
//  Created by fns on 2017/8/2.
//  Copyright © 2017年 fnsco. All rights reserved.
//

#import "ShowDetailView.h"

@interface ShowDetailView ()
@property (nonatomic, strong) UILabel *saleLabel;
@property (nonatomic, strong) UILabel *orderLabel;

@end

@implementation ShowDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}


- (void)setUpView {
    [self initialUI];//UI初始化
    [self composition];//UI布局
}


- (void)initialUI {
    self.backImageView = [[UIImageView alloc] init];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.backImageView];
    self.saleLabel  = [QuickCreateUI quickLabel:[ColorHex colorWithHexString:@"0x333333"] font:12.0 tag:CGFLOAT_MAX text:@"" adjustsSizeToFitWidth:YES toSuperView:self];
    self.orderLabel = [QuickCreateUI quickLabel:[ColorHex colorWithHexString:@"0x333333"] font:12.0 tag:CGFLOAT_MAX text:@"" adjustsSizeToFitWidth:YES toSuperView:self];
}


- (void)composition {
    [self.saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.0);
        make.left.equalTo(self).offset(6.0);
        make.right.equalTo(self).offset(-4.0);
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.saleLabel);
        make.top.equalTo(self.saleLabel.mas_bottom).offset(2.0);
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)setDataModel:(DataModel *)dataModel {
    //订单数转换 
    self.saleLabel.text  = [NSString stringWithFormat:@"销售额：%ld",(long)dataModel.sales];
    NSInteger orderNumber = (NSInteger)dataModel.orderNumber;
    self.orderLabel.text = [NSString stringWithFormat:@"订单量：%ld",(long)orderNumber];
}

@end
