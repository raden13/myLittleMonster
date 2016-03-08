//
//  MinerImg.swift
//  My Little Monster
//
//  Created by Arend Pryor on 3/4/16.
//  Copyright © 2016 RadenDesigns. All rights reserved.
//

import Foundation
import UIKit

class MinerImg: UIImageView {
    var timer: NSTimer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
        
    }
    
    func playIdleAnimation() {
        self.image = UIImage(named: "minerIdle1.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "minerIdle\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playThrowAnimation() {
        self.image = UIImage(named: "throw1.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 6; x++ {
            let img = UIImage(named: "throw\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: "playIdleAnimation", userInfo: nil, repeats: false)
        
    }
    
    func playDeathAnimation2() {
        
        self.image = UIImage(named: "minerDead5.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 5; x++ {
            let img = UIImage(named: "minerDead\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
        
    
}
