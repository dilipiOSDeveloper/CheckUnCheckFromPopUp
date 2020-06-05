//
//  StatusVC.swift
//  CheckUnCheckFromPopUp
//

import UIKit

protocol ProtocolDelegate {
    func values(str:String)
}


struct StatusList{
    
    var id:String?
    var status:String?
    var name:String?
    var isSelected:Bool = false
    
    init(id:String,status:String,name:String){
        self.id = id
        self.status = status
        self.name = name
    }
}



class StatusVC: UIViewController {

    @IBOutlet weak var statusTable:UITableView!
    @IBOutlet weak var doneBtn:UIButton!

   // var arrayStatus = [StatusList]()
    var arrayID = [String]()
    var delegate:ProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
       // jsonFetch()
        arrayID.removeAll()
        print(arrayID)
    }
    
    fileprivate func setUpViews(){
        setUpNavigation()
        statusTable.allowsMultipleSelection = true
        statusTable.allowsMultipleSelectionDuringEditing = true
        statusTable.separatorStyle = .none
        statusTable.tableFooterView = UIView()
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
    }
    
    func setUpNavigation(){
        self.navigationController?.navigationBar.barTintColor = .red
        self.navigationController?.navigationBar.tintColor = UIColor.white

        let label = UILabel(frame: CGRect(x: -5, y: 0, width: self.view.frame.width - 32, height: 15))
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        self.navigationItem.titleView = label
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 13, width: 15, height: 15))
        let imgBackArrow = UIImage(named: "")
        imageView.image = imgBackArrow
        view.addSubview(imageView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(clearButtonTapped))
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(self.arrayID)
    }
    
    
    @objc func clearButtonTapped(){
        //arrayStatus.removeAll()
        //dismiss(animated: true, completion: nil)
    }
    
    @objc func doneAction(){
        arrayID.removeAll()
        for item  in arrayStatus{
            if item.isSelected == true{
                arrayID.append(item.id!)
            }
        }
        
        if arrayID.count > 0{
            let stringJoined = arrayID.compactMap{ $0 }.joined(separator: ",")
            delegate?.values(str: stringJoined)
        }else{
            delegate?.values(str: "")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}


extension StatusVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrayStatus.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellStatus") as! StatusCell
            cell.selectionStyle = .none
            if let name = arrayStatus[indexPath.row].name{
                cell.lblStatus.text = name
            }
        
            let isSelected = arrayStatus[indexPath.row].isSelected
            if isSelected
            {
                cell.imageSelected.image = UIImage(named: "selected.png")
            }
            else
            {
                cell.imageSelected.image = UIImage(named: "unselected.png")
            }
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            guard let id = arrayStatus[indexPath.row].id else{return}
            print("ID :-  \(id)")
            
            let isSelected = arrayStatus[indexPath.row].isSelected
            if isSelected{
                arrayStatus[indexPath.row].isSelected = false
            }else{
                arrayStatus[indexPath.row].isSelected = true
            }
            self.statusTable.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}

class StatusCell: UITableViewCell {
    
    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
}
