//
//  ViewController.swift
//  CheckUnCheckFromPopUp
//

import UIKit

var arrayStatus = [StatusList]()

class MainViewController: UIViewController,ProtocolDelegate {
   
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var nextBtn:UIButton!
    
    var strArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        jsonFetch()
    }
    
    fileprivate func setUpViews(){
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    @objc func nextAction(){
        
        DispatchQueue.main.async {
            if let vc :StatusVC = self.storyboard?.instantiateViewController(withIdentifier: "StatusVC") as? StatusVC{
                vc.delegate = self
                vc.arrayID = self.strArray
                vc.providesPresentationContextTransitionStyle = true
                vc.definesPresentationContext = true
                vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                let navController = UINavigationController(rootViewController: vc)
                self.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    func values(str: String) {
        let letters = str.components(separatedBy: ",")
        for value in letters{
            strArray.append(value)
        }
        self.lblName.text = str
    }
    
    private func jsonFetch(){
        
        if let path = Bundle.main.path(forResource: "generated", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                guard let json = jsonResult as? [String:AnyObject] else{return}
                print(json)
                let status = json["status"] as? Int
                if(status == 1){
                    
                    let data = json["data"] as? [[String:AnyObject]]
                    for value in data ?? [[:]]{
                        let id = value["id"] as? String ?? ""
                        let name = value["name"] as? String ?? ""
                        let status = value["status"] as? String ?? ""
                        
                        let value = StatusList(id: id, status: status, name: name)
                        arrayStatus.append(value)
                    }
                    
                }
                else{
                    print("error")
                }
                
            } catch {
                // handle error
            }
        }
    }
    
}

