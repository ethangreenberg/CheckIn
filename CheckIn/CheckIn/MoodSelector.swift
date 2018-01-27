//
//  MoodSelector.swift
//  CheckIn
//
//  Created by Katerina Rusa on 1/27/18.
//  Copyright © 2018 TeamCheckIn. All rights reserved.
//

import UIKit

@IBDesignable class MoodSelector: UIView {
    @IBInspectable var numberOfEmojis: Int = 5
    @IBInspectable var arcWidth: CGFloat = 60
    
    override func draw(_ rect: CGRect) {
        // Sets up arc properties based on view characteristics.
        let arcCenter: CGPoint = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let arcRadiusOuter: CGFloat = max(bounds.width * 0.5, bounds.height * 0.5)
        let arcRadiusInner: CGFloat = arcRadiusOuter * (1 - arcWidth * 0.01)
        let startAngle: CGFloat = 3 / 2 * CGFloat.pi
        let angleIncrement: CGFloat = 2 * CGFloat.pi / CGFloat(numberOfEmojis)
        
        // Draws the arcs.
        for index: Int in 0...numberOfEmojis - 1 {
            print("aaa")
            // Adds the outer arc to the path.
            let currentPath = UIBezierPath(arcCenter: arcCenter, radius: arcRadiusOuter, startAngle: startAngle + CGFloat(index) * angleIncrement, endAngle: startAngle + (CGFloat(index) + 1) * angleIncrement, clockwise: true)
            
            // Adds the inner arc to the path.
            currentPath.addArc(withCenter: arcCenter, radius: arcRadiusInner, startAngle: startAngle + (CGFloat(index) + 1) * angleIncrement, endAngle: startAngle + CGFloat(index) * angleIncrement, clockwise: false)
            currentPath.close()
            
            // Adds the fill.
            let currentColor: UIColor = UIColor(red: 0, green: 0, blue: CGFloat(index) / CGFloat(numberOfEmojis), alpha: 1)
            currentColor.setFill()
            currentPath.fill()
        }
    }
}
