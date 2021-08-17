//
//  SpaceXRocketsListVC.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 14/08/21.
//

import UIKit
import CoreData
class SpaceXRocketsListVC: UIViewController,UIGestureRecognizerDelegate {
    
    var topView: UIView?
    
    var spaceXRes : [SpaceXModel]?

    @IBOutlet weak var homeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
       self.homeTableView.allowsSelection = true
        
      
        fetchSpaceX { [weak self] (spaceXResponse) in
        print(spaceXResponse)
                self?.spaceXRes = [spaceXResponse]
            
            DispatchQueue.main.async {
                self?.homeTableView.reloadData()
             }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
   

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    func fetchSpaceX(completionHandler: @escaping (SpaceXModel) -> Void) {
        let url = URL(string:SpaceXConfig.sharedInstance.getSpaceXListAPIKey())!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

          if let data = data,
            let spaceX = try? JSONDecoder().decode(SpaceXModel.self, from: data) {
            print(spaceX.links.flickr)
            completionHandler( spaceX)
          }
        })
        task.resume()
      }
    

}



extension SpaceXRocketsListVC:UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spaceXRes?.count ?? 0
     }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 235
       }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let SpaceXCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        SpaceXCell.selectionStyle = .none
        let spaceXDetails = self.spaceXRes
        
        SpaceXCell.nameLbl.text = spaceXDetails?[indexPath.row].rocket
        SpaceXCell.previewText.text = spaceXDetails?[indexPath.row].details
        guard let imgURL = spaceXDetails?[indexPath.row].links.patch.small else { return SpaceXCell}
        SpaceXCell.rocketImagView.imageFromServerURL(urlString: imgURL, PlaceHolderImage:#imageLiteral(resourceName: "rocketEmpty"))
        SpaceXCell.FavBtn.addTarget(self, action: #selector(isFavoriteButtonTapped(_:)), for: .touchUpInside)
        SpaceXCell.FavBtn.tag = indexPath.row
        return SpaceXCell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let beforeLoginStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
              let DetailsVC = beforeLoginStoryBoard.instantiateViewController(withIdentifier: "RocketDetailsViewController") as! RocketDetailsViewController
        let spaceXDetails = self.spaceXRes
        DetailsVC.spaceXItem = spaceXDetails?[indexPath.row]
        
        navigationController?.pushViewController(DetailsVC, animated: true)
    }
    
    
    @objc func isFavoriteButtonTapped(_ sender: UIButton) {
         
         let buttonPosition = sender.convert(CGPoint.zero, to: self.homeTableView)
         guard let indexPath = self.homeTableView.indexPathForRow(at: buttonPosition) else { return }
    
         let spaceXDetails = self.spaceXRes

        guard let rocket_ID = spaceXDetails?[indexPath.row].rocket else { return }
         
         let checkFavorite = loadIsFavorite(shoe_ID: rocket_ID)
        print("fav check-----\(checkFavorite)")
        
         if isSelFav == true {
             sender.isSelected = false
            isSelFav = false

            updateIsFavorite(shoe_ID: rocket_ID, isFavorite: false)
         } else if isSelFav == false {
             sender.isSelected = true
            isSelFav = true
             updateIsFavorite(shoe_ID: rocket_ID, isFavorite: true)
         }
     }
    
    func loadIsFavorite(shoe_ID: String) -> Bool{
        
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDe.persistentContainer.viewContext
        var favorite = Bool()
        
        do {
            let sneaksObject = try context.fetch(SpaceXData.fetchRequest()) as [SpaceXData]
            
            print(sneaksObject)
            
            for i in 0..<sneaksObject.count {
                if shoe_ID == sneaksObject[i].spaceXId {
                    favorite = sneaksObject[i].isFav
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return favorite
    }

    func updateIsFavorite(shoe_ID: String, isFavorite: Bool) {
        
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDe.persistentContainer.viewContext
        do {
            let sneaksObject = try context.fetch(SpaceXData.fetchRequest()) as [SpaceXData]
            print(sneaksObject)
            
            for i in 0..<sneaksObject.count {
                       if shoe_ID == sneaksObject[i].spaceXId {
                        let user = SpaceXData(context: context)
                        context.delete(user)
                      
                       }
                   }
            try context.save()

        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func removeCoreData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SpaceXData") // Find this name in your .xcdatamodeld file
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            print(error.localizedDescription)
        }
    }
 }


class HomeCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!

    @IBOutlet weak var rocketImagView: UIImageView!

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet var previewText: UILabel!
    
    @IBOutlet weak var FavBtn: UIButton!
    
    var navigation : UIViewController?
    override func layoutSubviews() {
        
    }
}
    
