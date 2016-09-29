//
//  Graphics.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 30.11.2014.
//  Copyright (c) 2014 128Pixels. All rights reserved.
//

import Foundation
import UIKit

open class Graphics : NSObject {
   
   // Drawing Methods
   
   open class func drawCanvas1(frame: CGRect) {
      //// General Declarations
      let context = UIGraphicsGetCurrentContext()
      
      
      //// Shadow Declarations
      let innerGlow = UIColor.white
      let innerGlowOffset = CGSize(width: 0.1, height: -0.1)
      let innerGlowBlurRadius: CGFloat = 20
      let shadow = UIColor.black
      let shadowOffset = CGSize(width: 0.1, height: -0.1)
      let shadowBlurRadius: CGFloat = 5
      
      //// Oval 2 Drawing
      let oval2Path = UIBezierPath(ovalIn: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
      context?.saveGState()
      context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: (shadow as UIColor).cgColor)
      UIColor.white.setStroke()
      oval2Path.lineWidth = 0.5
      oval2Path.stroke()
      context?.restoreGState()
      
      
      //// Oval Drawing
      let ovalPath = UIBezierPath(ovalIn: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
      UIColor.clear.setFill()
      ovalPath.fill()
      
      ////// Oval Inner Shadow
      context?.saveGState()
      context?.clip(to: ovalPath.bounds)
      context?.setShadow(offset: CGSize(width: 0, height: 0), blur: 0)
      context?.setAlpha((innerGlow as UIColor).cgColor.alpha)
      context?.beginTransparencyLayer(auxiliaryInfo: nil)
      let ovalOpaqueShadow = (innerGlow as UIColor).withAlphaComponent(1)
      context?.setShadow(offset: innerGlowOffset, blur: innerGlowBlurRadius, color: (ovalOpaqueShadow as UIColor).cgColor)
      context?.setBlendMode(CGBlendMode.sourceOut)
      context?.beginTransparencyLayer(auxiliaryInfo: nil)
      
      ovalOpaqueShadow.setFill()
      ovalPath.fill()
      
      context?.endTransparencyLayer()
      context?.endTransparencyLayer()
      context?.restoreGState()
      
      
      
      //// path-1 Drawing
      let path1Path = UIBezierPath()
      path1Path.move(to: CGPoint(x: frame.minX + 0.50169 * frame.width, y: frame.minY + 0.70980 * frame.height))
      path1Path.addCurve(to: CGPoint(x: frame.minX + 0.43153 * frame.width, y: frame.minY + 0.70003 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.47727 * frame.width, y: frame.minY + 0.70980 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.45371 * frame.width, y: frame.minY + 0.70637 * frame.height))
      path1Path.addLine(to: CGPoint(x: frame.minX + 0.37589 * frame.width, y: frame.minY + 0.73285 * frame.height))
      path1Path.addLine(to: CGPoint(x: frame.minX + 0.37589 * frame.width, y: frame.minY + 0.67620 * frame.height))
      path1Path.addCurve(to: CGPoint(x: frame.minX + 0.26419 * frame.width, y: frame.minY + 0.49007 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.30889 * frame.width, y: frame.minY + 0.63735 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26419 * frame.width, y: frame.minY + 0.56862 * frame.height))
      path1Path.addCurve(to: CGPoint(x: frame.minX + 0.50169 * frame.width, y: frame.minY + 0.27035 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.26419 * frame.width, y: frame.minY + 0.36872 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.37053 * frame.width, y: frame.minY + 0.27035 * frame.height))
      path1Path.addCurve(to: CGPoint(x: frame.minX + 0.73919 * frame.width, y: frame.minY + 0.49007 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.63286 * frame.width, y: frame.minY + 0.27035 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.73919 * frame.width, y: frame.minY + 0.36872 * frame.height))
      path1Path.addCurve(to: CGPoint(x: frame.minX + 0.50169 * frame.width, y: frame.minY + 0.70980 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.73919 * frame.width, y: frame.minY + 0.61142 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.63286 * frame.width, y: frame.minY + 0.70980 * frame.height))
      path1Path.close()
      path1Path.move(to: CGPoint(x: frame.minX + 0.43120 * frame.width, y: frame.minY + 0.45075 * frame.height))
      path1Path.addLine(to: CGPoint(x: frame.minX + 0.48543 * frame.width, y: frame.minY + 0.51526 * frame.height))
      path1Path.addLine(to: CGPoint(x: frame.minX + 0.40951 * frame.width, y: frame.minY + 0.60710 * frame.height))
      path1Path.addLine(to: CGPoint(x: frame.minX + 0.56893 * frame.width, y: frame.minY + 0.53166 * frame.height))
      path1Path.addLine(to: CGPoint(x: frame.minX + 0.51471 * frame.width, y: frame.minY + 0.46606 * frame.height))
      path1Path.addLine(to: CGPoint(x: frame.minX + 0.58845 * frame.width, y: frame.minY + 0.37312 * frame.height))
      path1Path.addLine(to: CGPoint(x: frame.minX + 0.43120 * frame.width, y: frame.minY + 0.45075 * frame.height))
      path1Path.close()
      path1Path.miterLimit = 4;
      
      path1Path.usesEvenOddFillRule = true;
      
      UIColor.white.setFill()
      path1Path.fill()
   }
   
   //// Generated Images
   
   open class func imageOfCanvas1(frame: CGRect) -> UIImage {
      UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
      Graphics.drawCanvas1(frame: frame)
      
      let imageOfCanvas1 = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      
      return imageOfCanvas1
   }
   
}

@objc protocol StyleKitSettableImage {
   func setImage(_ image: UIImage!)
}

@objc protocol StyleKitSettableSelectedImage {
   func setSelectedImage(_ image: UIImage!)
}
