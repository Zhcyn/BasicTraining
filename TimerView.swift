import UIKit
import UserNotifications
typealias ActionBlock = () -> ()
class MCGCDTimer {
    static let shared = MCGCDTimer()
    lazy var timerContainer = [String: DispatchSourceTimer]()
    func scheduledDispatchTimer(WithTimerName name: String?, timeInterval: Double, queue: DispatchQueue, repeats: Bool, action: @escaping ActionBlock) {
        if name == nil {
            return
        }
        var timer = timerContainer[name!]
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer?.resume()
            timerContainer[name!] = timer
        }
        timer?.schedule(deadline: .now(), repeating: timeInterval, leeway: DispatchTimeInterval.milliseconds(100))
        timer?.setEventHandler(handler: { [weak self] in
            action()
            if repeats == false {
                self?.cancleTimer(WithTimerName: name)
            }
        })
    }
    func cancleTimer(WithTimerName name: String?) {
        let timer = timerContainer[name!]
        if timer == nil {
            return
        }
        timerContainer.removeValue(forKey: name!)
        timer?.cancel()
    }
    func isExistTimer(WithTimerName name: String?) -> Bool {
        if timerContainer[name!] != nil {
            return true
        }
        return false
    }
}
class TimerView: UIView {
    static let share = TimerView()
    let timerLabel = UILabel()
    let textLabel = UILabel ()
    let closeBtn = UIButton()
    var time : Double = 0
    func updateViewHierarchy() {
        if self.superview == nil {
            if let window = UIApplication.shared.delegate?.window {
                self.frame = CGRect(x: 0, y: window!.bounds.height - 100, width: window!.bounds.width, height: 100)
                self.backgroundColor = UIColor.black
                window?.addSubview(self)
                self.isUserInteractionEnabled = false
            }
        }
        if let window = UIApplication.shared.delegate?.window {
            window?.bringSubviewToFront(self)
        }
    }
    func showMessage(msg : String) {
        updateViewHierarchy()
        MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
        self.isHidden = false
        self.isUserInteractionEnabled = true
        timerLabel.frame = CGRect(x: 0, y: 0, width: 80, height: 60)
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.white
        timerLabel.font = UIFont.systemFont(ofSize: 26)
        if timerLabel.superview == nil {
            self.addSubview(timerLabel)
        }
        textLabel.frame = CGRect(x: 80, y: 0, width: self.frame.width - 140, height: 60)
        textLabel.textAlignment = .left
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.numberOfLines = 0
        textLabel.text = msg
        if textLabel.superview == nil {
            self.addSubview(textLabel)
        }
        closeBtn.frame = CGRect(x: self.frame.width - 60, y: 0, width: 60, height: 60)
        closeBtn.setTitle("X", for: .normal)
        closeBtn.addTarget(self, action: #selector(TimerView.closeBtnClicked(btn:)), for: .touchUpInside)
        if closeBtn.superview == nil {
            self.addSubview(closeBtn)
        }
        time = 0
        startTimer()
    }
    func startTimer() {
        MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "GCDTimer", timeInterval: 1, queue: .main, repeats: true) {
            let fen = "\(Int(self.time/60))"
            let miao = Int(self.time.truncatingRemainder(dividingBy: 60))
            var miaos = ""
            if miao < 10 {
                miaos = "0\(miao)"
            } else {
                miaos = "\(miao)"
            }
            self.timerLabel.text = fen + ":" + miaos
            self.time += 1
        }
    }
    func hide() {
        self.isHidden = true
        MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("cancleNotifications")
    }
    @objc func closeBtnClicked (btn : UIButton) {
        self.isHidden = true
        MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("cancleNotifications")
    }
}
