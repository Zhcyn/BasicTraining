import UIKit
class CurrentPlanViewController: UIViewController {
    var plans : [Plan5x5] = [Plan5x5]()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Plan"
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentPlanViewController.planinserted(noti:)), name: Notification.Name(rawValue: "planinserted"), object: nil)
        let a = "cruzr1c"
        let b = "Cruzr1aC"
        print(a.caseInsensitiveCompare(b).rawValue)
        print(a.compare(b).rawValue)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Current Plan"
        reloadData()
    }
    func reloadData() {
        FMDBManager.share.loadLastPlan(count: 5) { (plans) in
            self.plans = plans
            self.tableView.reloadData()
        }
    }
    @objc func planinserted(noti : Notification) {
        reloadData()
    }
}
extension CurrentPlanViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return plans.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentplan", for: indexPath) as! CurrentplanTableViewCell
        let plan = plans[indexPath.section]
        cell.setPlan(plan: plan)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Detail5X5TableViewController") as! Detail5X5TableViewController
        vc.plan = plans[indexPath.section]
        vc.isNew = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "删除") { (action, indexPath) in
            FMDBManager.share.deleteRobot(aplan: self.plans[indexPath.section], completionHandler: {
                self.reloadData()
            })
        }
        return [deleteAction]
    }
}
