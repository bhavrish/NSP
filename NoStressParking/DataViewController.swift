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
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            request("https://apis.solarialabs.com/shine/v1/parking-rules/meters?lat=\(lat)&lon=\(lon)&maxresults=\(5)&apikey=\(apiKey)").responseJSON { response in
                let result = response.result
                if let dict = result.value as? [String: Any] {
                    if let innerDict = dict["Meters"] {
                        self.areas=innerDict as! [[String : Any]]
                        self.infoTableView.reloadData() // table is created before network request is processed, so this function continues to refresh data before finalizing table
                    }
                }
            }
        }
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
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! infoCell
        
        let area = areas[indexPath.row]
        print(area)
        //print(area["Hours_of_Operation"])
        //print(area["Rate"])
        cell.timingsLabel.text = area["Hours_of_Operation"] as! String
        cell.costLabel.text = area["Rate"] as! String
        //cell.probabilityLabel.text = area["PERCENTAGE"] as! String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
