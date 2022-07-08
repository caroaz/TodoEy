

import Foundation

import UIKit

class CellCategory: UITableViewCell {

    var labelTask = UILabel()
    
    func prepare(){
        contentView.addSubview(labelTask)
        configureLabelTask()
        setLabelTaskConstraint()
        
    }
    public func set(tasks : String){
        labelTask.text = tasks
    }
    
    
    private func configureLabelTask(){
            labelTask.numberOfLines = 0
            labelTask.adjustsFontSizeToFitWidth = true
        
        }
    
    private  func setLabelTaskConstraint(){
        labelTask.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                labelTask.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                labelTask.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                labelTask.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                labelTask.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
               ])
           }

}
