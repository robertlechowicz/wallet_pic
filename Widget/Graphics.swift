//
//  Graphics.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 30.11.2014.
//  Copyright (c) 2014 128Pixels. All rights reserved.
//

import Foundation
import UIKit

public class Graphics : NSObject {
   
   // Drawing Methods
   
   public class func drawCanvas1(frame frame: CGRect) {
      //// General Declarations
      let context = UIGraphicsGetCurrentContext()
      
      
      //// Shadow Declarations
      let innerGlow = UIColor.whiteColor()
      let innerGlowOffset = CGSizeMake(0.1, -0.1)
      let innerGlowBlurRadius: CGFloat = 20
      let shadow = UIColor.blackColor()
      let shadowOffset = CGSizeMake(0.1, -0.1)
      let shadowBlurRadius: CGFloat = 5
      
      //// Oval 2 Drawing
      let oval2Path = UIBezierPath(ovalInRect: CGRectMake(frame.minX, frame.minY, frame.width, frame.height))
      CGContextSaveGState(context)
      CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, (shadow as UIColor).CGColor)
      UIColor.whiteColor().setStroke()
      oval2Path.lineWidth = 0.5
      oval2Path.stroke()
      CGContextRestoreGState(context)
      
      
      //// Oval Drawing
      let ovalPath = UIBezierPath(ovalInRect: CGRectMake(frame.minX, frame.minY, frame.width, frame.height))
      UIColor.clearColor().setFill()
      ovalPath.fill()
      
      ////// Oval Inner Shadow
      CGContextSaveGState(context)
      CGContextClipToRect(context, ovalPath.bounds)
      CGContextSetShadow(context, CGSizeMake(0, 0), 0)
      CGContextSetAlpha(context, CGColorGetAlpha((innerGlow as UIColor).CGColor))
      CGContextBeginTransparencyLayer(context, nil)
      let ovalOpaqueShadow = (innerGlow as UIColor).colorWithAlphaComponent(1)
      CGContextSetShadowWithColor(context, innerGlowOffset, innerGlowBlurRadius, (ovalOpaqueShadow as UIColor).CGColor)
      CGContextSetBlendMode(context, CGBlendMode.SourceOut)
      CGContextBeginTransparencyLayer(context, nil)
      
      ovalOpaqueShadow.setFill()
      ovalPath.fill()
      
      CGContextEndTransparencyLayer(context)
      CGContextEndTransparencyLayer(context)
      CGContextRestoreGState(context)
      
      
      
      //// path-1 Drawing
      let path1Path = UIBezierPath()
      path1Path.moveToPoint(CGPointMake(frame.minX + 0.50169 * frame.width, frame.minY + 0.70980 * frame.height))
      path1Path.addCurveToPoint(CGPointMake(frame.minX + 0.43153 * frame.width, frame.minY + 0.70003 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.47727 * frame.width, frame.minY + 0.70980 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.45371 * frame.width, frame.minY + 0.70637 * frame.height))
      path1Path.addLineToPoint(CGPointMake(frame.minX + 0.37589 * frame.width, frame.minY + 0.73285 * frame.height))
      path1Path.addLineToPoint(CGPointMake(frame.minX + 0.37589 * frame.width, frame.minY + 0.67620 * frame.height))
      path1Path.addCurveToPoint(CGPointMake(frame.minX + 0.26419 * frame.width, frame.minY + 0.49007 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.30889 * frame.width, frame.minY + 0.63735 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.26419 * frame.width, frame.minY + 0.56862 * frame.height))
      path1Path.addCurveToPoint(CGPointMake(frame.minX + 0.50169 * frame.width, frame.minY + 0.27035 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.26419 * frame.width, frame.minY + 0.36872 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.37053 * frame.width, frame.minY + 0.27035 * frame.height))
      path1Path.addCurveToPoint(CGPointMake(frame.minX + 0.73919 * frame.width, frame.minY + 0.49007 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.63286 * frame.width, frame.minY + 0.27035 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.73919 * frame.width, frame.minY + 0.36872 * frame.height))
      path1Path.addCurveToPoint(CGPointMake(frame.minX + 0.50169 * frame.width, frame.minY + 0.70980 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.73919 * frame.width, frame.minY + 0.61142 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.63286 * frame.width, frame.minY + 0.70980 * frame.height))
      path1Path.closePath()
      path1Path.moveToPoint(CGPointMake(frame.minX + 0.43120 * frame.width, frame.minY + 0.45075 * frame.height))
      path1Path.addLineToPoint(CGPointMake(frame.minX + 0.48543 * frame.width, frame.minY + 0.51526 * frame.height))
      path1Path.addLineToPoint(CGPointMake(frame.minX + 0.40951 * frame.width, frame.minY + 0.60710 * frame.height))
      path1Path.addLineToPoint(CGPointMake(frame.minX + 0.56893 * frame.width, frame.minY + 0.53166 * frame.height))
      path1Path.addLineToPoint(CGPointMake(frame.minX + 0.51471 * frame.width, frame.minY + 0.46606 * frame.height))
      path1Path.addLineToPoint(CGPointMake(frame.minX + 0.58845 * frame.width, frame.minY + 0.37312 * frame.height))
      path1Path.addLineToPoint(CGPointMake(frame.minX + 0.43120 * frame.width, frame.minY + 0.45075 * frame.height))
      path1Path.closePath()
      path1Path.miterLimit = 4;
      
      path1Path.usesEvenOddFillRule = true;
      
      UIColor.whiteColor().setFill()
      path1Path.fill()
   }
   
   //// Generated Images
   
   public class func imageOfCanvas1(frame frame: CGRect) -> UIImage {
      UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
      Graphics.drawCanvas1(frame: frame)
      
      let imageOfCanvas1 = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      
      return imageOfCanvas1
   }
   
}

@objc protocol StyleKitSettableImage {
   func setImage(image: UIImage!)
}

@objc protocol StyleKitSettableSelectedImage {
   func setSelectedImage(image: UIImage!)
}