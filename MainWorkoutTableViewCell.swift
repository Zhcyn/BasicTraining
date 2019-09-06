import UIKit
import UserNotifications
protocol MainWorkoutTableViewCellDelegate : NSObjectProtocol {
    func shouldSave()
}
class MainWorkoutTableViewCell: UITableViewCell {
    weak var delegate : MainWorkoutTableViewCellDelegate?
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutTargetKGLabel: UILabel!
    @IBOutlet weak var warmupLabel: UILabel! {
        didSet {
            warmupLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var remind: UILabel!
    var workout = Workout()
    let view1 = UILabel()
    let view2 = UILabel()
    let view3 = UILabel()
    let view4 = UILabel()
    let view5 = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        view1.frame = CGRect(x: 16, y: 99, width: 50, height: 50)
        view1.layer.borderColor = UIColor.gray.cgColor
        view1.layer.borderWidth = 1
        view1.layer.cornerRadius = 25
        self.addSubview(view1)
        view2.frame = CGRect(x: (self.frame.width - 32 - 50 * 5)/4 * 1 + 1*50 + 16, y: 99, width: 50, height: 50)
        view2.layer.borderColor = UIColor.gray.cgColor
        view2.layer.borderWidth = 1
        view2.layer.cornerRadius = 25
        self.addSubview(view2)
        view3.frame = CGRect(x: (self.frame.width - 32 - 50 * 5)/4 * 2 + 2*50 + 16, y: 99, width: 50, height: 50)
        view3.layer.borderColor = UIColor.gray.cgColor
        view3.layer.borderWidth = 1
        view3.layer.cornerRadius = 25
        self.addSubview(view3)
        view4.frame = CGRect(x: (self.frame.width - 32 - 50 * 5)/4 * 3 + 3*50 + 16, y: 99, width: 50, height: 50)
        view4.layer.borderColor = UIColor.gray.cgColor
        view4.layer.borderWidth = 1
        view4.layer.cornerRadius = 25
        self.addSubview(view4)
        view5.frame = CGRect(x: (self.frame.width - 32 - 50 * 5)/4 * 4 + 4*50 + 16, y: 99, width: 50, height: 50)
        view5.layer.borderColor = UIColor.gray.cgColor
        view5.layer.borderWidth = 1
        view5.layer.cornerRadius = 25
        self.addSubview(view5)
        view1.textAlignment = .center
        view2.textAlignment = .center
        view3.textAlignment = .center
        view4.textAlignment = .center
        view5.textAlignment = .center
        view1.clipsToBounds = true
        view2.clipsToBounds = true
        view3.clipsToBounds = true
        view4.clipsToBounds = true
        view5.clipsToBounds = true
        view1.tag = 1001
        view2.tag = 1002
        view3.tag = 1003
        view4.tag = 1004
        view5.tag = 1005
        view1.textColor = UIColor.yellow
        view2.textColor = UIColor.yellow
        view3.textColor = UIColor.yellow
        view4.textColor = UIColor.yellow
        view5.textColor = UIColor.yellow
        view1.isUserInteractionEnabled = true
        view2.isUserInteractionEnabled = true
        view3.isUserInteractionEnabled = true
        view4.isUserInteractionEnabled = true
        view5.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(MainWorkoutTableViewCell.tap(ges:)))
        view1.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(MainWorkoutTableViewCell.tap(ges:)))
        view2.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(MainWorkoutTableViewCell.tap(ges:)))
        view3.addGestureRecognizer(tap3)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(MainWorkoutTableViewCell.tap(ges:)))
        view4.addGestureRecognizer(tap4)
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(MainWorkoutTableViewCell.tap(ges:)))
        view5.addGestureRecognizer(tap5)
    }
    func setWorkout(workout : Workout) {
        self.workout = workout
        workoutNameLabel.text = workout.workoutName
        workoutTargetKGLabel.text = "Aims：\(quxiaoshudianhoudeling(testNumber: "\(workout.targetKG)"))KG"
        showWarmup()
        if workout.firstGroup != 0 {
            if workout.firstGroup == 5 {
                view1.backgroundColor = UIColor.green
                view1.text = "\(workout.firstGroup)"
            } else {
                view1.backgroundColor = UIColor.orange
                view1.text = "\(workout.firstGroup)"
            }
        } else {
            view1.text = ""
        }
        if workout.secondGroup != 0 {
            if workout.secondGroup == 5 {
                view2.backgroundColor = UIColor.green
                view2.text = "\(workout.secondGroup)"
            } else {
                view2.backgroundColor = UIColor.orange
                view2.text = "\(workout.secondGroup)"
            }
        } else {
            view2.text = ""
        }
        if workout.thirdGroup != 0 {
            if workout.thirdGroup == 5 {
                view3.backgroundColor = UIColor.green
                view3.text = "\(workout.thirdGroup)"
            } else {
                view3.backgroundColor = UIColor.orange
                view3.text = "\(workout.thirdGroup)"
            }
        } else {
            view3.text = ""
        }
        if workout.fourthGroup != 0 {
            if workout.fourthGroup == 5 {
                view4.backgroundColor = UIColor.green
                view4.text = "\(workout.fourthGroup)"
            } else {
                view4.backgroundColor = UIColor.orange
                view4.text = "\(workout.fourthGroup)"
            }
        } else {
            view4.text = ""
        }
        if workout.fifthGroup != 0 {
            if workout.fifthGroup == 5 {
                view5.backgroundColor = UIColor.green
                view5.text = "\(workout.fifthGroup)"
            } else {
                view5.backgroundColor = UIColor.orange
                view5.text = "\(workout.fifthGroup)"
            }
        } else {
            view5.text = ""
        }
        if workout.workoutType == .deadlift {
            view2.text = "X"
            view3.text = "X"
            view4.text = "X"
            view5.text = "X"
            view2.textColor = UIColor.gray
            view3.textColor = UIColor.gray
            view4.textColor = UIColor.gray
            view5.textColor = UIColor.gray
        } else {
            view2.textColor = UIColor.yellow
            view3.textColor = UIColor.yellow
            view4.textColor = UIColor.yellow
            view5.textColor = UIColor.yellow
        }
        self.adjustDone()
    }
    func showWarmup() {
        var firstwarm = Double(workout.targetKG) * 0.5
        var secondwarm = Double(workout.targetKG) * 0.65
        var thirdwarm = Double(workout.targetKG) * 0.8
        thirdwarm = thirdwarm - thirdwarm.truncatingRemainder(dividingBy: 2.5)
        if Double(workout.targetKG) - thirdwarm < 5 {
            thirdwarm = Double(workout.targetKG) - 5
        }
        if thirdwarm < 5 {
            thirdwarm = 5
        }
        secondwarm = secondwarm - secondwarm.truncatingRemainder(dividingBy: 2.5)
        if thirdwarm - secondwarm < 5 {
            secondwarm = thirdwarm - 5
        }
        if secondwarm < 5 {
            secondwarm = 5
        }
        firstwarm = firstwarm - firstwarm.truncatingRemainder(dividingBy: 2.5)
        if secondwarm - firstwarm < 5 {
            firstwarm = secondwarm - 5
        }
        if firstwarm < 5 {
            firstwarm = 5
        }
        warmupLabel.text = "Warm-up group：\(quxiaoshudianhoudeling(testNumber: "\(firstwarm)"))KG1x5, \(quxiaoshudianhoudeling(testNumber: "\(secondwarm)"))KG1x5, \(quxiaoshudianhoudeling(testNumber: "\(thirdwarm)"))KG1x5"
    }
    @objc func tap(ges : UITapGestureRecognizer) {
        print("view tag = \(String(describing: ges.view?.tag))")
        switch ges.view!.tag {
        case 1001:
            workout.firstGroup -= 1
            if workout.firstGroup == 0 {
                view1.backgroundColor = UIColor.white
                view1.text = ""
                TimerView.share.hide()
                cancleNotifications()
            } else if workout.firstGroup == -1 {
                workout.firstGroup = 5
                view1.backgroundColor = UIColor.green
                view1.text = "\(workout.firstGroup)"
                if workout.workoutType != .deadlift {
                    startTimer(isDone: true)
                }
            } else {
                view1.backgroundColor = UIColor.orange
                view1.text = "\(workout.firstGroup)"
                if workout.workoutType != .deadlift {
                    startTimer(isDone: false)
                }
            }
        case 1002:
            if workout.workoutType == .deadlift {
                break
            }
            workout.secondGroup -= 1
            if workout.secondGroup == 0 {
                view2.backgroundColor = UIColor.white
                view2.text = ""
                TimerView.share.hide()
                cancleNotifications()
            } else if workout.secondGroup == -1 {
                workout.secondGroup = 5
                view2.backgroundColor = UIColor.green
                view2.text = "\(workout.secondGroup)"
                startTimer(isDone: true)
            } else {
                view2.backgroundColor = UIColor.orange
                view2.text = "\(workout.secondGroup)"
                startTimer(isDone: false)
            }
        case 1003:
            if workout.workoutType == .deadlift {
                break
            }
            workout.thirdGroup -= 1
            if workout.thirdGroup == 0 {
                view3.backgroundColor = UIColor.white
                view3.text = ""
                TimerView.share.hide()
                cancleNotifications()
            } else if workout.thirdGroup == -1 {
                workout.thirdGroup = 5
                view3.backgroundColor = UIColor.green
                view3.text = "\(workout.thirdGroup)"
                startTimer(isDone: true)
            } else {
                view3.backgroundColor = UIColor.orange
                view3.text = "\(workout.thirdGroup)"
                startTimer(isDone: false)
            }
        case 1004:
            if workout.workoutType == .deadlift {
                break
            }
            workout.fourthGroup -= 1
            if workout.fourthGroup == 0 {
                view4.backgroundColor = UIColor.white
                view4.text = ""
                TimerView.share.hide()
                cancleNotifications()
            } else if workout.fourthGroup == -1 {
                workout.fourthGroup = 5
                view4.backgroundColor = UIColor.green
                view4.text = "\(workout.fourthGroup)"
                startTimer(isDone: true)
            } else {
                view4.backgroundColor = UIColor.orange
                view4.text = "\(workout.fourthGroup)"
                startTimer(isDone: false)
            }
        case 1005:
            if workout.workoutType == .deadlift {
                break
            }
            workout.fifthGroup -= 1
            if workout.fifthGroup == 0 {
                view5.backgroundColor = UIColor.white
                view5.text = ""
                TimerView.share.hide()
                cancleNotifications()
            } else if workout.fifthGroup == -1 {
                workout.fifthGroup = 5
                view5.backgroundColor = UIColor.green
                view5.text = "\(workout.fifthGroup)"
            } else {
                view5.backgroundColor = UIColor.orange
                view5.text = "\(workout.fifthGroup)"
            }
            TimerView.share.hide()
            cancleNotifications()
        default:
            break
        }
        _ = delay(time: 1) {
            self.adjustDone()
        }
        delegate?.shouldSave()
    }
    func startTimer(isDone : Bool) {
        if isDone {
            TimerView.share.showMessage(msg: "Congratulations on completing 5 times, if you feel relaxed, rest 1:30, otherwise rest 3:00")
            cancleNotifications()
            addNotification(msg: "1:30 rest time, if the last time you made the last group is easier, you can start the next group.", time: 90)
            addNotification(msg: "At 3:00, the rest time is up, you can start the next group.", time: 180)
        } else {
            TimerView.share.showMessage(msg: "Failure is also part of the training. After 5 minutes of rest, proceed to the next set of training.")
            cancleNotifications()
            addNotification(msg: "5:00 rest time, come on to complete your next group", time: 300)
        }
    }
    func addNotification(msg : String, time : Int) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = msg
        content.badge = 0
        content.sound = UNNotificationSound.default
        content.launchImageName = "Default"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
        let request = UNNotificationRequest(identifier: msg, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { error in
            if error == nil {
                print("推送添加成功")
            }
        })
    }
    func cancleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("cancleNotifications")
    }
    func adjustDone() {
        if workout.workoutType == .deadlift {
            if (workout.firstGroup != 0) {
                remind.isHidden = true
                if (workout.firstGroup != 5) {
                    workout.isDone = false
                    warmupLabel.text = "The target is not completed, try again next time:\(quxiaoshudianhoudeling(testNumber: "\(workout.targetKG)"))KG，You can do it"
                } else {
                    workout.isDone = true
                    if workout.workoutType == .deadlift && workout.targetKG < 100 {
                        warmupLabel.text = "Congratulations, goal completion, next challenge:\(quxiaoshudianhoudeling(testNumber: "\(workout.targetKG + 5)"))KG"
                    } else {
                        warmupLabel.text = "Congratulations, goal completion, next challenge：\(quxiaoshudianhoudeling(testNumber: "\(workout.targetKG + 2.5)"))KG"
                    }
                }
            } else {
                workout.isDone = false
                remind.isHidden = false
                showWarmup()
            }
        } else {
            if (workout.firstGroup != 0) && (workout.secondGroup != 0) && (workout.thirdGroup != 0) && (workout.fourthGroup != 0) && (workout.fifthGroup != 0) {
                remind.isHidden = true
                if (workout.firstGroup != 5) || (workout.secondGroup != 5) || (workout.thirdGroup != 5) || (workout.fourthGroup != 5) || (workout.fifthGroup != 5)  {
                    workout.isDone = false
                    warmupLabel.text = "The target is not completed, try again next time：\(quxiaoshudianhoudeling(testNumber: "\(workout.targetKG)"))KG，You can do it"
                } else {
                    workout.isDone = true
                    if workout.workoutType == .deadlift && workout.targetKG < 100 {
                        warmupLabel.text = "Congratulations, goal completion, next challenge：\(quxiaoshudianhoudeling(testNumber: "\(workout.targetKG + 5)"))KG"
                    } else {
                        warmupLabel.text = "Congratulations, goal completion, next challenge：\(quxiaoshudianhoudeling(testNumber: "\(workout.targetKG + 2.5)"))KG"
                    }
                }
            } else {
                workout.isDone = false
                remind.isHidden = false
                showWarmup()
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
