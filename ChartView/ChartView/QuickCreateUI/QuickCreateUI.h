//
//  QuickCreateUI.h
//  FnscoDataServerApp
//
//  Created by fns on 2017/7/31.
//  Copyright © 2017年 fnsco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickCreateUI : NSObject
/**
  如果不需要tag 请给最大值 CGFLOAT_MAX
 */
+ (UILabel *)quickLabel:(UIColor *)textColor
                   font:(CGFloat)font
                    tag:(NSInteger)tag
                   text:(NSString *)text
  adjustsSizeToFitWidth:(BOOL)adjust
            toSuperView:(UIView *)superView;



+ (UIButton *)quickButton:(NSString *)title
               titleColor:(UIColor *)titleColor
                     font:(CGFloat)font
                    image:(UIImage *)image
          backgroundImage:(UIImage *)backImage
             controlState:(UIControlState)state
              toSuperView:(UIView *)superView;
@end
