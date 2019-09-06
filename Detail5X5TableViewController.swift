import UIKit
class Detail5X5TableViewController: UITableViewController {
    let titleBtn = UIButton()
    let datePicker = UIDatePicker()
    let dateBgView = UIView()
    let dateConformBtn = UIButton()
    var plan = Plan5x5()
    var lastDate = Date()
    var isNew = true
    var changeItem = UIBarButtonItem()
    var addItem = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        addItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(Detail5X5TableViewController.addItmClicked(item:)))
        changeItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(Detail5X5TableViewController.changeItmClicked(item:)))
        self.navigationItem.setRightBarButtonItems([addItem, changeItem], animated: true)
        titleBtn.frame = CGRect(x: 0, y: 0, width: 160, height: 40)
        titleBtn.setTitleColor(UIColor.blue, for: .normal)
        titleBtn.addTarget(self, action: #selector(Detail5X5TableViewController.titleTouched(btn:)), for: .touchUpInside)
        self.navigationItem.titleView = titleBtn
        dateBgView.frame = self.view.bounds
        dateBgView.backgroundColor = UIColor.black
        dateBgView.alpha = 0.5
        dateBgView.isHidden = true
        self.view.addSubview(dateBgView)
        dateConformBtn.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
        dateConformBtn.setTitle("Done", for: .normal)
        dateConformBtn.setTitleColor(UIColor.blue, for: .normal)
        dateConformBtn.backgroundColor = UIColor.white
        dateConformBtn.addTarget(self, action: #selector(Detail5X5TableViewController.dateConformTouched(btn:)), for: .touchUpInside)
        dateConformBtn.isHidden = true
        self.view.addSubview(dateConformBtn)
        datePicker.locale = Locale(identifier: "zh")
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: self.view.frame.height + 40, width: self.view.frame.width, height: 400)
        datePicker.addTarget(self, action: #selector(Detail5X5TableViewController.dateChanged(datePicker:)), for: .valueChanged)
        self.view.addSubview(datePicker)
        datePicker.isHidden = true
        if isNew {
            plan.planType = .typeA
            plan.firstWorkout.targetKG = 20
            plan.secondWorkout.targetKG = 20
            plan.thirdWorkout.targetKG = 20
            plan.date = Date()
            titleBtn.setTitle("Today↓", for: .normal)
            addItem.title = "Add"
        } else {
            lastDate = plan.date ?? Date()
            addItem.title = "Done"
            titleBtn.setTitle(getDateString(aDate: plan.date ?? Date()) + "↓", for: .normal)
            addItem.isEnabled = false
        }
        datePicker.date = plan.date ?? Date()
        if plan.planType == .typeA {
            changeItem.title = "Swipe B"
        } else {
            changeItem.title = "Swipe A"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    @objc func addItmClicked (item : UIBarButtonItem) {
        if isNew {
            FMDBManager.share.insertPlan(aplan: plan)
        } else {
            plan.isDone = true
            FMDBManager.share.updatePlan(aplan: plan, oldTime: FMDBManager.share.dateToTime(date: lastDate))
            let newPlan = Plan5x5()
            if plan.planType == .typeA {
                newPlan.planType = .typeB
            } else {
                newPlan.planType = .typeA
            }
            newPlan.date = getDayNext(aDate: plan.date ?? Date(), days: 2)
            if plan.firstWorkout.isDone {
                newPlan.firstWorkout.targetKG = plan.firstWorkout.targetKG + 2.5
            } else {
                newPlan.firstWorkout.targetKG = plan.firstWorkout.targetKG
            }
            FMDBManager.share.loadLastPlan(count: 5) { (plans) in
                if plans.isEmpty {
                    newPlan.secondWorkout.targetKG = 20
                    newPlan.thirdWorkout.targetKG = 20
                } else {
                    for item in plans {
                        if self.plan.planType == .typeA {
                            if item.planType == .typeB {
                                if item.secondWorkout.isDone {
                                    newPlan.secondWorkout.targetKG = item.secondWorkout.targetKG + 2.5
                                } else {
                                    newPlan.secondWorkout.targetKG = item.secondWorkout.targetKG
                                }
                                if item.thirdWorkout.isDone {
                                    if item.thirdWorkout.targetKG < 100 {
                                        newPlan.thirdWorkout.targetKG = item.thirdWorkout.targetKG + 5
                                    } else {
                                        newPlan.thirdWorkout.targetKG = item.thirdWorkout.targetKG + 2.5
                                    }
                                } else {
                                    newPlan.thirdWorkout.targetKG = item.thirdWorkout.targetKG
                                }
                                break
                            } else {
                                newPlan.secondWorkout.targetKG = 20
                                newPlan.thirdWorkout.targetKG = 20
                            }
                        } else {
                            if item.planType == .typeA {
                                if item.secondWorkout.isDone {
                                    newPlan.secondWorkout.targetKG = item.secondWorkout.targetKG + 2.5
                                } else {
                                    newPlan.secondWorkout.targetKG = item.secondWorkout.targetKG
                                }
                                if item.thirdWorkout.isDone {
                                    newPlan.thirdWorkout.targetKG = item.thirdWorkout.targetKG + 2.5
                                } else {
                                    newPlan.thirdWorkout.targetKG = item.thirdWorkout.targetKG
                                }
                                break
                            } else {
                                newPlan.secondWorkout.targetKG = 20
                                newPlan.thirdWorkout.targetKG = 20
                            }
                        }
                    }
                }
                FMDBManager.share.insertPlan(aplan: newPlan, completionHandler: {
                    NotificationCenter.default.post(name: NSNotification.Name("planinserted"), object: nil)
                })
            }
        }
        do {
            let encodedData = try JSONEncoder().encode(plan)
            let jsonString = String(data:encodedData,encoding: .utf8)
            print(jsonString ?? "")
        } catch  {
            print("Error enableBroadcast (bind):\(error)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    @objc func changeItmClicked (item : UIBarButtonItem) {
        if plan.planType == .typeA {
            plan.planType = .typeB
            changeItem.title = "Swipe A"
        } else {
            changeItem.title = "Swipe B"
            plan.planType = .typeA
        }
        tableView.reloadData()
    }
    @objc func titleTouched(btn : UIButton) {
        print("titleTouched")
        if datePicker.isHidden {
            datePicker.isHidden = false
            dateBgView.isHidden = false
            dateConformBtn.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.datePicker.frame = CGRect(x: 0, y: self.view.frame.height - 400, width: self.view.frame.width, height: 400)
                self.dateConformBtn.frame = CGRect(x: 0, y: self.view.frame.height - 440, width: self.view.frame.width, height: 40)
                self.dateBgView.alpha = 0.5
            }) { (finished) in
            }
        } else {
            hideDatePicker()
        }
    }
    @objc func dateConformTouched(btn : UIButton) {
        print("dateConformTouched")
        hideDatePicker()
        titleBtn.setTitle(getDateString(aDate: getDayNext(aDate: datePicker.date, days: 0) ?? Date()) + "↓", for: .normal)
        plan.date = datePicker.date
        print("week day = \(String(describing: getWeekDay(aDate: datePicker.date)))")
        if !isNew {
            FMDBManager.share.updatePlan(aplan: plan, oldTime: FMDBManager.share.dateToTime(date: lastDate))
        }
    }
    @objc func dateChanged(datePicker : UIDatePicker) {
        print("dateChanged")
    }
    func hideDatePicker() {
        UIView.animate(withDuration: 0.2, animations: {
            self.datePicker.frame = CGRect(x: 0, y: self.view.frame.height + 40, width: self.view.frame.width, height: 400)
            self.dateConformBtn.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 40)
            self.dateBgView.alpha = 0
        }) { (finished) in
            self.datePicker.isHidden = true
            self.dateBgView.isHidden = true
            self.dateConformBtn.isHidden = true
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var id = "reuseIdentifier"
        if indexPath.section == 3 {
            id = "reuseIdentifier3"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        switch indexPath.section {
        case 0:
            if let acell = cell as? MainWorkoutTableViewCell {
                acell.setWorkout(workout: plan.firstWorkout)
                acell.delegate = self
            }
        case 1:
            if let acell = cell as? MainWorkoutTableViewCell {
                acell.setWorkout(workout: plan.secondWorkout)
                acell.delegate = self
            }
        case 2:
            if let acell = cell as? MainWorkoutTableViewCell {
                acell.setWorkout(workout: plan.thirdWorkout)
                acell.delegate = self
            }
        case 3:
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            if plan.planType == .typeA {
                cell.textLabel?.text = "Auxiliary action: barbell shrugs, three heads down, two curls (3x8-12)"
            } else {
                cell.textLabel?.text = "Auxiliary action: barbell rowing, parallel bar arm flexion and extension, two head curling (3x8-12)"
            }
        default:
            break
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        case 1:
            return 160
        case 2:
            return 160
        case 3:
            return 50
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainWorkoutDetailViewController") as! MainWorkoutDetailViewController
            vc.workout = plan.firstWorkout
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainWorkoutDetailViewController") as! MainWorkoutDetailViewController
            vc.workout = plan.secondWorkout
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainWorkoutDetailViewController") as! MainWorkoutDetailViewController
            vc.workout = plan.thirdWorkout
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
extension Detail5X5TableViewController : MainWorkoutDetailViewControllerDelegate {
    func didSave() {
        if !isNew {
            FMDBManager.share.updatePlan(aplan: plan, oldTime: FMDBManager.share.dateToTime(date: lastDate))
        }
    }
}
extension Detail5X5TableViewController :  MainWorkoutTableViewCellDelegate {
    func shouldSave() {
        if !isNew {
            FMDBManager.share.updatePlan(aplan: plan, oldTime: FMDBManager.share.dateToTime(date: lastDate))
            addItem.isEnabled = true
        }
    }
}
