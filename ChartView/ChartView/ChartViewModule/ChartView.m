//
//  ChartView.m
//  FnscoDataServerApp
//
//  Created by fns on 2017/7/27.
//  Copyright © 2017年 fnsco. All rights reserved.
//

#import "ChartView.h"
#import "ShowDetailView.h"

#define TOPUNITY (self.frame.size.height * SCALEHEIGHT(30.0)/SCALEHEIGHT(350.0))  //顶部单位的Y轴的坐标
#define SQUAREWIDTH (self.frame.size.width - (MARGELEFT + MARGERIGHT) - (self.dataModel.count - 1) * SQUARESPACE)/self.dataModel.count   //方块宽度
#define BASEPOINTY (self.frame.size.height - SCALEHEIGHT(25.0)) //最下面的基础点Y轴的坐标
#define SQUAREHEIGHTOFFSET SCALEHEIGHT(100.0) //方块高度控制偏移量 ，越大方块"矮小"
#define SQUAREHEIGHT  (BASEPOINTY - SQUAREHEIGHTOFFSET) //方块高度
#define YHEIGHT (SQUAREHEIGHT)   //Y轴高度，超出方块高度15像素

#define MARGELEFT SCALEWIDTH(60.0)  //距离父视图左边
#define MARGERIGHT SCALEWIDTH(20.0) //距离父视图右边
#define SQUARESPACE SCALEWIDTH(20.0) //方块间距



#define DETAILVIEWTAG 1000
@interface ChartView ()
@property (nonatomic, strong) dispatch_queue_t lshQueue;//所在线程
@property (nonatomic, strong) NSMutableArray *squreRectArray; //所有方框图的rect
@property (nonatomic, assign) NSInteger index;//当前被点击的方块
@end

@implementation ChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithQuene:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        self.lshQueue       = queue;//默认在主线程，尽量使用主线程！更新UI
        self.squreRectArray = [NSMutableArray array];
        _index = -1;//表示没被点击
    }
    return self;
}


#pragma mark - 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

//绘制UI
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画上部分销售，订单量UI
    [self drawTopUI:context];
    
    //左边Y轴坐标 元／笔
    [self drawLine:context];
    
    //绘制图表
    [self drawUI:context];
    
    //画底部坐标
    [self drawBottomCoordinate];
    
}


#pragma mark 上部 售额、订单量UI
- (void)drawTopUI:(CGContextRef)context {
    //销售额方框
    CGRect saleRect = CGRectMake(self.frame.size.width/2 - 80.0 - 20.0 - 14.0, TOPUNITY, 20.0, 8.0);
    UIBezierPath *salePath = [UIBezierPath bezierPathWithRect:saleRect];
    salePath.lineWidth = 1.0;
    salePath.lineJoinStyle = kCGLineCapRound;
    [self prepGradient:context
                  path:salePath.CGPath
                colors:@[(__bridge id)[ColorHex colorWithHexString:@"0x97c7fc"].CGColor,(__bridge id)[ColorHex colorWithHexString:@"0x65a0e1"].CGColor]
             effective:NO];
    
    NSString *saleStr = @"销售额(元)";
    CGRect sale = CGRectMake(self.frame.size.width/2 - 80.0, saleRect.origin.y - (22 - 8.0)/2, 80.0, 22.0);//以view的X中点为基准点，像两边约束UI
    [saleStr drawInRect:sale withAttributes:@{NSFontAttributeName           :[UIFont systemFontOfSize:16.0],
                                              NSForegroundColorAttributeName:[ColorHex colorWithHexString:@"0x333333"]}];
    
    
    //订单量方框
    CGRect orderRect = CGRectMake(self.frame.size.width/2 + 10.0, saleRect.origin.y + 3.0, 16.0,2.0);
    UIBezierPath *orderPath = [UIBezierPath bezierPathWithRect:orderRect];
    orderPath.lineWidth     = 1.0;
    orderPath.lineJoinStyle = kCGLineCapRound;
    [self prepGradient:context
                  path:orderPath.CGPath
                colors:@[(__bridge id)[ColorHex colorWithHexString:@"0xf8e81c"].CGColor]
             effective:NO];
    
    NSString *orderStr = @"订单量(笔)";
    CGRect order = CGRectMake(orderRect.origin.x + orderRect.size.width + 14.0, orderRect.origin.y - (22.0 -2)/2, 80.0, 22.0);
    [orderStr drawInRect:order withAttributes:@{NSFontAttributeName           :[UIFont systemFontOfSize:16.0],
                                                NSForegroundColorAttributeName:[ColorHex colorWithHexString:@"0x333333"]}];
}

