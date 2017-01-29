//
//  RKGCountryMoreInfoViewController.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 4/11/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import UIKit

class RKGCountryMoreInfoViewController: UIViewController {

    fileprivate var country: CountryGeonames!
    
    func setCountry(_ country: CountryGeonames) {
        self.country = country
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
