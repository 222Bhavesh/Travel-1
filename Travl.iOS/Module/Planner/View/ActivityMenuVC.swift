//
//  ActivityMenuVC.swift
//  Travl.iOS
//
//  Created by Ikmal Azman on 21/11/2021.
//

import UIKit

protocol ActivityMenuVCDelegate : AnyObject {
    func presentNewActivity(_ activityMenuVC : ActivityMenuVC, data : Activity)
}
final class ActivityMenuVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
    //MARK: - Variables
    var menuItem = [Menu]()
    var selectedRow = 0
    var data : Planner?
    weak var delegate : ActivityMenuVCDelegate?
    private var newActivity : Activity? {
        didSet {
            observerActions()
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        renderView()
        NotificationCenter.default.addObserver(self, selector: #selector(observerActions), name: Notification.Name(rawValue: "Dismiss"), object: nil)
    }
    //MARK: - Actions
    @IBAction func cancelButtonTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let newActivity = newActivity {
            delegate?.presentNewActivity(self, data: newActivity)
        }
    }
    
    @objc func observerActions() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - CV Datasource
extension ActivityMenuVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listOfMenu = menuItem[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.activityCollectionCell.identifier, for: indexPath) as! ActivityCollectionCell
        cell.setCell(data: listOfMenu)
        return cell
    }
    
}
//MARK: - CV Delegate
extension ActivityMenuVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("selected activity at row : \(indexPath.row)")
        switch indexPath.row {
        case 0 :
            selectedRow = indexPath.row
            performSegue(withIdentifier: "goToTourMenu", sender: self)
        case 1 :
            selectedRow = indexPath.row
            performSegue(withIdentifier: "goToTourMenu", sender: self)
        case 2 :
            return
        case 3 :
            return
        default :
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTourMenu" {
            let selectedActivity = menuItem[selectedRow]
            let destinationVC = segue.destination as! TourMenuVC
            destinationVC.plannerData = data
            destinationVC.navBarLabel = selectedActivity.label
            destinationVC.delegate = self
        }
    }
}

//MARK: - TourVC Delegate
extension ActivityMenuVC : TourMenuVCDelegate {
    func presentTourActivity(_ tourVC: TourMenuVC, activity: Activity) {
        newActivity = activity
        print("RECEIVEDDDD from ActivityMenuVC, newActivity : \(newActivity!)")
       
    }
}

//MARK: - Private methods
extension ActivityMenuVC {
    private func renderView() {
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        
        menuItem =  [
            Menu(image: "map.circle.fill", label: "Location"),
            Menu(image: "fork.knife.circle.fill", label: "Restaurant"),
            Menu(image: "bed.double.circle.fill", label: "Lodging"),
            Menu(image: "airplane.circle.fill", label: "Flight")
        ]
    }
    
}
