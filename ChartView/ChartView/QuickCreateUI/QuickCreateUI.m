//
//  QuickCreateUI.m
//  FnscoDataServerApp
//
//  Created by fns on 2017/7/31.
//  Copyright © 2017年 fnsco. All rights reserved.
//

#import "QuickCreateUI.h"

@implementation QuickCreateUI

//迅速创建label
+ (UILabel *)quickLabel:(UIColor *)textColor
                   font:(CGFloat)font
                    tag:(NSInteger)tag
                   text:(NSString *)text
  adjustsSizeToFitWidth:(BOOL)adjust
            toSuperView:(UIView *)superView  {
    if (!superView) {
        NSLog(@"缺少父控件");
        return [[UILabel alloc] init];
    }
    UILabel *label  = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font      = [UIFont systemFontOfSize:font];
    if (adjust) {
        label.adjustsFontSizeToFitWidth = adjust;  //如果约束宽度定了，起作用
        label.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
    }
    
    if (tag != CGFLOAT_MAX) {
        label.tag = tag;
    }
    
    if (superView) {
        [superView addSubview:label];
    }
    return label;
}


//按钮
+ (UIButton *)quickButton:(NSString *)title
               titleColor:(UIColor *)titleColor
                     font:(CGFloat)font
                    image:(UIImage *)image
          backgroundImage:(UIImage *)backImage
             controlState:(UIControlState)state
              toSuperView:(UIView *)superView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:state];
    [btn setTitleColor:titleColor forState:state];
    if (image) {
       [btn setImage:image forState:state];
    }
    
    if (backImage) {
        [btn setBackgroundImage:backImage forState:state];
    }
    
    btn.titleLabel.font =  [UIFont systemFontOfSize:font];
    
    if (superView) {
        [superView addSubview:btn];
    }
    return btn;
}

@end
