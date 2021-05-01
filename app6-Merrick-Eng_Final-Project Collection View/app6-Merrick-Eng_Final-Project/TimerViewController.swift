//
//  TimerViewController.swift
//  app6-Merrick-Eng_Final-Project
//
//  Created by Merrick Eng on 4/29/21.
//
//  Basic circle animation provided by Leo Dabus (Stack Overflow) and modified in order to fit project needs.
//

import UIKit

class TimerViewController: UIViewController {

    // define time left
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 25 * 60 + 1
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()
    
    // my fields
    var numRounds = 1
    var currRound = 1
    let timePerRound: TimeInterval = 25 * 60 + 1
    let breakTime: TimeInterval = 5 * 60 + 1
    var breakMode = false
    
//    let timePerRound: TimeInterval = 5 + 1
//    let breakTime: TimeInterval = 2 + 1
    var timerStarted = false
    var timerRunning = false
    var savedSpeed : Float = 0.0
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    

    // MARK: - methods to create UIBezierPath
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
    }
    
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor(named: "Forest Green")?.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        view.layer.addSublayer(timeLeftShapeLayer)
    }

    // add label
    func addTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-25, width: 100, height: 50))
        timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
        view.addSubview(timeLabel)
    }
    
    // at viewDidload set the endTime and add your CAShapeLayer to your view
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        drawBgShape()
        drawTimeLeftShape()
        addTimeLabel()
        timeLabel.text = "\(numRounds) Round"
        
        // set min and max values for stepper
        stepper.minimumValue = 1
        stepper.maximumValue = 12
        
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
        
        // disable left button
        leftButton.isEnabled = false
        
        modeLabel.isHidden = true
        
        roundLabel.text = "Select the number of rounds"
        
        
    }
    
    // update mode label
    func updateModeLabel() {
        
        modeLabel.isHidden = false
        
        if breakMode {
            modeLabel.text = "Break time!"
        } else {
            modeLabel.text = "Crunch time - get working!"
        }
    }
    
    // update the time
    @objc func updateTime() {
        if timerRunning && timerStarted && currRound <= numRounds {
            roundLabel.text = "Round \(currRound) of \(numRounds)"
            
            if timeLeft > 0 {
                timeLeft = endTime?.timeIntervalSinceNow ?? 0
                timeLabel.text = timeLeft.time
            } else {
                timeLabel.text = "00:00"
                timer.invalidate()
                
                // call break timer
                if breakMode {
                    print("currRound is \(currRound)")
                    currRound += 1
                    print("currRound is now \(currRound)")
                    
                    if currRound <= numRounds{
                        resetTimerToRound()
                        rightButtonPressed((Any).self)
                    } else {
                        modeLabel.text = "You finished!"
                        rightButton.isEnabled = false
                        leftButton.setTitle("Reset", for: .normal)
                    }

                } else {
                    resetTimerToBreak()
                }
            }
        } else {
            if timeLeft > 0 {
                // update end time
                endTime = Date().addingTimeInterval(timeLeft)
            } else {
                timeLabel.text = "00:00"
                timer.invalidate()
            }
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        numRounds = Int(stepper.value)
        if numRounds == 1 {
            timeLabel.text = "\(numRounds) Round"
        } else {
            timeLabel.text = "\(numRounds) Rounds"
        }
        
    }
    
    // MARK: - Button functions
    @IBAction func rightButtonPressed(_ sender: Any) {

        if !timerStarted {
            // START TIMER
            print("timer started")
            
            updateModeLabel()
            
            // add the animation to your timeLeftShapeLayer
            timeLeftShapeLayer.add(strokeIt, forKey: nil)
            
            // controls label decreasing
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            timerStarted = true
            timerRunning = true
            
            rightButton.setTitle("Pause", for: .normal)
            
            // enable cancel button
            leftButton.isEnabled = true
            
            // hide stepper
            stepper.isHidden = true
            
        } else if timerRunning {
            // PAUSE TIMER
            print("timer paused")
            
            // if clicked that means is paused
            rightButton.setTitle("Resume", for: .normal)
            
            pauseTimer()
            
        } else {
            // RESUME TIMER
            print("timer resumed")

            // show option pause
            rightButton.setTitle("Pause", for: .normal)
            
            resumeTimer()
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        // if not enabled, do nothing
        guard leftButton.isEnabled else {
            return
        }
        
        leftButton.setTitle("Cancel", for: .normal)
        rightButton.isEnabled = true
        
        roundLabel.text = "Select the number of rounds"
        
        // reset timer on screen
        resetTimerToRound()

        // reset round label
        if numRounds == 1 {
            timeLabel.text = "\(numRounds) Round"
        } else {
            timeLabel.text = "\(numRounds) Rounds"
        }
        
        // show stepper
        stepper.isHidden = false
        
        
        // disable left button
        leftButton.isEnabled = false
        
        // make right button say star
        rightButton.setTitle("Start", for: .normal)
        
        // reset currRound
        currRound = 1
        
        modeLabel.isHidden = true
        
    }
    
    
    // MARK: - Timer functions
    
    func pauseTimer() {
        // pause the animation
        let pausedTime : CFTimeInterval = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        
        savedSpeed = timeLeftShapeLayer.speed
        timeLeftShapeLayer.speed = 0.0
        timeLeftShapeLayer.timeOffset = pausedTime
        
        
        // stop timer
        timerRunning = false
    }
    
    func resumeTimer() {
        // Resume shape layer animation
        let pausedTime = timeLeftShapeLayer.timeOffset
        timeLeftShapeLayer.speed = 1.0
        timeLeftShapeLayer.timeOffset = 0.0
        
        timeLeftShapeLayer.beginTime = 0.0
        let timeSincePause = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        timeLeftShapeLayer.beginTime = timeSincePause
        
        // start timer again
        timerRunning = true
    }
    
    func resetTimerToRound() {
        print("run time")
        // if enabled, reset the timer
        timeLeftShapeLayer.removeAllAnimations()
        
        // running is false
        timerRunning = false
        timerStarted = false
        
        // reset time left
        timeLeft = timePerRound
        
        // reset stroke duration
        strokeIt.duration = timeLeft
        
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
        
        resumeTimer()
        
        breakMode = false
        updateModeLabel()
    }
    
    func resetTimerToBreak() {
        
        print("break time")
        
        // reset timer on screen
        // if enabled, reset the timer
        timeLeftShapeLayer.removeAllAnimations()
        
        // running is false
        timerRunning = false
        timerStarted = false
        
        // reset time left
        timeLeft = breakTime
        
        // reset stroke duration
        strokeIt.duration = timeLeft
        
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
        
        resumeTimer()
        
        rightButtonPressed((Any).self)
        
        breakMode = true
        updateModeLabel()
        
    }
    
    @IBAction func showInfo(_ sender: Any) {
        // UIAlertController with text field, cancel button, done button
        print("instructions showing");
        
        // no text, tell user to put text
        let infoMessage = UIAlertController(title: "Pomodoro Timer", message: nil, preferredStyle: .alert)
        
        let alertMessage = """
        This timer leverages the Pomodoro Technique, which is a time management method that uses a timer to break down work into 25 minute intervals with a 5 minute break in between. During those 25 minutes, you focus strictly on the task at hand. You only take a break in the 5 minute rest period.
        
        Click the "+/-" buttons to change the number of rounds. Each round is a 30 minute period of 25 minutes of work and a 5 minute break.
        """
        
        // align left
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            
            let attributedMessageText = NSMutableAttributedString(
                string: alertMessage,
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
                ]
            )
        
        infoMessage.setValue(attributedMessageText, forKey: "attributedMessage")
        
        // ok button
        let okayAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code triggers when done button pressed
            print("Ok tapped");
        }
        
        infoMessage.view.tintColor = UIColor.init(named: "Forest Green")
        
        infoMessage.addAction(okayAction)
        
        present(infoMessage, animated: true)
    }
    
}

// use to convert degrees to radians and display time
extension TimeInterval {
//    var time: String {
//        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
//    }
    
    var time:String {
            if self < 60 {
                return String(format: "%01d:%02d", Int(self/60), Int(floor(self.truncatingRemainder(dividingBy: 60))))
            } else
            {
                print("timer is 60 or greater")
                print("\(Int(self/60))")
                return String(format: "%01d:%02d", Int(self/60), Int(floor(self.truncatingRemainder(dividingBy: 60))))
            }
        }
}
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
