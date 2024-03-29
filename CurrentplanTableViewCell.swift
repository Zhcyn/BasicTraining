import UIKit
class CurrentplanTableViewCell: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var firstworkoutName: UILabel!
    @IBOutlet weak var secondworkoutName: UILabel!
    @IBOutlet weak var thirdworkoutName: UILabel!
    @IBOutlet weak var firstworkoutTargetKG: UILabel!
    @IBOutlet weak var secondworkoutTargetKG: UILabel!
    @IBOutlet weak var thirdworkoutTargetKG: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setPlan(plan : Plan5x5) {
        time.text = getDateString(aDate: plan.date ?? Date())
        firstworkoutName.text = plan.firstWorkout.workoutName
        secondworkoutName.text = plan.secondWorkout.workoutName
        thirdworkoutName.text = plan.thirdWorkout.workoutName
        firstworkoutTargetKG.text = "5X5 \(quxiaoshudianhoudeling(testNumber: "\(plan.firstWorkout.targetKG)"))KG"
        secondworkoutTargetKG.text = "5X5 \(quxiaoshudianhoudeling(testNumber: "\(plan.secondWorkout.targetKG)"))KG"
        thirdworkoutTargetKG.text = "5X5 \(quxiaoshudianhoudeling(testNumber: "\(plan.thirdWorkout.targetKG)"))KG"
    }
}
