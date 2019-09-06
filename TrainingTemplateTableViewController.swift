import UIKit
class TrainingTemplateTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Training Template"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            print("didSelectRowAt at \(indexPath.row)")
            FMDBManager.share.loadLastPlan { (plans) in
                if plans.isEmpty {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "Detail5X5TableViewController") as! Detail5X5TableViewController
                    vc.isNew = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if plans[0].isDone {
                        let plan = plans[0]
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
                                    if plan.planType == .typeA {
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
                            FMDBManager.share.insertPlan(aplan: newPlan)
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "Detail5X5TableViewController") as! Detail5X5TableViewController
                            vc.plan = newPlan
                            vc.isNew = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "Detail5X5TableViewController") as! Detail5X5TableViewController
                        vc.plan = plans[0]
                        vc.isNew = false
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue")
    }
}
