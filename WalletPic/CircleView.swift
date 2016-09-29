//
//  CircleView.swift
//  WalletPic
//
//  Created by Robert Lechowicz on 15.11.2014.
//  Copyright (c) 2014 128Pixels. All rights reserved.
//

import UIKit

class CircleView: UIView {


   override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = UIColor.clear
   }

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.backgroundColor = UIColor.clear
       //fatalError("init(coder:) has not been implemented")
   }
   
   
   override func draw(_ rect: CGRect) {
    if let context = UIGraphicsGetCurrentContext() {
      
      context.setLineWidth(1.0)
      UIColor(red: 216.0/255.0, green: 218.0/255.0, blue: 220.0/255.0, alpha: 1.0).set()
      
      
      
      context.addArc(center: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                     radius: (frame.size.width - 1) / 2,
                     startAngle: 0.0,
                     endAngle:CGFloat(M_PI * 2.0),
                     clockwise: true)
      

//      CGContextAddArc(context, frame.size.width / 2, frame.size.height / 2, (frame.size.width - 1) / 2, 0.0, CGFloat(M_PI * 2.0), 1)

      context.strokePath()
    }
   }
   
}
