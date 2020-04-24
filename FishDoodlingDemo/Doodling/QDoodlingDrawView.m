//
//  QDoodlingDrawView.m
//  画板
//
//  Created by zyj on 2017/12/13.
//  Copyright © 2017年 ittest. All rights reserved.
//

#import "QDoodlingDrawView.h"
#import <MJExtension.h>
#import "QDoodlingBezierPath.h"
@interface QDoodlingDrawView()




@end
@implementation QDoodlingDrawView


- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.isEraser = NO;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.isEraser = NO;
}

-(NSArray *)paths{
    if(!_paths){
        _paths=[NSMutableArray array];
    }
    return _paths;
}

- (void)clean{
    [self.paths removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

- (void)undo{
    [self.paths removeLastObject];
    //重绘
    [self setNeedsDisplay];
}

- (void)eraser{
    self.isEraser = YES;
}

- (void)save{
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //获取上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //截屏
    [self.layer renderInContext:context];
    //获取图片
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

//保存图片的回调
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
    }else{
        message = [error description];
    }
    NSLog(@"message is %@",message);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point=[touch locationInView:touch.view];
    //当手指按下的时候就创建一条路径
    QDoodlingBezierPath *path= [QDoodlingBezierPath bezierPath];
    
    path.model = [[QDoodlingModel alloc] init];
    
    path.model.isEraser = self.isEraser;
    //设置画笔颜色
    [path.model colorToIndexWithColor:self.lineColor];
    
    path.model.lineWidth = self.lineWidth;

    [path.model.points addObject:NSStringFromCGPoint(point)];
    //设置起点
    [path moveToPoint:point];
    // 把每一次新创建的路径 添加到数组当中
    [self.paths addObject:path];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point=[touch locationInView:touch.view];
    // 连线的点
    QDoodlingBezierPath *path = [self.paths lastObject];
    
    [path.model.points addObject:NSStringFromCGPoint(point)];
    [[self.paths lastObject] addLineToPoint:point];
    // 重绘
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (QDoodlingBezierPath *path in self.paths) {
        
        // 设置连接处的样式
        [path setLineJoinStyle:kCGLineJoinRound];
        // 设置头尾的样式
        [path setLineCapStyle:kCGLineCapRound];
        
        [path setLineWidth:path.model.lineWidth];
        //渲染
        if(path.model.isEraser){
            [path strokeWithBlendMode:kCGBlendModeDestinationIn alpha:1.0];
            [self.backgroundColor set];
        }else {
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
            //设置颜色
            [[path.model indexToColor] set];
        }
        [path stroke];
    }
}

- (UIImage *)snip {
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //获取上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    //截屏
    [self.layer renderInContext:context];
    //获取图片
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    return image;
}

- (NSString *)getPathsParams{
    if (_paths){
        NSMutableString *strs = [NSMutableString string];
        [strs appendString:@"["];
        for (int i = 0; i < self.paths.count; i ++){
            QDoodlingBezierPath *path = self.paths[i];
            if (path.model) {
                [strs appendString:path.model.mj_JSONString];
            }
            if (i != self.paths.count - 1){
                [strs appendString:@","];
            }
        }
        [strs appendString:@"]"];
        return strs;
//        return [[strs copy] encodeBase64];
    }
    return nil;
}

- (void)initDoodling:(NSString *)string{
    NSString *strs = string;
//    NSString *strs = [string dencodeBase64];
    NSMutableArray<QDoodlingModel *> *array = [QDoodlingModel mj_objectArrayWithKeyValuesArray:strs];
    NSLog(@"initDoodling:%ld", [QDoodlingModel mj_objectArrayWithKeyValuesArray:strs].count);
    for (int i = 0; i < array.count; i ++){
        QDoodlingModel *model = array[i];
        QDoodlingBezierPath *path = [[QDoodlingBezierPath alloc] init];
        path.model = model;
        for (int i = 0; i < model.points.count; i ++){
            NSString *pointStr = model.points[i];
            CGPoint point = CGPointFromString(pointStr);
            if (i == 0){
                [path moveToPoint:point];
            }else {
                [path addLineToPoint:point];
            }
        }
        [self.paths addObject:path];
    }
    [self setNeedsDisplay];
}

@end
