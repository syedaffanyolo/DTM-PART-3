//
//  ViewController.swift
//  DTM
//
//  Created by Syedaffan on 8/24/20.
//

import UIKit

// assiging the delegate for our uipicker view
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
  
    
    
    // all outlets
    @IBOutlet weak var locPick: UIPickerView!
    @IBOutlet weak var nextb: UIButton!
    
    // making a variible of array to contain the regions oin out loc picker
    var locationPicker:[String] = [String]();
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // rendering all the stuff for our location picker view
        render()
        
        
        
      
        // setting data source anf delgate
        self.locPick.delegate = self
        self.locPick.dataSource = self
        //picker view init
        locationPicker = ["Greater Noida","Noida","Delhi"]
        
        
        
        
        
    }
    
    @IBAction func next(_ sender: Any) {
        // gets in a variable what region is being selceted currently by the user
        let selectedReg = locationPicker[locPick.selectedRow(inComponent: 0)]
        
        
        // having a no shadow when clicked for our button
        nextb.layer.shadowOpacity = 0.0;
        // setting the selected region by the user to the global variable region
        myGlobalVar.region = selectedReg
        
        // performing a segue whrn the next button is clicked
        performSegue(withIdentifier: "Malls", sender: self)
        
        
        
        
    }
    
    //functions
    // setting number of collumbs
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // setting the number og rows to the value of stuff in our array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationPicker.count
    }
    // setting each row to the stuff in our array by one by one
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationPicker[row]
    }
    
    func render(){
        

        
        // all elemnet styles
        
        nextb.layer.cornerRadius = 10
        locPick.layer.cornerRadius = 20
        nextb.layer.shadowOffset = CGSize(width: 2.0, height: 2.0);
        nextb.layer.shadowRadius = 2.0;
        nextb.layer.shadowOpacity = 1.0;
        nextb.layer.masksToBounds = false;
        locPick.layer.shadowOffset = CGSize(width: 2.0, height: 2.0);
        locPick.layer.shadowRadius = 2.0;
        locPick.layer.shadowOpacity = 1.0;
        locPick.layer.masksToBounds = false;
    }
    
    
    
    
    // global variable for region
    
    struct myGlobalVar {
        static var region = String()
       
    }
  
            
        }
  
    
    
    
    
    
    
    
    



