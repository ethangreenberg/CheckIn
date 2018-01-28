//
//  ViewControllerMood.swift
//  CheckIn
//
//  Created by Katerina Rusa on 1/27/18.
//  Copyright © 2018 TeamCheckIn. All rights reserved.
//

import UIKit

class ViewControllerMood: UIViewController {
    private let frameRate: Double = 30
    private var animationTimer:Timer!
    @IBOutlet weak var moodController: MoodSelector!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("You have created a ViewControllerMood.")
        
        // Creates the animation timer.
        animationTimer = Timer.scheduledTimer(timeInterval: 1 / frameRate, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        moodController.updateSliceOuterRadii()
        moodController.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
