//
//  DetailView.swift
//  DTM
//
//  Created by Syedaffan on 10/25/20.
//
import UIKit
import MapKit


class DetailView: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    
    // all outlets
    
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var navigation: UIButton!
    @IBOutlet weak var dislabel: UILabel!
    @IBOutlet weak var mallimage: UIImageView!
    @IBOutlet weak var zoomImage: UIImageView!
    @IBOutlet var zoomView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    
    
    var shopnumbercell : Int? = nil // cell amount variable to be used later
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting delgate and data source for our table view
        detailTable.delegate = self
        detailTable.dataSource = self
        //rendering all the detail for the selcted mall while the detail seque starts at first
        
        blurView.bounds = self.view.bounds
        zoomView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.8)
        zoomView.layer.cornerRadius = 5
    }
    // navigation/map action
    @IBAction func navigationButton(_ sender: Any) {
        //giving address to the mapkit to the value of the current value of dislabel
        coordinates(forAddress: dislabel.text!) {
            (location) in
            guard let location = location else {
                // Handle error here.
                return
            }
            //opening the directions for that location
            self.openMapForPlace(lat: location.latitude, long: location.longitude)
        }
        
    }
    
    
    @IBAction func cancelZoomClicked(_ sender: Any) {
        
        animateScaleOut(desiredView: zoomView)
        animateScaleOut(desiredView: blurView)
        
    }
    
    
    // big boss 2 lies here
    
    //table view stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3 // testing number for logix city data
        //shopnumbercell! // amount of cells to be presented  = floors in mall
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTable.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! floorCell // custom cell
        
        //setting nav bar title to empty
        navBar.title = ""
        //checking selected region
        // like here we check foro grnoida and we know we got 4 malls , since we are having reusable buttons we cant assign them all in one so we have to check what region we are in and then populating the data of the mall we selcted from that region
        
        if ViewController.myGlobalVar.region == "Greater Noida"{
            // the switch statement here is an integer it is the sender.tag global variable
            switch Malls.importer.sender {
            //if the sender.tag was 0..3 do this
            case 0:// on zero tag we know its grand venice hence we do the following stuff
                //setting nav title
                navBar.title = Malls.importer.gvname //setting navbar title to the mall name
                dislabel.text = Malls.importer.gvdis //setting address to mall address
                mallimage.image = UIImage(data: Malls.importer.dataimg![0])//gr venice data holidng image
                shopnumbercell = Malls.importer.gvfloors // setting floors for this mall in a variable so that it could be used in cell amount proptional to floors
            case 1:
                navBar.title = Malls.importer.msname
                dislabel.text = Malls.importer.msdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![1])
                shopnumbercell = Malls.importer.msfloors
            case 2:
                navBar.title = Malls.importer.anname
                dislabel.text = Malls.importer.andis
                mallimage.image = UIImage(data: Malls.importer.dataimg![2])
                shopnumbercell = Malls.importer.anfloors
            case 3:
                navBar.title = Malls.importer.oaname
                dislabel.text = Malls.importer.oadis
                mallimage.image = UIImage(data: Malls.importer.dataimg![3])
                shopnumbercell = Malls.importer.omfloors
                
            default:
                return UITableViewCell()
            }
            
        }else if ViewController.myGlobalVar.region == "Noida"{
            
            switch Malls.importer.sender {
            case 0:
                navBar.title = Malls.importer.dmname
                dislabel.text = Malls.importer.dmdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![0])
                shopnumbercell = Malls.importer.dmfloors
            case 1:
                let images = UIImage(data: Malls.importer.dataFloorLc![indexPath.row]) // setting a var for our cell to contain picture for each row of cell
                cell.floorButton.setBackgroundImage(images, for: .normal) // setting image from that var to each cell's button in each row
                cell.floorName.text =  Malls.importer.lcfloornames![indexPath.row]// setting floornames label from global [var] to each cell of wach row
                cell.shopButton.tag = indexPath.row // setting the shopbutton tag to indexpath.row which sets 3 int means 0...2
                cell.shopButton.addTarget(self, action: #selector(shopstapped(_:)), for: .touchUpInside) // adding custom rtarget function refer to the func below
                
                cell.floorbuttonzoom.tag = indexPath.row // setting floorbutton's tag to indexpath.row which sets 3 int means 0...2
                cell.floorbuttonzoom.addTarget(self, action: #selector(zoomTapped(_:)), for: .touchUpInside)// adding functionality i.e ibaaction to this button refer to line ()
                navBar.title = Malls.importer.lcname
                dislabel.text = Malls.importer.lcdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![1])
                shopnumbercell = Malls.importer.lcfloors
            case 2:
                navBar.title = Malls.importer.ggname
                dislabel.text = Malls.importer.ggdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![2])
                shopnumbercell = Malls.importer.ggfloors
            case 3:
                navBar.title = Malls.importer.gpname
                dislabel.text = Malls.importer.gpdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![3])
                shopnumbercell = Malls.importer.gpfloors
                
            default:
                return UITableViewCell()
            }
        }else if ViewController.myGlobalVar.region == "Delhi"{
            
            switch Malls.importer.sender {
            case 0:
                navBar.title = Malls.importer.vsname
                dislabel.text = Malls.importer.vsdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![0])
                shopnumbercell = Malls.importer.vsfloors
            case 1:
                navBar.title = Malls.importer.tcname
                dislabel.text = Malls.importer.tcdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![1])
                shopnumbercell = Malls.importer.tcfloors
            case 2:
                navBar.title = Malls.importer.ccname
                dislabel.text = Malls.importer.ccdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![2])
                shopnumbercell = Malls.importer.ccfloors
            case 3:
                navBar.title = Malls.importer.cmname
                dislabel.text = Malls.importer.cmdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![3])
                shopnumbercell = Malls.importer.cmfloors
            case 4:
                navBar.title = Malls.importer.dsname
                dislabel.text = Malls.importer.dsdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![4])
                shopnumbercell = Malls.importer.dsfloors
            case 5:
                navBar.title = Malls.importer.amname
                dislabel.text = Malls.importer.amdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![5])
                shopnumbercell = Malls.importer.amfloors
            case 6:
                navBar.title = Malls.importer.pmname
                dislabel.text = Malls.importer.pmdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![6])
                shopnumbercell = Malls.importer.pmfloors
            case 7:
                navBar.title = Malls.importer.scname
                dislabel.text = Malls.importer.scdis
                mallimage.image = UIImage(data: Malls.importer.dataimg![7])
                shopnumbercell = Malls.importer.scfloors
                
            default:
                return UITableViewCell()
            }
            
        }
        
        
        
        
        return cell
        
        
    }
    // function to turn string type address to a geolocation for directions in map
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    //func to open map app with the selected location , mapkit takes coordinated not as string address but as lat and lon so we convert our adress to geolocation previosly and later when we mention this function we put them in place of lat and lon rather than giving a line of address(its how mapkit knows where is the loaction)
    public func openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        
        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }
    @objc func shopstapped(_ sender: UIButton){ // ok so this function doesnt need explanation beause i dont know how to but this is hardcoded to get hold of button tapped in each and every indiviual cells in the table view with the help of sender tag-- this func is a target func targeted on line (110)
        
        let button = sender.tag
        
        Malls.importer.floorsender = button // setting sender.tag to our foorsender which is  global so can be used and initalized anywhere.
        
        
    }
    //functionality i.e. ibaaction for our floorbutton when its tapped refer to line()
    @objc func zoomTapped(_ sender: UIButton){
        let zoomButton = sender.tag // this is equal to the tag of the button tapped whoch would be numbers from indexpath.row
        
        Malls.importer.zoomsender = zoomButton // setting that tag to global level
        animateScaleIn(desiredView: blurView) // animating our zoom view for blur first
        animateScaleIn(desiredView: zoomView) // animitaing the actual view now
        
    }
    
    
    ///animation functions
    
    /// Animates a view to scale in and display
    func animateScaleIn(desiredView: UIView) {
        var i = Malls.importer.zoomsender // checking which floor wwas clicked by the help of thsi global sender
        zoomImage.image = UIImage(data: Malls.importer.dataFloorLc![i!]) // tapping inot the image array and setting the image of the zoomed in view image
        
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        desiredView.center = backgroundView.center
        desiredView.isHidden = false
        
        desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        desiredView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
            //            desiredView.transform = CGAffineTransform.identity
        }
    }
    
    /// Animates a view to scale out remove from the display
    func animateScaleOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 0
        }, completion: { (success: Bool) in
            desiredView.removeFromSuperview()
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
        }, completion: { _ in
            
        })
    }
    
}