#pragma mark - 图表UI
- (void)drawUI:(CGContextRef)context {
    //方块贝塞尔曲线
    [self.dataModel enumerateObjectsUsingBlock:^(DataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *path = [UIBezierPath  bezierPath];
        path.lineWidth = 1.0;
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineCapRound;
        CGFloat ratio = obj.saleRadio;
        [path moveToPoint:CGPointMake(MARGELEFT + idx * (SQUAREWIDTH + SQUARESPACE) , BASEPOINTY)]; //起始点
        [path addLineToPoint:CGPointMake(MARGELEFT + idx * (SQUAREWIDTH + SQUARESPACE), SQUAREHEIGHT * ratio + SQUAREHEIGHTOFFSET)];//第一条上去的线
        [path addLineToPoint:CGPointMake(MARGELEFT + SQUAREWIDTH + idx * (SQUAREWIDTH + SQUARESPACE), SQUAREHEIGHT * ratio + SQUAREHEIGHTOFFSET)];//第二条横线线
        [path addLineToPoint:CGPointMake(MARGELEFT + SQUAREWIDTH + idx * (SQUAREWIDTH + SQUARESPACE), BASEPOINTY)];//第三条下来的线
        if (_index == idx) {//被电击的方块颜色变换
            [self prepGradient:context
                          path:path.CGPath
                        colors:@[(__bridge id)[ColorHex colorWithHexString:@"0x58a5fa"].CGColor,(__bridge id)[ColorHex colorWithHexString:@"0x2867cf"].CGColor]
                     effective:YES];
        } else {
            [self prepGradient:context
                          path:path.CGPath
                        colors:@[(__bridge id)[ColorHex colorWithHexString:@"0x97c7fc"].CGColor,(__bridge id)[ColorHex colorWithHexString:@"0x65a0e1"].CGColor]
                     effective:YES];
        }
        
    }];
    
    //设置折线的颜色
    [[ColorHex colorWithHexString:@"0xf8e81c"] set];
    //折线曲线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 1.0;
    [self.dataModel enumerateObjectsUsingBlock:^(DataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat lineRadio = 0;
        lineRadio = obj.orderNumberRadio;//折线所占比例

        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        circlePath.lineWidth = 1.0;
        //画圆圈
        [circlePath addArcWithCenter:CGPointMake(MARGELEFT + SQUAREWIDTH/2 + idx * (SQUAREWIDTH + SQUARESPACE) , SQUAREHEIGHT * lineRadio + SQUAREHEIGHTOFFSET ) radius:2.0 startAngle:0 endAngle:M_PI * 2 clockwise:0];
        [circlePath stroke];
        [circlePath fill];

        //折线
        [linePath moveToPoint:CGPointMake(MARGELEFT + SQUAREWIDTH/2 + idx * (SQUAREWIDTH + SQUARESPACE) , SQUAREHEIGHT * lineRadio + SQUAREHEIGHTOFFSET )];//第N个方块的x中点位置
        if (idx < self.dataModel.count - 1) {//下一个方块的中点
            [linePath addLineToPoint:CGPointMake(MARGELEFT + SQUAREWIDTH/2 + (idx + 1) * (SQUAREWIDTH + SQUARESPACE) , SQUAREHEIGHT *  [self.dataModel[idx + 1] orderNumberRadio]  + SQUAREHEIGHTOFFSET)];
        }
    }];
    [linePath stroke];
    [linePath fill];
    
}


#pragma mark - 中间两条线和单位
- (void)drawLine:(CGContextRef)context {
    CGFloat marge = 7.0;//左边距
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 1.0;
       for (NSInteger i = 1; i< 5; i++) {
        [linePath moveToPoint:CGPointMake(0, BASEPOINTY - YHEIGHT * i/4)];
        [linePath addLineToPoint:CGPointMake(self.frame.size.width, BASEPOINTY - YHEIGHT * i/4)];
           NSString *unit = @"";
           if ([self.dataModel[i] leftUnit].integerValue > 100) {
               unit = [NSString stringWithFormat:@"%ld",[self.dataModel[i] leftUnit].integerValue * i/4];
           } else {
               unit = [NSString stringWithFormat:@"%.2f",[self.dataModel[i] leftUnit].floatValue * i/4];
           }        
        CGRect firstRectUp = CGRectMake(marge,  BASEPOINTY - YHEIGHT * i/4 - (5.0 + 17.0), 50.0, 17.0);
        [unit drawInRect:firstRectUp withAttributes:@{NSFontAttributeName            :[UIFont systemFontOfSize:12.0],
                                                      NSForegroundColorAttributeName :[ColorHex colorWithHexString:@"0x333333"]}];
    }
    [[ColorHex colorWithHexString:@"0xf5f5f5"] setStroke];
    [linePath stroke];
}


