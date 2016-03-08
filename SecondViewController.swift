//
//  SecondViewController.swift
//  My Little Monster
//
//  Created by Arend Pryor on 3/4/16.
//  Copyright © 2016 RadenDesigns. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {

    @IBOutlet weak var minerImg: MinerImg!
    @IBOutlet weak var goldImg: DragImg!
    @IBOutlet weak var dynamiteImg: DragImg!
    @IBOutlet weak var foodImg: DragImg!
    
    @IBOutlet weak var penaltyImg1: UIImageView!
    @IBOutlet weak var penaltyImg2: UIImageView!
    @IBOutlet weak var penaltyImg3: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    @IBAction func onResetBtnTapped(sender: AnyObject) {
        minerImg.playIdleAnimation()
        startTimer()
        hideButtons()
        musicPlayer2.play()
        
        resetPenalties()
        minerHappy = false
    }
    
    @IBAction func onMenuBtnTapped(sender: AnyObject) {
        stopAllSound()
        currentItem = 0
    }
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var minerHappy = false
    var currentItem: UInt32 = 0
    var musicPlayer2: AVAudioPlayer!
    var sfxGold: AVAudioPlayer!
    var sfxDynamite: AVAudioPlayer!
    var sfxFood: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetPenalties()
        hideButtons()
        
        goldImg.dropTarget = minerImg
        dynamiteImg.dropTarget = minerImg
        foodImg.dropTarget = minerImg
        
        startTimer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            let resourcePath = NSBundle.mainBundle().pathForResource("searching", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try musicPlayer2 = AVAudioPlayer(contentsOfURL: url)
            try sfxGold = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("yeeHaw", ofType: "wav")!))
            try sfxDynamite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bomb", ofType: "wav")!))
            try sfxFood = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("deathYell", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        musicPlayer2.prepareToPlay()
        musicPlayer2.play()
        
        sfxGold.prepareToPlay()
        sfxDynamite.prepareToPlay()
        sfxFood.prepareToPlay()
        sfxSkull.prepareToPlay()
        sfxDeath.prepareToPlay()
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        minerHappy = true
        startTimer()
        
        goldImg.alpha = DIM_ALPHA
        goldImg.userInteractionEnabled = false
        dynamiteImg.alpha = DIM_ALPHA
        dynamiteImg.userInteractionEnabled = false
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxGold.play()
        } else if currentItem == 1 {
            sfxDynamite.play()
            minerImg.playThrowAnimation()
        } else {
            sfxFood.play()
        }
        
    }

    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !minerHappy {
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1 {
                penaltyImg1.alpha = OPAQUE
                penaltyImg2.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penaltyImg2.alpha = OPAQUE
                penaltyImg3.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penaltyImg3.alpha = OPAQUE
            } else {
                penaltyImg1.alpha = DIM_ALPHA
                penaltyImg2.alpha = DIM_ALPHA
                penaltyImg3.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(3)
        
        if rand == 0 {
            goldImg.alpha = OPAQUE
            goldImg.userInteractionEnabled = true
            
            dynamiteImg.alpha = DIM_ALPHA
            dynamiteImg.userInteractionEnabled = false
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
        } else if rand == 1 {
            goldImg.alpha = DIM_ALPHA
            goldImg.userInteractionEnabled = false
            
            dynamiteImg.alpha = OPAQUE
            dynamiteImg.userInteractionEnabled = true
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
        } else {
            goldImg.alpha = DIM_ALPHA
            goldImg.userInteractionEnabled = false
            
            dynamiteImg.alpha = DIM_ALPHA
            dynamiteImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        minerHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        minerImg.playDeathAnimation2()
        sfxDeath.play()
        musicPlayer2.stop()
        menuBtn.hidden = false
        resetBtn.hidden = false
    }
    
    
    func hideButtons() {
        menuBtn.hidden = true
        resetBtn.hidden = true
    }
    
    func resetPenalties() {
        penaltyImg1.alpha = DIM_ALPHA
        penaltyImg2.alpha = DIM_ALPHA
        penaltyImg3.alpha = DIM_ALPHA
        penalties = 0
        minerHappy = false
    }
    
    func stopAllSound() {
        musicPlayer2.stop()
        sfxGold.stop()
        sfxDynamite.stop()
        sfxFood.stop()
        sfxSkull.stop()
        
    }


}
