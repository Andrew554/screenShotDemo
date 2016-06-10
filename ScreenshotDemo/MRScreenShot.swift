//
//  MRScreenShot.swift
//  ScreenshotDemo
//
//  Created by SinObjectC on 16/6/10.
//  Copyright © 2016年 SinObjectC. All rights reserved.
//

import UIKit

class MRScreenShot: UIImageView {
    
    /// 初始坐标点
    var startPoint: CGPoint!

    /// 裁剪区域黑色透明遮罩
    lazy var maskV: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.blackColor()
        
        view.alpha = 0.2
        
        return view
    }()
    
    
    override func awakeFromNib() {
        
        self.setUp();
        
    }
    
    
    /**
     *	@brief	初始化设置
     */
    func setUp() {
        
        self.userInteractionEnabled = true
        
        self.addSubview(self.maskV);
        
        // 添加手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        
        self.addGestureRecognizer(pan);
        
    }
    
    
    /**
     *	@brief	手势监听个方法
     */
    func didPan(pan: UIPanGestureRecognizer) {
        
        // 获取当前点坐标
        let currentPoint = pan.locationInView(self)
        
        if(pan.state == UIGestureRecognizerState.Began) {
            
            self.startPoint = currentPoint
            
        }else if(pan.state == UIGestureRecognizerState.Changed) {
            
            // 设置蒙板的尺寸
            self.maskV.frame = self.getMaskViewFrameByPoint(currentPoint)
            
        }else {
            
            // 开启图形上下文裁剪指定区域
           UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
            
           let ctx = UIGraphicsGetCurrentContext()
            
            let rectPath = UIBezierPath(rect: self.maskV.frame);
            
            // 设置裁剪区域
            rectPath.addClip()
            
            // 裁剪渲染
            self.layer.renderInContext(ctx!)
            
            // 获取裁剪之后的图片
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            
            // 再次开启图形上下文绘制图片
            UIGraphicsBeginImageContextWithOptions(self.maskV.frame.size, false, 0)
            
            image.drawAtPoint(CGPoint(x: -self.startPoint.x, y: -self.startPoint.y))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // 设置新图片
            self.image = newImage;
            
            self.maskV.frame = CGRectZero
        }
    }
    
    /**
     *	@brief	根据point计算frame
     */
    func getMaskViewFrameByPoint(point: CGPoint) -> CGRect {

        let width: CGFloat = point.x - self.startPoint.x;
        
        let height: CGFloat = point.y - self.startPoint.y;
        
        return CGRectMake(self.startPoint.x, self.startPoint.y, width, height);
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
