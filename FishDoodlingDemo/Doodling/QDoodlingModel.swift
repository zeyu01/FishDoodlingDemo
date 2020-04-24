


//
//  QDoodlingModel.swift
//  LEDSpace
//
//  Created by fish on 2020/2/8.
//  Copyright © 2020 fish. All rights reserved.
//

import UIKit

import MJExtension

class QDoodlingModel: NSObject{
    
    /// 线条颜色索引值
    @objc var colorIndex = 0
    
    /// 线条宽度
    @objc var lineWidth = 10
    
    /// 是否橡皮擦
    @objc var isEraser = false
    
    /// 坐标
    @objc var points : NSMutableArray = NSMutableArray()
    
    static let colors = [UIColor.orange, UIColor.red, UIColor.purple, UIColor.blue, UIColor.yellow, UIColor.darkGray]
    
    /// 颜色转索引
    @objc func colorToIndex(color : UIColor){
        if let index = QDoodlingModel.colors.firstIndex(of: color){
            colorIndex = index
        }
    }
    
    /// 索引转颜色
    @objc func indexToColor() -> (UIColor){
        return QDoodlingModel.colors[colorIndex]
    }
    
    override class func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["points" : NSString.classForCoder()]
    }

}
