//
//  MoodSelector.swift
//  CheckIn
//
//  Created by Katerina Rusa on 1/27/18.
//  Copyright © 2018 TeamCheckIn. All rights reserved.
//

import UIKit

@IBDesignable class MoodSelector: UIView {
    private let numberOfEmojis: Int = 5
    @IBInspectable var arcWidth: CGFloat = 60
    @IBInspectable var emojiSize: CGFloat = 60
    
    override func draw(_ rect: CGRect) {
        // Sets up arc properties based on view characteristics.
        let arcCenter: CGPoint = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let arcRadiusOuter: CGFloat = max(bounds.width * 0.5, bounds.height * 0.5)
        let arcRadiusInner: CGFloat = arcRadiusOuter * (1 - arcWidth * 0.01)
        let startAngle: CGFloat = 3 / 2 * CGFloat.pi
        let angleIncrement: CGFloat = 2 * CGFloat.pi / CGFloat(numberOfEmojis)
        
        // Draws the arcs.
        for index: Int in 0...numberOfEmojis - 1 {
            let arcStartAngle: CGFloat = startAngle + CGFloat(index) * angleIncrement
            let arcEndAngle: CGFloat = startAngle + (CGFloat(index) + 1) * angleIncrement
            
            // Adds the outer arc to the path.
            let currentPath = UIBezierPath(arcCenter: arcCenter, radius: arcRadiusOuter, startAngle: arcStartAngle, endAngle: arcEndAngle, clockwise: true)
            
            // Adds the inner arc to the path.
            currentPath.addArc(withCenter: arcCenter, radius: arcRadiusInner, startAngle: arcEndAngle, endAngle: arcStartAngle, clockwise: false)
            currentPath.close()
            
            // Adds the fill.
            let currentColor: UIColor = UIColor(red: 0, green: 0, blue: CGFloat(index) / CGFloat(numberOfEmojis), alpha: 1)
            currentColor.setFill()
            currentPath.fill()
            
            // Adds the emoji.
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center;
            let fontAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: emojiSize)!, NSAttributedStringKey.paragraphStyle: paragraphStyle]
            let currentEmoji: String = getEmoji()
            let emojiAngle: CGFloat = (arcStartAngle + arcEndAngle) * 0.5
            let emojiRadius: CGFloat = (arcRadiusOuter + arcRadiusInner) * 0.5
            let emojiBox: CGRect = CGRect(x: bounds.width * 0.5 + emojiRadius * cos(emojiAngle) + emojiSize * -0.75,
                                          y: bounds.height * 0.5 + emojiRadius * sin(emojiAngle) + emojiSize * -0.65,
                                          width: emojiSize * 1.5,
                                          height: emojiSize * 1.5)
            currentEmoji.draw(in: emojiBox, withAttributes: fontAttributes);
        }
    }
    
    private func getEmoji() -> String {
        let randomNumber: Int = Int(arc4random_uniform(10))
        var returnEmoji: String
        switch randomNumber {
        case 0:
            returnEmoji = "😊"
        case 1:
            returnEmoji = "😑"
        case 2:
            returnEmoji = "😥"
        case 3:
            returnEmoji = "😜"
        case 4:
            returnEmoji = "😤"
        case 5:
            returnEmoji = "😬"
        case 6:
            returnEmoji = "😱"
        case 7:
            returnEmoji = "🤒"
        case 8:
            returnEmoji = "😴"
        case 9:
            returnEmoji = "😃"
        default:
            returnEmoji = "😂"
        }
        return returnEmoji
    }
}
