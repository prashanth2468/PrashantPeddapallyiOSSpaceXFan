//
//  FavouriteVC.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 14/08/21.
//

import UIKit
//import SDWebImage

class FavouriteVC: UIViewController,UIGestureRecognizerDelegate {
    
  //  let Alamo_object = AlamoWebServices()
    var topView: UIView?
    @IBOutlet weak var favouriteTableView: UITableView!
    @IBOutlet weak var noResultsLbl: UILabel!
    var spaceXRes2 : [SpaceXModel]?
    var spaceXRes : [SpaceXModel]?
    var cordata : [SpaceXData]?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouriteTableView.delegate = self
        self.favouriteTableView.dataSource = self
       self.favouriteTableView.allowsSelection = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        if isSelFav == true {
            fetchSpaceX { [weak self] (spaceXResponse) in
            print(spaceXResponse)
                    self?.spaceXRes = [spaceXResponse]
                self?.loadFavorite()

            }
        }else{
            isSelFav = false

        }
        

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
    
    
    func loadFavorite() {
       
        DispatchQueue.main.async { [self] in
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDe.persistentContainer.viewContext
        var favorite = Bool()
        
        do {
            let sneaksObject = try context.fetch(SpaceXData.fetchRequest()) as [SpaceXData]
            
            print(sneaksObject)
            
            cordata = sneaksObject
        
            for i in 0..<sneaksObject.count {
  
                if sneaksObject[i].spaceXId == self.spaceXRes?[0].rocket {
                    spaceXRes2?.append((spaceXRes?[i])!)
                }
            }
            
        } catch {
            print(error.localizedDescription)
            
        }
        DispatchQueue.main.async {
            self.favouriteTableView.reloadData()

        }
    }
    }
}

extension FavouriteVC:UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spaceXRes?.count ?? 0
     }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 235
       }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let favCell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell") as! FavouriteCell
          favCell.selectionStyle = .none
        let spaceXDetails = spaceXRes
        
        favCell.nameLbl.text = spaceXDetails?[indexPath.row].rocket
        favCell.previewText.text = spaceXDetails?[indexPath.row].details
        guard let imgURL = spaceXDetails?[indexPath.row].links.patch.small else { return favCell}
        favCell.rocketImagView.imageFromServerURL(urlString: imgURL, PlaceHolderImage:#imageLiteral(resourceName: "rocketEmpty"))
        favCell.favBtn.addTarget(self, action: #selector(isFavoriteButtonTapped(_:)), for: .touchUpInside)
        favCell.favBtn.tag = indexPath.row
        favCell.favBtn.isSelected = true
    
        return favCell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let beforeLoginStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
              let DetailsVC = beforeLoginStoryBoard.instantiateViewController(withIdentifier: "RocketDetailsViewController") as! RocketDetailsViewController
        let spaceXDetails = self.spaceXRes
        DetailsVC.spaceXItem = spaceXDetails?[indexPath.row]
        
        navigationController?.pushViewController(DetailsVC, animated: true)
    }
    
    
    
    
    @objc func isFavoriteButtonTapped(_ sender: UIButton) {
         
         let buttonPosition = sender.convert(CGPoint.zero, to: self.favouriteTableView)
         guard let indexPath = self.favouriteTableView.indexPathForRow(at: buttonPosition) else { return }
    
         let spaceXDetails = cordata

         print(spaceXDetails)
        guard let rocket_ID = spaceXDetails?[indexPath.row].spaceXId else { return }
         
         let checkFavorite = loadIsFavorite(shoe_ID: rocket_ID)
        print("fav check-----\(checkFavorite)")
        
         if checkFavorite == true {
             sender.isSelected = false
            updateIsFavorite(shoe_ID: rocket_ID, isFavorite: false)
         } else if checkFavorite == false {
             sender.isSelected = true
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

            for i in 0..<sneaksObject.count {
                if shoe_ID == sneaksObject[i].spaceXId {
                    sneaksObject[i].setValue(isFavorite, forKey: "isFav")
                    appDe.saveContext()
                }
            }
            appDe.saveContext()

        } catch {
            print(error.localizedDescription)
        }
        
    }
    

}

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!

    @IBOutlet weak var rocketImagView: UIImageView!

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet var previewText: UILabel!
    var navigation : UIViewController?
    override func layoutSubviews() {
        
    }
}
                       
