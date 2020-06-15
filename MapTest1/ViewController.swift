//
//  ViewController.swift
//  MapTest1
//
//  Created by 清水拓郎 on 2020/05/26.
//  Copyright © 2020 清水拓郎. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var locManager: CLLocationManager!
    var lonArray: [Double] = [0]
    var latArray: [Double] = [0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //位置情報へのアクセスを要求する
        locManager = CLLocationManager()
        locManager.delegate = self
        mapView.delegate = self
        
        //位置情報の使用の許可を得る
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                //座標の表示
                locManager.startUpdatingLocation()
                locManager.distanceFilter = 30
                break
            default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        //決められた間隔ごとに現在地を取得
        let lon = (locations.last?.coordinate.longitude)!
        let lat = (locations.last?.coordinate.latitude)!
        
        //それぞれ配列に追加していく
        lonArray.append(lon)
        latArray.append(lat)
        //配列の現在の個数をarrayNumberで表す（-1した数にする）
        let arrayNumber = lonArray.count - 1
        
        //確認用
        print(lon)
        print(lat)
        print(lonArray)
        print(arrayNumber)
        
        //現在の座標データをcoordinate1に、一個前の座標データをcoordinate2にする
        if arrayNumber > 1 {
            let coordinate1 = CLLocationCoordinate2D(latitude: lonArray[arrayNumber], longitude: latArray[arrayNumber])
            let coordinate2 = CLLocationCoordinate2D(latitude: lonArray[arrayNumber - 1], longitude: latArray[arrayNumber - 1])
            //polylineを引くcoordinatesを設定する。
            let coordinates = [coordinate1, coordinate2]
            let PolyLine: MKPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            DispatchQueue.main.async {
                self.mapView.addOverlay(PolyLine)
            }
            
            //ここに書く必要はない
            mapView.showsUserLocation = true
            
            mapView.userTrackingMode = .follow
            
        }
    }
    
   
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let polylineRenderer = MKPolylineRenderer(polyline: polyline)
            polylineRenderer.strokeColor = .blue
            polylineRenderer.lineWidth = 2.0
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    
    //let coordinate1 = CLLocationCoordinate2D(latitude: , longitude: -122.050333)
    
    
    
    
    
    
}

