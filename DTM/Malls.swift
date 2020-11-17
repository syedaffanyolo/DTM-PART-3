//
//  GrNoida.swift
//  DTM
//
//  Created by Syedaffan on 8/24/20.
//

import UIKit


//node.js api
let url = "https://dtmappapi.herokuapp.com/data"


class Malls: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    
    
    //all variables here
    var imageArr : [Data]? = []
    var imageArrForLc : [Data]? = []
    var titleArraygn : [String]? = []
    var titleArrayn : [String]? = []
    var titleArrayd : [String]? = []
    
    //table view outlet
    @IBOutlet weak var mallTableView: UITableView!
    
    
    //ui view on which the loader is placed
    @IBOutlet weak var loderView: UIView!
    // loader duh
    @IBOutlet weak var loder: UIActivityIndicatorView!
    //outlet for nav bar to change titles
    @IBOutlet weak var navBar: UINavigationItem!
    // scroll lenght changer so all button are hide and used when needed/ basically acesses the lenght feature /height of the view
    
    // prefered light or dark = dark
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting delgate and datasource for table view
        mallTableView.delegate = self
        mallTableView.dataSource = self
        // making seprator for cells clear colour
        self.mallTableView.separatorColor = .clear
        // starting loading
        loder.startAnimating()
        // blank title for nav
        navBar.title = ""
    }
    
    
    
    
    // main code table view
    
    // number of rows for each region i.e nummber of malls in each region are hardcoded here
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value : Int? = nil
        if ViewController.myGlobalVar.region == "Greater Noida"{
            value = 4
        }else if ViewController.myGlobalVar.region == "Noida"{
            value = 4
        }else if ViewController.myGlobalVar.region == "Delhi"{
            value = 8
        }
        return value!
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // custom cell for our table view
        let cell = mallTableView.dequeueReusableCell(withIdentifier: "mallcells", for: indexPath) as! MallCells
        // cusrtom cell styles
        DispatchQueue.main.async {
            
            cell.mallbutton.layer.cornerRadius = 10
            cell.mallbutton.titleLabel!.layer.shadowOffset = CGSize(width: 2.0, height: 2.0);
            cell.mallbutton.titleLabel!.layer.shadowRadius = 2.0;
            cell.mallbutton.titleLabel!.layer.shadowOpacity = 1.0;
            cell.mallbutton.titleLabel!.layer.masksToBounds = false;
            cell.mallbutton.layer.opacity = 0.9
            cell.mallbutton.tag = indexPath.row
            cell.mallbutton.addTarget(self, action: #selector(self.mallTapped(_:)), for: .touchUpInside)
            
        }
        
        //networking to get api data
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { [self]data, response, error in
            guard let data = data, error == nil else{
                print("somthin wrong")
                return
            }
            var result: grNoida?
            do {
                result = try JSONDecoder().decode(grNoida.self, from: data)
            } catch  {
                print(error)
            }
            
            guard let json = result else{
                
                return
            }
            
            
            /// intializing our gloabl variables to the retrivied data from the api
            
            
            //name of malls in gr noida
            importer.mallsingr = [json.gvname,json.mmname,json.apname,json.oaname]
            //name of malls in noida
            importer.mallsinn = [json.dmname,json.lcname,json.ggname,json.gpname]
            //name of malls in delhi
            importer.mallsind = [json.vsname,json.tcname,json.ccname,json.cmname,json.dsname,json.amname,json.pmname,json.scname]
            //images of malls in gr noida
            importer.mallsingrimg = [json.gvmallimage,json.mmmallimage,json.apmallimage,json.oamallimage]
            //images of malls in noida
            importer.mallsinnimg = [json.dmmallimage,json.lcmallimage,json.ggmallimage,json.gpmallimage]
            //images of malls in delhi
            importer.mallsindimg = [json.vsmallimage,json.tcmallimage,json.ccmallimage,json.cmmallimage,json.dsmallimage,json.ammallimage,json.pmmallimage,json.scmallimage]
            
            // floor images for logix city noida in url from retrived from api as string
            let lcfloorurl = [URL(string: json.lcfloorimages[0])!,URL(string: json.lcfloorimages[1])!,URL(string: json.lcfloorimages[2])!] // getting the hold of only one
            
            
            
            
            
            
            
            
            
            /// populating data on the cell's button!
            
            
            
            
            // checking selected region
            if ViewController.myGlobalVar.region == "Greater Noida"{
                for i in 0...3{
                    // taking global var of [string] and converting into url with indexpath as index of the array
                let imgurl = URL(string: importer.mallsingrimg![i])!
                    // converting the var to data
                    if let data = try? Data(contentsOf: imgurl ){
                        //appending all the data we get everytime this indexpath loop executes into an [data]
                        imageArr?.append(data)
                        // setting the array to gloabal level
                        importer.dataimg = imageArr
                    }
            }
                        //performing all ui on main thread
                        DispatchQueue.main.async {
                            //ensuring this line of code runs only once because there is no need to run thsi in loop everytime
                            if indexPath.row == 0 {
                                navBar.title = "Malls in Greater Noida"
                            }
                            // setting the title with the help of our global var initiloiazed previously, here we do it with thehelp of indexpath
                            if let futureCell = mallTableView.cellForRow(at: indexPath) as? MallCells {
                            futureCell.mallbutton.setTitle(importer.mallsingr![indexPath.row], for: .normal)
                            
                            // setting the backimagiee of button to the data we get evertime in the loop
                                futureCell.mallbutton.setBackgroundImage(UIImage(data: importer.dataimg![indexPath.row]), for: .normal)
                            }
                            //stoping the loader while ensuring the loop has ended
                            if indexPath.row == 3{
                                loderfu()
                            }
                        }
                    
                        
                        //setting all the needed data to global lvl to be used in other view
                        
                if indexPath.row == 0 {
                            
                            importer.gvname = json.gvname
                            importer.gvdis = json.gvdis
                            importer.gvfloors = json.gvfloors
                            
                            importer.msname = json.mmname
                            importer.msdis = json.mmdis
                            importer.msfloors = json.mmfloors
                            
                            importer.anname = json.apname
                            importer.andis = json.apdis
                            importer.anfloors = json.apfloors
                            
                            importer.oaname = json.oaname
                            importer.oadis = json.oadis
                            importer.omfloors = json.oafloors
                        }
 
            }else if ViewController.myGlobalVar.region == "Noida"{
                for i in 0...3{
                let imgurl = URL(string: importer.mallsinnimg![i])!
                if let data = try? Data(contentsOf: imgurl ){
                    
                    imageArr?.append(data)
                    importer.dataimg = imageArr
                }
                    DispatchQueue.main.async {
                        if indexPath.row == 0{
                            navBar.title = "Malls in Noida"
                        }
                        if let futureCell = mallTableView.cellForRow(at: indexPath) as? MallCells {
                        futureCell.mallbutton.setBackgroundImage(UIImage(data: importer.dataimg![indexPath.row]), for: .normal)
                        
                        
                        
                        futureCell.mallbutton.setTitle(importer.mallsinn![indexPath.row], for: .normal)
                        }
                        if indexPath.row == 3{
                            loderfu()
                        }
                    }
                    
                }
                if indexPath.row == 0{
                    importer.dmname = json.dmname
                    importer.dmdis = json.dmdis
                    importer.dmfloors = json.dmfloors
                    importer.lcname = json.lcname
                    importer.lcdis = json.lcdis
                    importer.lcfloors = json.lcfloors
                    importer.lcfloornames = json.lcfloornames // malls floornames
                    importer.lcshopnameslg = json.lcshopslg // shops in lower ground
                    importer.lcshopnamesg = json.lcshopg // shops in ground
                    importer.lcshopnames1 = json.lcshop1 // shops in 1st floor
                    importer.lcshopnames2 = json.lcshop2 // 2nd
                    importer.lcshopnames3 = json.lcshop3 // 3rd
                    importer.lcshopnames4 = json.lcshop4 // 4th
                    importer.phoneNumberslg = json.lcshopphonelg // getting all the phone numbers in lg floor into this array
                    
                    importer.ggname = json.ggname
                    importer.ggdis = json.ggdis
                    importer.ggfloors = json.ggfloors
                    importer.gpname = json.gpname
                    importer.gpdis = json.gpdis
                    importer.gpfloors = json.gpfloors
                    
                }
                
                
                
                importer.dataFloorLc = self.imageArrForLc // setting the value of our global [var] to our newly ready image array
                for i in 0...2{ // getting one by one data from the array we make below
                    if let imageData = try? Data(contentsOf: lcfloorurl[i]){
                        
                        self.imageArrForLc?.append(imageData) // appending the data to our image array we made in starting of the file
                        
                    }
                }
                
                
                
            }else if ViewController.myGlobalVar.region == "Delhi"{
                for i in 0...7{
                let imgurl = URL(string: importer.mallsindimg![i])!
                
                if let data = try? Data(contentsOf: imgurl ){
                    
                    imageArr?.append(data)
                    importer.dataimg = imageArr
                }
                    DispatchQueue.main.async {
                        if indexPath.row == 0{
                            navBar.title = "Malls in Delhi"
                        }
                        if let futureCell = mallTableView.cellForRow(at: indexPath) as? MallCells {
                        futureCell.mallbutton.setTitle(importer.mallsind![indexPath.row], for: .normal)
                        futureCell.mallbutton.setBackgroundImage(UIImage(data: importer.dataimg![indexPath.row]), for: .normal)
                        }
                        loderfu()
                    }
                    if indexPath.row == 0{
                        importer.vsname = json.vsname
                        importer.vsdis = json.vsdis
                        importer.vsfloors = json.vsfloors
                        
                        importer.tcname = json.tcname
                        importer.tcdis = json.tcdis
                        importer.tcfloors = json.tcfloors
                        
                        importer.ccname = json.ccname
                        importer.ccdis = json.ccdis
                        importer.ccfloors = json.ccfloors
                        
                        importer.cmname = json.cmname
                        importer.cmdis = json.cmdis
                        importer.cmfloors = json.cmfloors
                        
                        importer.dsname = json.dsname
                        importer.dsdis = json.dsdis
                        importer.dsfloors = json.dsfloors
                        
                        importer.amname = json.amname
                        importer.amdis = json.amdis
                        importer.amfloors = json.amfloors
                        
                        importer.pmname = json.pmname
                        importer.pmdis = json.pmdis
                        importer.pmfloors = json.pmfloors
                        
                        importer.scname = json.scname
                        importer.scdis = json.scdis
                        importer.scfloors = json.scfloors
                        
                        
                    }
                }
                
                
            }
            
        })
        // here is where we resume our networking i think maybe ignore this or maybe this the reason why we taking so much time to render SHOULD LOOK INTO THAT PROBLEM MAYBE THIS RELEVANT
        task.resume()
        
        return cell
    }
    @objc func mallTapped(_ sender: UIButton){ // ok so this function doesnt need explanation beause i dont know how to but this is hardcoded to get hold of button tapped in each and every indiviual cells in the table view with the help of sender tag-- this func is a target func targeted on line (110)
        
        let button = sender.tag
        
        Malls.importer.sender = button // setting sender.tag to our foorsender which is  global so can be used and initalized anywhere.
        performSegue(withIdentifier: "detail", sender: self)
        
    }
    // global variables for the detail view we have
    struct importer {
        static var mallsingrimg : [String]? = []
        static var mallsinnimg : [String]? = []
        static var mallsindimg : [String]? = []
        static var mallsingr : [String]? = []
        static var mallsinn : [String]? = []
        static var mallsind : [String]? = []
        // global sender.tag
        static var sender : Int? = nil
        // global floorsender.tag
        static var floorsender : Int? = nil
        // global zoomsender.tag
        static var zoomsender : Int? = nil
        //global callsender.tag
        static var callsender : Int? = nil
        //gr noida
        
        static var gvfloors : Int? = nil
        static var omfloors : Int? = nil
        static var anfloors : Int? = nil
        static var msfloors : Int? = nil
        static var gvname :String? = nil
        static var msname :String? = nil
        static var anname :String? = nil
        static var oaname :String? = nil
        static var gvdis : String? = nil
        static var msdis : String? = nil
        static var andis : String? = nil
        static var oadis : String? = nil
        
        
        //noida
        
        static var dataimg : [Data]? = nil
        static var dataFloorLc : [Data]? = nil // array contains all the floors in lc i.e. logix city noida
        static var phoneNumberslg : [Int]? = nil
        static var phoneNumbersg : [Int]? = nil
        static var phoneNumbers1 : [Int]? = nil
        static var lcfloors : Int? = nil
        static var ggfloors : Int? = nil
        static var gpfloors : Int? = nil
        static var dmfloors : Int? = nil
        static var dmname :String? = nil
        static var lcname :String? = nil
        static var ggname :String? = nil
        static var gpname :String? = nil
        static var dmdis : String? = nil
        static var lcdis : String? = nil
        static var ggdis : String? = nil
        static var gpdis : String? = nil
        
        static var lcfloornames : [String]? = nil
        static var lcshopnameslg : [String]? = nil
        static var lcshopnamesg : [String]? = nil
        static var lcshopnames1 : [String]? = nil
        static var lcshopnames2 : [String]? = nil
        static var lcshopnames3: [String]? = nil
        static var lcshopnames4 : [String]? = nil
        
        
        //delhi
        
        
        static var vsfloors : Int? = nil
        static var tcfloors : Int? = nil
        static var ccfloors : Int? = nil
        static var cmfloors : Int? = nil
        static var dsfloors : Int? = nil
        static var amfloors : Int? = nil
        static var pmfloors : Int? = nil
        static var scfloors : Int? = nil
        static var vsname :String? = nil
        static var tcname :String? = nil
        static var ccname :String? = nil
        static var cmname :String? = nil
        static var dsname :String? = nil
        static var amname :String? = nil
        static var pmname :String? = nil
        static var scname :String? = nil
        static var vsdis : String? = nil
        static var tcdis : String? = nil
        static var ccdis : String? = nil
        static var cmdis : String? = nil
        static var dsdis : String? = nil
        static var amdis : String? = nil
        static var pmdis : String? = nil
        static var scdis : String? = nil
        
        
    }
    // stoping loding activity function
    func loderfu(){
        self.loder.stopAnimating()
        self.loder.isHidden = true
        self.loder.isUserInteractionEnabled = false 
        self.loderView.isExclusiveTouch = false 
        self.loderView.isUserInteractionEnabled = false
    }
}