#pragma mark - 底部坐标
- (void)drawBottomCoordinate {
    //底部坐标线
    [[ColorHex colorWithHexString:@"0xe1e1e1"] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 2.0;
    [path moveToPoint:CGPointMake(MARGELEFT, BASEPOINTY + 5.0)];
    [path addLineToPoint:CGPointMake(MARGELEFT + (self.dataModel.count -1) * (SQUAREWIDTH + SQUARESPACE) + SQUAREWIDTH, BASEPOINTY + 5.0)];
    [path stroke];
    
    [self.dataModel enumerateObjectsUsingBlock:^(DataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *content = obj.unit;
//        NSString *content = @"12.27";
        NSLog(@"%f",iPhone5?11.0:13.0);
        NSDictionary *attribute = @{NSFontAttributeName            :[UIFont systemFontOfSize:iPhone5?11.0:13.0],
                                    NSForegroundColorAttributeName :[UIColor blackColor]};
        CGRect contentRect = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        //(SQUAREWIDTH - contentRect.size.width)/2 调整当前坐标的起始点位置，
        [content drawInRect:CGRectMake(MARGELEFT + idx * (SQUAREWIDTH + SQUARESPACE) + (SQUAREWIDTH - contentRect.size.width)/2, BASEPOINTY + 7.0, contentRect.size.width, contentRect.size.height) withAttributes:attribute];
    }];
}


//渐变色
- (void)prepGradient:(CGContextRef)context path:(CGPathRef)path colors:(NSArray *)colors effective:(BOOL)effective {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.2,0.6};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors ,locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    if (effective) {
        [self.squreRectArray addObject:[NSValue valueWithCGRect:pathRect]];
    }
   
    CGPoint start = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint end   = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);//入栈
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGContextRestoreGState(context);//Restore 归还，修复，计算机术语：出栈
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


#pragma mark - 判断点击位置是否是在方块上
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    [self.squreRectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect         = [obj CGRectValue];
        CGRect canClickArea = CGRectMake(rect.origin.x, SQUAREHEIGHTOFFSET, rect.size.width, SQUAREHEIGHT);//定制可点击区域，方块很小的时候点击也方便点击
        BOOL contain        = CGRectContainsPoint(canClickArea, touchPoint);
        if (contain) {
            UIView *v = [self viewWithTag:DETAILVIEWTAG];
            if (v) {
                [v removeFromSuperview];
                v = nil;
            }
            NSLog(@"点击第%ld个方块",idx);
            [self showDetailRect:rect row:idx];
        }
    }];
}


//展示View具体细节
- (void)showDetailRect:(CGRect)rect row:(NSUInteger)row {
    ShowDetailView *detailView = [[ShowDetailView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, SCALEWIDTH(108.0), SCALEHEIGHT(60.0))];
    if (row == self.squreRectArray.count - 1) {
        detailView.center = CGPointMake(rect.origin.x - 20.0, rect.origin.y - 10.0 - 30.0);
        detailView.backImageView.image = [UIImage imageNamed:@"WeeklyRight"];
    } else {
        detailView.center = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y - 10.0 - 30.0);//10 是距离当前方块的间距，50 是view 的高度
        detailView.backImageView.image = [UIImage imageNamed:@"WeeklyCenter"];
    }
    [self addSubview:detailView];
    detailView.tag = DETAILVIEWTAG;
    [detailView setDataModel:self.dataModel[row]];
    
    _index = row;
    [self.squreRectArray removeAllObjects];//清空存储的rect,因为是重新绘制了
    [self setNeedsDisplay];
}



- (void)setDataModel:(NSArray <DataModel *>*)dataModel {
    _dataModel = dataModel;
    [self setNeedsDisplay];
}

@end
