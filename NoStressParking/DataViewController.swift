//
//  DataViewController.swift
//  NoStressParking
//
//  Created by Bhavesh Shah on 11/10/18.
//  Copyright © 2018 Bhavesh Shah. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class DataViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var infoTableView: UITableView!
    
    var areas: [[String: Any]] = []
    var refreshControl: UIRefreshControl!

    let apiKey = "rETGFuHGt4miUZZqWYQ5SywFG7Ynx1ek"
    let locationManager = CLLocationManager()
    var lat = 15.1515
    var lon = 51.5151
    var finalxcor = 0.0
    var finalycor = 0.0
    var coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        // Can use both when app is open and when app is in background.
        locationManager.requestAlwaysAuthorization()
        
        // Only use when app is open.
        //locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    // network request which returns location coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            coordinate=location.coordinate
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            request("https://apis.solarialabs.com/shine/v1/parking-rules/meters?lat=\(lat)&long=\(lon)&max-result=10&max-distance=\(5000)&apikey=\(apiKey)").responseJSON { response in
                let result = response.result
                let dataArray = response.value as! Array<Any>
                for data in dataArray
                    as! [Dictionary<String, Any>] {
//                        print(data["Meter_ID"] as! NSString)
                        print(data)
                }
                self.areas = dataArray as! [[String: Any]]
                self.infoTableView.reloadData()
//                print(response)
                if let dict = result.value as? [String: Any] {
                    if let innerDict = dict["Success"] {
                        self.areas=innerDict as! [[String : Any]]
                         // table is created before network request is processed, so this function continues to refresh data before finalizing table
                    }
                }
            }
        }
        print(self.areas)
    }
    
    // authorization code
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Disabled PopUp code
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to get parking information near you , we need your location.", preferredStyle: . alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.areas.count)
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! infoCell
        
        let area = areas[indexPath.row]
        print("fnsjbdhoiwrnsf;")
        print(area["Meter_ID"])
        var city = area["City"] as! String
//        print("https://data.boston.gov/api/3/action/datastore_search?resource_id=284d1d7b-e3f5-4de7-be32-06b54efeee7f&q=\(area["Meter_ID"] as! NSString)")
        request("https://data.boston.gov/api/3/action/datastore_search?resource_id=284d1d7b-e3f5-4de7-be32-06b54efeee7f&q=\(area["Meter_ID"] as! NSString)").responseJSON { response in
    //            let result = response.result
    //            print(response)
//            let dataArray = response.value as! [[String: Any]]
            print(response.value)
            
    //            if let dict = result.value as? [String: Any] {
    //                let innerDict = dict["records"]
    //                print(innerDict)
    ////                let street = innerDict["STREET"]
    ////                let cost = innerDict["PAY_POLICY"]
    //            }
        }
        print(area["Hours_of_Operation"])
        print(area["Rate"])
        cell.timingsLabel.text = area["Meter_ID"] as! String
        cell.costLabel.text = area["City"] as! String
        cell.probabilityLabel.text = area["Rate"] as! String
        finalxcor = area["Latitude"] as! Double
        finalycor = area["Longitude"] as! Double
        //cell.probabilityLabel.text = area["PERCENTAGE"] as! String
        
        return cell
    }
    
    @IBAction func onGo(_ sender: Any) {
        performSegue(withIdentifier: "dirSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! dirViewController
        vc.coordinate = self.coordinate
        vc.finalxcor = self.finalxcor
        vc.finalycor = self.finalycor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
