//
//  UpcomingLaunchesViewController.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 14/08/21.
//

import UIKit

class UpcomingLaunchesViewController: UIViewController {
    var spaceXRes : [SpaceXUpcomingModel]?
    @IBOutlet weak var upcomingTableView: UITableView!
    
    @IBOutlet weak var upcomingLblHeader: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.upcomingLblHeader.text = "Upcoming Rockets".Localized()
        self.upcomingTableView.delegate = self
        self.upcomingTableView.dataSource = self
        
        fetchSpaceX { [weak self] (spaceXResponse) in
        print(spaceXResponse)
               self?.spaceXRes = spaceXResponse
            
            DispatchQueue.main.async {
              
                self?.upcomingTableView.reloadData()
             }
        }
        // Do any additional setup after loading the view.
    }
    
    
    func fetchSpaceX(completionHandler: @escaping (upcomingSpaceX) -> Void) {
        let url = URL(string:SpaceXConfig.sharedInstance.getSpaceXUpcomingListAPIKey())!

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
             let spaceX = try? JSONDecoder().decode(upcomingSpaceX.self, from: data) {
            print(spaceX)
            completionHandler(spaceX)
          }
//            let productsJson = self.dataToJSON(data: data!)
//            print(productsJson)

        })
        task.resume()
      }
    
    func dataToJSON(data: Data) -> Any? {
       do {
           return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
       } catch let myJSONError {
           print(myJSONError)
       }
       return nil
    }
    
    
}



extension UpcomingLaunchesViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
}
extension UpcomingLaunchesViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spaceXRes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTableViewCell") as! UpcomingTableViewCell
        let spaceXDetails = self.spaceXRes
        print(spaceXDetails?[indexPath.row].rocket)
        cell.nameLbl.text = spaceXDetails?[indexPath.row].rocket
       // cell.descLbl.text = spaceXDetails?[indexPath.row].details
   
        
        return cell
    }
}

class UpcomingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    var myNavigation : UIViewController?
    
    
}

