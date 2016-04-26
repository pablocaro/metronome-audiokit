//
//  ViewController.swift
//  metronome-00
//
//  Created by Pablo Caro on 4/21/16.
//  Copyright © 2016 Pablo Caro. All rights reserved.
//

import UIKit
import AudioKit


class MetronomeViewController: UIViewController {
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
        }
    
    var tempo: Double = 60.0
    var tempoGestureScale: Double = 4
    var generator: AKOperationGenerator?
    var metronomeOn: Bool = false

    @IBOutlet weak var labelTempo: UILabel!
    @IBOutlet weak var buttonMetronome: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        generator = AKOperationGenerator(operation: AKOperation.sineWave(frequency: 440).triggeredWithEnvelope(AKOperation.metronome(AKOperation.parameters(0) / 60),attack: 0.01,hold: 0,release: 0.05))
        generator!.parameters = [tempo]
        AudioKit.output = generator
        AudioKit.start()
        toggleMetronome()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleMetronome() {
        if !metronomeOn {
            generator!.start()
            metronomeOn = true
            buttonMetronome.setTitle("Stop",forState: .Normal)
        } else {
            generator!.stop()
            metronomeOn = false
            buttonMetronome.setTitle("Start",forState: .Normal)
            
        }
    }
    
    
    @IBAction func buttonToggle(sender: UIButton) {
        toggleMetronome()
    }
    
    
    
    @IBAction func changeBeat(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self.view)
            let tempoChange = -Double(Double(translation.y) / tempoGestureScale)
            if tempoChange != 0 {
                tempo += tempoChange
                gesture.setTranslation(CGPointZero, inView: self.view)
                
                labelTempo.text = String(Int(tempo))
                generator!.parameters = [tempo]
                print (tempo)
            }
            
        default: break
            
        }
        
    }
    

}

