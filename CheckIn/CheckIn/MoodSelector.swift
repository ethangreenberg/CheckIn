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
    private let colorArray:Array = [UIColor(red: 244/255, green: 194/255, blue: 13/255, alpha: 1), // happy
                                    UIColor(red: 72/255, green: 133/255, blue: 237/255, alpha: 1), // sad
                                    UIColor(red: 183/255, green: 112/255, blue: 209/255, alpha: 1), // stressed
                                    UIColor(red: 219/255, green: 50/255, blue: 54/255, alpha: 1), // angry
                                    UIColor(red: 60/255, green: 184/255, blue: 84/255, alpha: 1) // funny
                                    ]
    // These all could be @IBInspectable vars, but that breaks the view sometimes for some reason.
    private let arcOuter: CGFloat = 90
    private let arcInner: CGFloat = 25
    private let emojiSize: CGFloat = 20
    private let gapWidth: CGFloat = 5
    private let smoothing: CGFloat = 0.65
    private let startAngle: CGFloat = 3 / 2 * CGFloat.pi
    
    // These variables are needed for animation and to store th emoji choices/ current touch selection.
    private var sliceOuterRadii: Array = [CGFloat]()
    private var emojiArray:Array = [String]()
    public var currentlySelected: Int = -1
    
    init() {
        super.init(frame: .zero)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        print("You have created a mood selector.");
        self.translatesAutoresizingMaskIntoConstraints = false
        chooseEmojis()
    }
    
    public func updateSliceOuterRadii() {
        checkArray()
        for index in 0...numberOfEmojis - 1 {
            let radiusSelected: CGFloat = max(bounds.width * 0.5, bounds.height * 0.5)
            let radiusNormal: CGFloat = max(bounds.width * 0.5, bounds.height * 0.5) * arcOuter * 0.01
            if index == currentlySelected {
                sliceOuterRadii[index] = sliceOuterRadii[index] + (radiusSelected - sliceOuterRadii[index]) * (1 - smoothing)
            } else {
                sliceOuterRadii[index] = sliceOuterRadii[index] + (radiusNormal - sliceOuterRadii[index]) * (1 - smoothing)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUpdate(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUpdate(touches: touches)
    }
    
    private func touchUpdate(touches: Set<UITouch>) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            let height: CGFloat = position.y - bounds.height * 0.5
            let width: CGFloat = position.x - bounds.width * 0.5
            var initialPositionAngle: CGFloat = -startAngle + atan2(height, width)
            while initialPositionAngle < 0 {
                initialPositionAngle += 2 * CGFloat.pi
            }
            // Only works when >0 so it adds 2pi until >0 (bc of truncatingRem since no % for CGFloat)
            let positionAngle: CGFloat = initialPositionAngle.truncatingRemainder(dividingBy: 2 * CGFloat.pi)
            
            // Makes sure the pointer is inside the circle.
            let centerPoint: CGPoint = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
            let xDiff: CGFloat = position.x - centerPoint.x
            let yDiff: CGFloat = position.y - centerPoint.y
            let distance: CGFloat = pow(xDiff * xDiff + yDiff * yDiff, 0.5)
            if distance < min(centerPoint.x, centerPoint.x) {
                currentlySelected = Int(positionAngle / (2 * CGFloat.pi) * CGFloat(numberOfEmojis))
            } else {
                currentlySelected = -1
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Makes sure the pointer is inside the circle.
        if let touch = touches.first {
            let position = touch.location(in: self)
            let centerPoint: CGPoint = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
            let xDiff: CGFloat = position.x - centerPoint.x
            let yDiff: CGFloat = position.y - centerPoint.y
            let distance: CGFloat = pow(xDiff * xDiff + yDiff * yDiff, 0.5)
            if distance < min(centerPoint.x, centerPoint.x) {
                // If the click release is within the outer radius, a selection is made.
                print("Clicked section " + String(currentlySelected))
            }
            currentlySelected = -1
        }
    }
    
    public func checkArray() {
        if sliceOuterRadii.count == 0 {
            for _ in 0...numberOfEmojis - 1 {
                sliceOuterRadii.append(max(bounds.width * 0.5, bounds.height * 0.5) * arcOuter * 0.01)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        checkArray()
        
        // Sets up correctedEmojiSize
        let correctedEmojiSize: CGFloat = max(bounds.width, bounds.height) * emojiSize * 0.01
        
        // Sets up arc properties based on view characteristics.
        let arcCenter: CGPoint = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let arcRadiusInner: CGFloat = max(bounds.width * 0.5, bounds.height * 0.5) * arcInner * 0.01
        let angleIncrement: CGFloat = 2 * CGFloat.pi / CGFloat(numberOfEmojis)
        
        // Draws the arcs and emojis.
        for index: Int in 0...numberOfEmojis - 1 {
            let arcRadiusOuter = sliceOuterRadii[index]
            let arcStartAngle: CGFloat = startAngle + CGFloat(index) * angleIncrement
            let arcEndAngle: CGFloat = startAngle + (CGFloat(index) + 1) * angleIncrement
            
            // Adds the outer arc to the path.
            let currentPath:UIBezierPath = UIBezierPath(arcCenter: arcCenter, radius: arcRadiusOuter, startAngle: arcStartAngle, endAngle: arcEndAngle, clockwise: true)
            
            // Adds the inner arc to the path.
            currentPath.addArc(withCenter: arcCenter, radius: arcRadiusInner, startAngle: arcEndAngle, endAngle: arcStartAngle, clockwise: false)
            currentPath.close()
            
            // Adds the fill.
            let currentColor: UIColor = colorArray[index % colorArray.count]
            currentColor.setFill()
            currentPath.fill()
            
            // Adds the emoji.
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center;
            let fontAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: correctedEmojiSize)!, NSAttributedStringKey.paragraphStyle: paragraphStyle]
            let currentEmoji: String = emojiArray[index]
            let emojiAngle: CGFloat = (arcStartAngle + arcEndAngle) * 0.5
            let emojiRadius: CGFloat = (arcRadiusOuter + arcRadiusInner) * 0.5
            let emojiBox: CGRect = CGRect(x: bounds.width * 0.5 + emojiRadius * cos(emojiAngle) + correctedEmojiSize * -0.75,
                                          y: bounds.height * 0.5 + emojiRadius * sin(emojiAngle) + correctedEmojiSize * -0.65,
                                          width: correctedEmojiSize * 1.5,
                                          height: correctedEmojiSize * 1.5)
            currentEmoji.draw(in: emojiBox, withAttributes: fontAttributes);
        }
        
        // Draws the lines/spaces between fields.
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(gapWidth)
        context.setStrokeColor(UIColor.white.cgColor)
        for index: Int in 0...numberOfEmojis - 1 {
            let currentAngle: CGFloat = startAngle + CGFloat(index) * angleIncrement
            context.move(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5))
            context.addLine(to: CGPoint(
                x: bounds.width * 0.5 + cos(currentAngle) * max(bounds.width, bounds.height),
                y: bounds.height * 0.5 + sin(currentAngle) * max(bounds.width, bounds.height)))
            context.strokePath()
        }
    }
    
    private func chooseEmojis() {
        func randomEmoji(emojis: Array<String>) -> String {
            let randomNumber: Int = Int(arc4random_uniform(UInt32(emojis.count)))
            return emojis[randomNumber]
        }
        
        emojiArray.append(randomEmoji(emojis: ["😁", "😄", "😊", "😝", "🙂"])) // happy
        emojiArray.append(randomEmoji(emojis: ["😢", "😭", "😩", "😖"])) // sad
        emojiArray.append(randomEmoji(emojis: ["😱", "😨", "😟", "😬", "😑", "😴", "🤒"])) // stressed
        emojiArray.append(randomEmoji(emojis: ["😡", "😠", "😤", "😧"])) // angry
        emojiArray.append(randomEmoji(emojis: ["😜", "😂", "🙃", "😎"])) // funny
    }
}
