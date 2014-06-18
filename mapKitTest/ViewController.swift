//
//  ViewController.swift
//  mapKitTest
//
//  Created by Fumitoshi Ogata on 2014/06/18.
//  Copyright (c) 2014年 Fumitoshi Ogata. All rights reserved.
//

import UIKit
import MapKit

// 地図ビューを管理するためのコントローラ
class ViewController: UIViewController, MKMapViewDelegate {
    
    // 地図ビュー
    @IBOutlet var mapView : MKMapView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初期位置を設定
        //経度、緯度からメルカトル図法の点に変換する
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.665213,139.730011)
        let span = MKCoordinateSpanMake(0.003, 0.003) //小さい値であるほど近づく
        //任意の場所を表示する場合、MKCoordinateRegionを使って表示する -> (中心位置、表示領域)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        mapView.setRegion(centerPosition,animated:true)
        
        //出発点：六本木　〜　目的地：渋谷
        //経度、緯度からメルカトル図法の点に変換する
        var fromCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.665213, 139.730011)
        var toCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.658987, 139.702776)
        
        //CLLocationCoordinate2DからMKPlacemarkを作成する 
        var fromPlacemark = MKPlacemark(coordinate:fromCoordinate, addressDictionary:nil)
        var toPlacemark = MKPlacemark(coordinate:toCoordinate, addressDictionary:nil)
        
        //MKPlacemarkからMKMapItemを生成します。
        var fromItem = MKMapItem(placemark:fromPlacemark);
        var toItem = MKMapItem(placemark:toPlacemark);
        
        //MKMapItem をセットして MKDirectionsRequest を生成します
        let request = MKDirectionsRequest()
        request.setSource(fromItem)
        request.setDestination(toItem)
        request.requestsAlternateRoutes = true; //複数経路
        request.transportType = MKDirectionsTransportType.Walking //移動手段 Walking:徒歩/Automobile:車

        //経路を検索する(非同期で実行される)
        let directions = MKDirections(request:request)
        directions.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse!, error:NSError!) -> Void in
            if (error? || response.routes.isEmpty) {
                return
            }
            let route: MKRoute = response.routes[0] as MKRoute
            self.mapView.addOverlay(route.polyline!)
            })
        
        
        //アノテーションというピンを地図に刺すことができる
        //出発点：六本木　〜　目的地：渋谷　の２点に刺す
        var theRoppongiAnnotation = MKPointAnnotation()
        theRoppongiAnnotation.coordinate  = fromCoordinate
        theRoppongiAnnotation.title       = "Roppoingi"
        theRoppongiAnnotation.subtitle    = "xxxxxxxxxxxxxxxxxx"
        self.mapView.addAnnotation(theRoppongiAnnotation)
        
        var theShibuyaAnnotation = MKPointAnnotation()
        theShibuyaAnnotation.coordinate  = toCoordinate
        theShibuyaAnnotation.title       = "Shibuya"
        theShibuyaAnnotation.subtitle    = "xxxxxxxxxxxxxxxxxx"
        self.mapView.addAnnotation(theShibuyaAnnotation)
        
        //カメラの設定をしてみる（少し手前に傾けた状態）
        var camera:MKMapCamera = self.mapView.camera;
        //camera.altitude += 100
        //camera.heading += 15
        camera.pitch += 60
        self.mapView.setCamera(camera, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 経路検索のルート表示設定
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let route: MKPolyline = overlay as MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.redColor()
        return routeRenderer
    }
}
