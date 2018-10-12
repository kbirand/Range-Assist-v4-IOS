//
//  ViewController.swift
//  Range Assist
//
//  Created by Koray Birand on 06/11/15.
//  Copyright (c) 2015 Koray Birand. All rights reserved.
//

var settingsState : Bool = false {
didSet {
    print("SS:\(settingsState)")
}
}

extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
}


import UIKit
import CocoaAsyncSocket
import MapKit
import CoreLocation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


var cDist : MKPolyline?
var cHome : MKPolyline?

class CustomPointAnnotationRadarPlane: MKPointAnnotation {
    
    var imageName: String!
    var rotateAngle: Double!
    var flightID: String!
    
}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class CustomPointAnnotationCraft: MKPointAnnotation {
    var imageName: String!
}

class CustomPointAnnotationAirport: MKPointAnnotation {
    var imageName: String!
}

class CustomPolyline : MKPolyline {
    
    //var color: String?
}

class CustomPolylineRoute : MKPolyline {
    
    var color: String?
}

class CustomPolylinePlaneRoutes : MKPolyline {
    
    var color: String?
}

class CustomPolylineAirTrafficIst : MKPolyline {
    
}

class CustomCircle : MKCircle {
    
}

class koko : MKCircleRenderer {
    
    var aAAAA : String!
    
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        print(zoomScale)
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


var dView = ViewController()


class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, GCDAsyncSocketDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var gpsLat: UILabel!
    @IBOutlet weak var gpsLon: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var headingAngle: UILabel!
    @IBOutlet weak var amp: UILabel!
    @IBOutlet weak var volt: UILabel!
    @IBOutlet weak var mAh: UILabel!
    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var nowMahConsumption: UILabel!
    @IBOutlet weak var gpsSpeed: UILabel!
    @IBOutlet weak var altRelative: UILabel!
    @IBOutlet weak var varioMeter: UILabel!
    @IBOutlet weak var distHome: UILabel!
    @IBOutlet weak var remainingKm: UILabel!
    @IBOutlet weak var losAngle: UILabel!
    @IBOutlet weak var azmAngle: UILabel!
    @IBOutlet weak var kmPerMinute: UILabel!
    @IBOutlet weak var returnTime: UILabel!
    @IBOutlet var mV: UIView!
    @IBOutlet weak var main: UIView!
    @IBOutlet weak var settings: UIView!
    @IBOutlet weak var speedScrollView: UIScrollView!
    
    @IBOutlet weak var altScrollView: UIScrollView!
    
    @IBOutlet weak var serverIPLabel: UITextField!
    @IBOutlet weak var craftBatteryLabel: UITextField!
    @IBOutlet weak var myDistanceLabel: UITextField!
    
    
    @IBOutlet weak var verified: UIImageView!
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var speedLadder: UIImageView!
    
    @IBOutlet weak var altLadder: UIImageView!
    @IBOutlet weak var altRem: UILabel!
    
    
    
    var burstData = ""
    var colorCodes = [0xFFFFFF,0xF2F9FB,0xE5F4F7,0xD8EFF3,0xCBEAEF,0xBFE5EB,0xAAE4EC,0x95E4ED,0x80E3EE,0x6BE3EF,0x57E3F0,0x52D5F2,0x4EC8F4,0x49BAF6,0x45ADF8,0x41A0FA,0x4A8EF0,0x547CE7,0x5E6ADE,0x6858D5,0x7246CC,0x743CC3,0x7632BB,0x7828B3,0x7A1EAB,0x7D15A3,0x951898,0xAE1B8E,0xC71E84,0xE0217A,0xE31875,0xE61070,0xE9086B,0xED0067,0xF1004D,0xF60033,0xFA0019,0xFF0000,0xEB0000,0xD70101,0xC30202,0xB00303,0xA40202,0x980202,0x8C0202,0x800202,0x6C0101,0x590101,0x460000,0x330000]
    
    var homeGPSData = CLLocation(latitude: 0.0, longitude: 0.0)
    
    var bsocket: GCDAsyncSocket!
    var locationManager: CLLocationManager!
    
    var serverIP : String!
    var craftAnnotation : MKPointAnnotation!
    var latestLocation : CLLocation!
    var rangeCircle : MKCircle = MKCircle()
    var airportCircle : MKCircle = MKCircle()
    var polyLineHomeDist : MKPolyline!
    var releaseMapVar = false
    var meters : CLLocationDistance!
    
    
    var azimuthAngle : Double!
    var heading = 0.0
    var oldHeading = 0.0
    var updatedView = false
    var batteryCapacity = ""
    
    
    var hDist : CLLocationDistance!
    var mahCounter = 0.0
    var currentMah = 0.0
    
    var initLocation : Bool = false
    var latSet = 0.0
    var lonSet = 0.0
    let searchRadius: CLLocationDistance = 26000
    
    var cCode : Int = 0xffffff
    var cCodeHome : Int = 0xffffff
    
    var tempAnn : [MKAnnotation] = []
    var tempOver : [MKPolyline] = []
    
    var targerDistance = ""
    var x = 1
    
    //var settingsState : Bool = false
    var settingsWidth : CGFloat = 375.0
    
    var serverConnection : Bool = false
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
        }
        
        
        
        
        if annotation.isKind(of: CustomPointAnnotation.self) {
            
            anView!.image = UIImage(named: "base.png")
            //anView!.boundsRotation = 0
            
        } else if annotation.isKind(of: CustomPointAnnotationAirport.self) {
            
            anView!.image = UIImage(named: "airport.png")
            //anView!.boundsRotation = 0
            
        } else if annotation.isKind(of: CustomPointAnnotationCraft.self) {
            
            anView!.image = UIImage(named: "sprite.png")
            
        } else if annotation.isKind(of: CustomPointAnnotationRadarPlane.self){
            
            let cpa = annotation as! CustomPointAnnotationRadarPlane
            anView!.image = UIImage(named: cpa.imageName)
            anView!.canShowCallout = true
            
        } else if annotation.isKind(of: MKUserLocation.self)  {
            anView!.image = UIImage(named: "base.png")
        }
        
        return anView
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        overlay.isProxy()
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            
            
            
            if overlay.title! == "homeDistPoly" {
                polylineRenderer.strokeColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
                polylineRenderer.lineWidth = 1
            } else if overlay.title! == "mytrafficRoute" {
                polylineRenderer.strokeColor = UIColor(netHex: 0x000000)
                polylineRenderer.lineWidth = 1
                
            } else if overlay.title! == "planeRoutes" {
                polylineRenderer.strokeColor = UIColor(netHex: 0xffffff)
                polylineRenderer.lineWidth = 1
                
            } else if  overlay.title! == "craftRoute" {
                polylineRenderer.strokeColor = UIColor(netHex: 0xffffff)
                polylineRenderer.lineWidth = 1
            } else {
                
                polylineRenderer.strokeColor = UIColor(netHex: cCode)
                polylineRenderer.lineWidth = 2
            }
            
            return polylineRenderer
        }
        
        if overlay is MKCircle {
            let circleView = MKCircleRenderer(overlay: overlay)
            
            if overlay.title! == "grid" {
                circleView.strokeColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
                circleView.lineWidth = 1
            } else if overlay.title! == "rangecircle" {
                circleView.strokeColor = UIColor.red
                circleView.lineWidth = 1
            } else if overlay.title! == "airportGrid" {
                circleView.strokeColor = UIColor.white
                circleView.lineWidth = 1
                circleView.fillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
          
                
            }
            
            return circleView
            
        }
        
        return MKPolylineRenderer(overlay: overlay)
        
    }
    
    
    @objc func refreshSettings (_ notification: Notification) {
    
        print("Refresh Triggered")
        print(targerDistance)
        batteryCapacity = cc
        targerDistance = bb
        serverIP = aa
       createRangeGrid()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speedLadder.center.y = 0.0
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.refreshSettings(_:)), name:NSNotification.Name(rawValue: "refresh"), object: nil)
        
        amp.text = ""
        volt.text = ""
        mAh.text = ""
        remaining.text = ""
        nowMahConsumption.text = ""
        gpsSpeed.text = ""
        altRelative.text = ""
        varioMeter.text = ""
        losAngle.text = ""
        azmAngle.text = ""
        distHome.text = ""
        remainingKm.text = ""
        kmPerMinute.text = ""
        returnTime.text = ""
        gpsLat.text = ""
        gpsLon.text = ""
        
        //mapView.layer.cornerRadius = 20
        
        
        ////// Do any additional setup after loading the view, typically from a nib.
        
        
        
        bsocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let getImagePath = paths.appendingPathComponent("settings.ini")
        let checkValidation = FileManager.default
        
        if (checkValidation.fileExists(atPath: getImagePath))
        {
            var text2 = ""
            
            do {
                text2 = try NSString(contentsOfFile: getImagePath, encoding: String.Encoding.utf8.rawValue) as String
                var settings = text2.components(separatedBy: "\n")
                serverIP = settings[0] as String
                print("dView.serverIP")
                print(serverIP)
                batteryCapacity = settings[2] as String
                targerDistance = settings[1] as String
                
            }
            catch {}
            
            print(text2);
        }
        else
        {
            print("FILE NOT AVAILABLE");
        }
        
        print("ip")
        //print(serverIP)
        
        do {
            try self.bsocket!.connect(toHost: "192.168.150.1", onPort: 23)
            print("Connecting")
            status.text = "Connecting..."
        }
        catch {
            status.text = "Could not connect..."
            print("oops")
        }
        
        bsocket.readData(withTimeout: -1.0, tag: 0)
        
        
        
        self.mapView.delegate = self
        
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        if(locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))) {
            locationManager.requestAlwaysAuthorization()
            
        }
        
        
        
        craftAnnotation = CustomPointAnnotationCraft()
        mapView.addAnnotation(craftAnnotation)
        //mapView.showsUserLocation = true
        
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addAnnotation(_:)))
        uilgr.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(uilgr)
        
        
    }
    
    @IBAction func mahMinus(_ sender: AnyObject) {
        
        mahCounter = mahCounter - 10000
    }
    
    @IBAction func mahPlus(_ sender: AnyObject) {
        
        mahCounter = mahCounter + 10000
    }
    
    
    
    @IBAction func cancel(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: ({
            self.main.layer.cornerRadius = 0
            self.main.frame.origin.x -= self.settingsWidth
            settingsState = false
        }), completion: nil)
     
        
    }
    
    func addCornerRadius() {
        self.main.layer.cornerRadius = 20
    }
    
    func remCornerRadius() {
        self.main.layer.cornerRadius = 0
    }
    



    @IBAction func settings(_ sender: AnyObject) {
        
   
        
        if settingsState == false {
            
            print("false")
            mainV.displaySettings()
            addCornerRadius()
            settingsState = true
            
         } else {
            
            print("true")
            mainV.hideSettings()
            remCornerRadius()
            settingsState = false
        }
        
        
        
//        if settingsState == false {
//            print("false")
//            UIView.animateWithDuration(0.1, animations: { () -> Void in
//                
//                self.main.layer.cornerRadius = 20
//                self.main.frame.origin.x += self.settingsWidth
//                //self.main.frame.size.width = self.main.frame.width - self.settingsWidth
//                
//                self.serverIPLabel.text = self.serverIP
//                self.craftBatteryLabel.text = self.batteryCapacity
//                self.myDistanceLabel.text = self.targerDistance
//                self.settingsState = true
//                print(self.main.frame.size.width )
//            })
//        } else {
//            print("true")
//            UIView.animateWithDuration(0.1, animations: { () -> Void in
//                self.main.layer.cornerRadius = 0
//                self.main.frame.origin.x -= self.settingsWidth
//                //self.main.frame.size.width = self.main.frame.width + self.settingsWidth
//                self.settingsState = false
//                 print(self.main.frame.size.width )
//            })
//        }
    }
    
    @IBAction func copyGpsData(_ sender: AnyObject) {
        
        let a = gpsLat.text
        let b = gpsLon.text
        
        let mydat = "\(a!),\(b!)"
        
        UIPasteboard.general.string = mydat
        
    }
    
    
    @objc func addAnnotation(_ gestureRecognizer:UIGestureRecognizer){
        
        if tempAnn.count != 0 {
            self.mapView.removeAnnotations(tempAnn)
            tempAnn = []
        }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = CustomPointAnnotation()
        annotation.coordinate = newCoordinates
        let newHome = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
        homeGPSData = newHome
        createRangeGrid()
        
        tempAnn.append(annotation)
        mapView.addAnnotation(annotation)
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func socket(_ socket : GCDAsyncSocket, didReadData data:Data, withTag tag:UInt16)
//    {
//        
//        let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//        //println(response)
//        if response != nil {
//            let  tempData = response as! String
//            
//            
//            let kb = mergeData(tempData, start: "$", end: "\r\n")
//            
//            if kb.characters.count == 134 {
//                //print(kb)
//                let parsedData = kb.components(separatedBy: ",")
//                drawData(parsedData as NSArray)
//            }
//        }
//        let seperatorString = "$"
//        let seperatorData = seperatorString.data(using: String.Encoding.utf8)
//        bsocket.readData(to: seperatorData, withTimeout: -1, tag: 0)
//        //bsocket.readDataWithTimeout(-1.0, tag: 0)
//        
//        
//    }
//    
    
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if response != nil {
            let  tempData = response! as String
            let truncated = koray.leftString(tempData, charToGet: 133)
            if truncated.count == 133 {
                let parsedData = truncated.components(separatedBy: ",")
                print(parsedData.count)
                drawData(parsedData as NSArray)
                
            }
            
        }
        
        let seperatorString = "$"
        let seperatorData = seperatorString.data(using: String.Encoding.utf8)
        bsocket.readData(to: seperatorData!, withTimeout: -1, tag: 0)
        
    }
    
    
    func drawData (_ parsedData: NSArray) {
        //return
        print(homeGPSData.coordinate.latitude)
        if homeGPSData.coordinate.latitude != 0.0 {
            if craftAnnotation == nil {
                craftAnnotation = CustomPointAnnotationCraft()
                mapView.addAnnotation(craftAnnotation)
            }
            
            if parsedData.count == 28 {
                if parsedData[0] as! String == "1" {
                    
                    self.verified.image = UIImage(named: "green.png")
                    var mergeLatData : Double!
                    var mergeLonData : Double!
                    
                    if parsedData[4] as! String == "N" {
                        mergeLatData = (parsedData[3] as AnyObject).doubleValue
                    } else {
                        mergeLatData = -((parsedData[3] as AnyObject).doubleValue)
                    }
                    
                    print(mergeLatData)
                    if parsedData[6] as! String == "E" {
                        mergeLonData = (parsedData[5] as AnyObject).doubleValue
                    } else {
                        mergeLonData = -((parsedData[5] as AnyObject).doubleValue)
                    }
                    
                    
                    
                    let a = mergeLatData
                    let b = mergeLonData
                    
                    gpsLat.text = (String(format: "%.6f", a!))
                    gpsLon.text = (String(format: "%.6f", b!))
                    
                    meters = 0
                    
                    //let initialLocation = CLLocation(latitude: a, longitude: b)
                    
                    if releaseMapVar == false {
                        //centerMapSprite(initialLocation)
                    }
                    
                    let newLocation = CLLocation(latitude: a!, longitude: b!)
                    
                    if latestLocation != nil {
                        
                        meters = latestLocation.distance(from: newLocation)
                        
                        azimuthAngle = 180 + getBearingBetweenTwoPoints(latestLocation, point2: homeGPSData)
                        azmAngle.text = String(format: "%.0f", azimuthAngle) + "°"
                        //print(azimuthAngle)
                        
                        heading = (parsedData[14] as AnyObject).doubleValue
                        headingAngle.text = String(format: "%.0f", heading)
                        craftAnnotation.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
                        
                        if mapView.view(for: craftAnnotation) != nil {
                            self.mapView.view(for: craftAnnotation)?.transform = self.mapView.transform.rotated(by: CGFloat(degreesToRadians(heading)))
                            
                        }
                        
                        
                        
                        if x == 50 {
                            if polyLineHomeDist != nil {
                                self.mapView.removeOverlay(polyLineHomeDist)
                            }
                            
                            var polyArrayHome : [CLLocationCoordinate2D] = [homeGPSData.coordinate, newLocation.coordinate]
                            polyLineHomeDist =  CustomPolyline(coordinates: &polyArrayHome, count: 2)
                            polyLineHomeDist.title = "homeDistPoly"
                            mapView.addOverlay(polyLineHomeDist)
                            x = 0
                        }
                        x = x + 1
                        
                        
                    } else {
                        meters = 0
                        
                    }
                    
                    hDist = (newLocation.distance(from: homeGPSData)) / 1000
                    let homeDist = String(format: "%.1f", hDist)
                    let homeDistance = (newLocation.distance(from: homeGPSData))
                    distHome.text =  "\(homeDist)"
                    
                    
                    latestLocation = newLocation
                    
                    let voltCalc : Float = (parsedData[19] as AnyObject).floatValue / 100
                    
                    let ampCalc : Float = (parsedData[21] as AnyObject).floatValue / 100
                    
                    
                    
                    let gpsSpeedVar = (parsedData[12] as AnyObject).floatValue
                    
                    let altRel = (parsedData[7] as AnyObject).doubleValue
                    var checkMah = (parsedData[22] as AnyObject).doubleValue + mahCounter
                    let vario = (parsedData[13] as AnyObject).doubleValue
                    
                    if checkMah == 0 {
                        
                        checkMah = checkMah + mahCounter
                        mahCounter = mahCounter + 10000
                    }
                    currentMah = checkMah
                    
                    
                    ////Calculate Current Mah Consumption Avarage
                    let ampVar = ampCalc
                    let distanceVar : Float = 1.0
                    let speedvar = gpsSpeedVar
                    let remainingTime : Float = (distanceVar * 60) / speedvar!
                    let currentMahConsumption = (((remainingTime * ampVar) / 60) * 1000)
                    
                    var remKM : Double = 0.0
                    if batteryCapacity != "" {
                        remaining.text = String(format: "%.0f", Double(batteryCapacity)! - Double(currentMah))
                        remKM = (Double(batteryCapacity)! - checkMah) / Double(currentMahConsumption)
                        
                    }
                    
                    
                    /////Calculate LOS Angle
                    let los = radiansToDegrees(atan(altRel! / homeDistance))
                    
                    /////Calculate Ideal Alt
                    
                    //let alt = tan(degreesToRadians(4.0)) * homeDistance
                    
                    remainingKm.text = String(format: "%.2f", remKM)
                    
                    if  currentMahConsumption < 150 {
                        nowMahConsumption.textColor = UIColor(netHex: 0x098004)
                        nowMahConsumption.text = String(format: "%.0f", currentMahConsumption)
                    } else if currentMahConsumption > 150 && currentMahConsumption < 200 {
                        nowMahConsumption.textColor = UIColor.blue
                        nowMahConsumption.text = String(format: "%.0f", currentMahConsumption)
                    } else if currentMahConsumption > 200 {
                        
                        nowMahConsumption.textColor = UIColor.white
                        nowMahConsumption.text = String(format: "%.0f", currentMahConsumption)
                    }
                    //print(speedLadder.center.y)
                    
                    let myCenter =  Float((1200 -  speedScrollView.bounds.height) / 2)
                    let myCenterTwo =  Float((10000 -  altScrollView.bounds.height) / 2)
                    
                    
                    speedLadder.center.y = CGFloat( -myCenter + Float(gpsSpeedVar!*4))
                    speedLadder.center.x = 21
                    altLadder.center.y = CGFloat (-myCenterTwo + Float(altRel!*2))
                    altLadder.center.x = 25
                    
                    
                    
                    mAh.text = String(format: "%.0f", checkMah)
                    amp.text = String(format: "%.2f", ampCalc)
                    volt.text = String(format: "%.2f", voltCalc)
                    gpsSpeed.text = String(format: "%.0f", gpsSpeedVar!)
                    altRelative.text = String(format: "%.0f", altRel!)
                    if los != 0 {
                        losAngle.text = String(format: "%.0f", los) + "°"
                    }
                    //if azimuthAngle != 0 {
                    //azmAngle.text = String(format: "%.0f", azimuthAngle).stringByAppendingString("°")
                    //}
                    
                    let rTime = Double(homeDist)! / (Double(gpsSpeedVar!) / 60)
                    returnTime.text = String(format: "%.0f", rTime) + "'"
                    kmPerMinute.text = String(format: "%.1f", gpsSpeedVar! / 60)
                    
                    let newVario = (vario! * 0.1) * 60 // meterspermin
                    varioMeter.text = String(format: "%.0f", newVario * 0.1 * 60)
                    
                    let altRemain = Float(newVario * 0.1 * 60) * Float(remainingTime)
                    if altRemain > 0 {
                    altRem.text = String(format: "%.0f", altRemain)
                    } else {
                     altRem.text = String(format: "%.0f", 0)
                    }
                    
                    
                    
                } else {
                    self.verified.image = UIImage(named: "red.png")
                }
                
                
                
                
            }
        }
    }
    
    
    
    
    
    func centerMapSprite(_ location: CLLocation) {
        
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
    }
    
    
    
    func createRangeGrid() {
        self.mapView.removeOverlays(mapView.overlays)
        if targerDistance != "" {
            
            if Double(targerDistance) < 5000 {
                
                for index in 1...5 {
                    rangeCircle = CustomCircle(center: homeGPSData.coordinate, radius: Double(index * 1000))
                    rangeCircle.title = "grid"
                    mapView.addOverlay(rangeCircle, level: MKOverlayLevel.aboveRoads)
                    
                }
                
            } else {
                
                let circleCount = ((Double(targerDistance)! / 5000).description).count
                let circleCountVar = Int(Double(targerDistance)! / 5000)
                var remainder : Bool!
                
                if circleCount > 1 {
                    remainder = true
                } else {
                    remainder = false
                }
                
                if remainder == true {
                    
                    for index in 1...circleCountVar {
                        self.rangeCircle = CustomCircle(center: homeGPSData.coordinate, radius: Double(index * 5000))
                        self.rangeCircle.title = "grid"
                        mapView.addOverlay(rangeCircle, level: MKOverlayLevel.aboveRoads)
                        
                    }
                    rangeCircle = CustomCircle(center: homeGPSData.coordinate, radius: Double(targerDistance)!)
                    rangeCircle.title = "rangecircle"
                    mapView.addOverlay(rangeCircle, level: MKOverlayLevel.aboveRoads)
                    
                    
                } else {
                    
                    for index in 1...(circleCountVar-1) {
                        self.rangeCircle = CustomCircle(center: homeGPSData.coordinate, radius: Double(index * 5000))
                        self.rangeCircle.title = "grid"
                        mapView.addOverlay(rangeCircle, level: MKOverlayLevel.aboveRoads)
                        
                    }
                    rangeCircle = CustomCircle(center: homeGPSData.coordinate, radius: Double(targerDistance)!)
                    rangeCircle.title = "rangecircle"
                    mapView.addOverlay(rangeCircle, level: MKOverlayLevel.aboveRoads)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        let lat = mapView.userLocation.coordinate.latitude
        let lon = mapView.userLocation.coordinate.longitude
        
        let initialLocation = CLLocation(latitude: lat, longitude: lon)
        
        if lat != 0.0 {
            if updatedView == false {
                homeGPSData = initialLocation
                self.mapView.removeOverlays(mapView.overlays)
                createRangeGrid()
                centerMapOnLocation(initialLocation)
                updatedView = true
            }
        }
        
        
        
        
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        
        
        if location.coordinate.longitude != 0.0 {
            
            let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: searchRadius * 0.1, longitudinalMeters: searchRadius * 0.1)
            mapView.setRegion(coordinateRegion, animated: false)
            
        }
        
    }
    
    
    
    

    
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            //self.mapView.sho
            
        }
    }
    
    func socket(_ socket : GCDAsyncSocket, didConnectToHost host:String, port p:UInt16)
    {
        print("Connected to \(host) on port \(p).")
        serverConnection = true
        bsocket.readData(withTimeout: -1.0, tag: 0)
    }
    
    
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("Disconnected")
        serverConnection = false
    }
    
    func socketDidCloseReadStream(_ sock: GCDAsyncSocket) {
        print("socket did close read stream")
    }
    
    @IBAction func reConnect(_ sender: AnyObject) {
    
        if serverConnection == false {
            
            do {
                try self.bsocket!.connect(toHost: serverIP, onPort: 23)
                print("Connecting")
                status.text = "Connecting..."
            }
            catch {
                status.text = "Could not connect..."
                print("oops")
            }
            
            bsocket.readData(withTimeout: -1.0, tag: 0)
        } else {
            print("Connected")
        }
        
    }
    
  
    
    func getBearingBetweenTwoPoints(_ point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(point2.coordinate.latitude);
        let lon2 = degreesToRadians(point2.coordinate.longitude);
        
        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        
        return radiansToDegrees(radiansBearing)
    }
    
    func degreesToRadians(_ degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / .pi }
    
    
    func colorAltitude(_ altitude:Double) {
        
        if altitude < 40 {
            cCode = colorCodes[0]
        } else if altitude >= 40 && altitude < 80 {
            cCode = colorCodes[1]
        } else if altitude >= 80 && altitude < 120 {
            cCode = colorCodes[2]
        } else if altitude >= 120 && altitude < 160 {
            cCode = colorCodes[3]
        } else if altitude >= 160 && altitude < 200 {
            cCode = colorCodes[4]
        } else if altitude >= 200 && altitude < 240 {
            cCode = colorCodes[5]
        } else if altitude >= 240 && altitude < 280 {
            cCode = colorCodes[6]
        } else if altitude >= 280 && altitude < 320 {
            cCode = colorCodes[7]
        } else if altitude >= 320 && altitude < 360 {
            cCode = colorCodes[8]
        } else if altitude >= 360 && altitude < 400 {
            cCode = colorCodes[9]
        } else if altitude >= 400 && altitude < 440 {
            cCode = colorCodes[10]
        } else if altitude >= 440 && altitude < 480 {
            cCode = colorCodes[11]
        } else if altitude >= 480 && altitude < 520 {
            cCode = colorCodes[12]
        } else if altitude >= 520 && altitude < 560 {
            cCode = colorCodes[13]
        } else if altitude >= 560 && altitude < 600 {
            cCode = colorCodes[14]
        } else if altitude >= 600 && altitude < 640 {
            cCode = colorCodes[15]
        } else if altitude >= 640 && altitude < 680 {
            cCode = colorCodes[16]
        } else if altitude >= 680 && altitude < 720 {
            cCode = colorCodes[17]
        } else if altitude >= 720 && altitude < 760 {
            cCode = colorCodes[18]
        } else if altitude >= 760 && altitude < 800 {
            cCode = colorCodes[19]
        } else if altitude >= 800 && altitude < 840 {
            cCode = colorCodes[20]
        } else if altitude >= 840 && altitude < 880 {
            cCode = colorCodes[21]
        } else if altitude >= 880 && altitude < 920 {
            cCode = colorCodes[22]
        } else if altitude >= 920 && altitude < 960 {
            cCode = colorCodes[23]
        } else if altitude >= 960 && altitude < 1000 {
            cCode = colorCodes[24]
        } else if altitude >= 1000 && altitude < 1040 {
            cCode = colorCodes[25]
        } else if altitude >= 1040 && altitude < 1080 {
            cCode = colorCodes[26]
        } else if altitude >= 1080 && altitude < 1120 {
            cCode = colorCodes[27]
        } else if altitude >= 1120 && altitude < 1160 {
            cCode = colorCodes[28]
        } else if altitude >= 1160 && altitude < 1200 {
            cCode = colorCodes[29]
        } else if altitude >= 1200 && altitude < 1240 {
            cCode = colorCodes[30]
        } else if altitude >= 1240 && altitude < 1280 {
            cCode = colorCodes[31]
        } else if altitude >= 1280 && altitude < 1320 {
            cCode = colorCodes[32]
        } else if altitude >= 1320 && altitude < 1360 {
            cCode = colorCodes[33]
        } else if altitude >= 1360 && altitude < 1400 {
            cCode = colorCodes[34]
        } else if altitude >= 1400 && altitude < 1440 {
            cCode = colorCodes[35]
        } else if altitude >= 1440 && altitude < 1480 {
            cCode = colorCodes[36]
        } else if altitude >= 1480 && altitude < 1520 {
            cCode = colorCodes[37]
        } else if altitude >= 1520 && altitude < 1560 {
            cCode = colorCodes[38]
        } else if altitude >= 1560 && altitude < 1600 {
            cCode = colorCodes[39]
        } else if altitude >= 1600 && altitude < 1640 {
            cCode = colorCodes[40]
        } else if altitude >= 1640 && altitude < 1680 {
            cCode = colorCodes[41]
        } else if altitude >= 1680 && altitude < 1720 {
            cCode = colorCodes[42]
        } else if altitude >= 1720 && altitude < 1760 {
            cCode = colorCodes[43]
        } else if altitude >= 1760 && altitude < 1800 {
            cCode = colorCodes[44]
        } else if altitude >= 1800 && altitude < 1840 {
            cCode = colorCodes[45]
        } else if altitude >= 1840 && altitude < 1880 {
            cCode = colorCodes[46]
        } else if altitude >= 1880 && altitude < 1920 {
            cCode = colorCodes[47]
        } else if altitude >= 1920 && altitude < 1960 {
            cCode = colorCodes[48]
        } else if altitude >= 1960 && altitude < 2000 {
            cCode = colorCodes[49]
        }
        
        
    }
    
    
    
}

