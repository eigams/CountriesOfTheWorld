//
//  RKGCountryMoreInfoViewController.swift
//  RKGeonames
//
//  Created by Stefan Buretea on 4/11/15.
//  Copyright (c) 2015 Stefan Burettea. All rights reserved.
//

import UIKit

class RKGCountryMoreInfoViewController: UIViewController {

    private var country: CountryGeonames!
    private let countryMoreInfo = CountryMoreInfo()
    @IBOutlet weak var detailsTextView: UITextView!
    
    func setCountry(country: CountryGeonames) {
        self.country = country
    }
    
    @IBAction func homeButtonPressed(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatInfoText()
        setupNavigationBarView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func setupNavigationBarView() {
        
        let containerView: UIView = UIView(frame: CGRectMake(-10, 0, 100, 40))
        
        let flagView: UIImageView = UIImageView(frame: CGRectMake(0, 10, 20, 20))
        flagView.image = self.country.flag
        
        let countryNameLabel: UILabel = UILabel(frame: CGRectMake(25, 0, 130, 40))
        
        var attributedTitle = NSMutableAttributedString(string: self.country.name.uppercaseString)

        attributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial-BoldMT", size: 12)!, range: NSMakeRange(0, attributedTitle.length))
        attributedTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedTitle.length))
        countryNameLabel.attributedText = attributedTitle
        countryNameLabel.numberOfLines = 1
        countryNameLabel.adjustsFontSizeToFitWidth = true
        countryNameLabel.minimumScaleFactor = 5.0/countryNameLabel.font.pointSize
        
        containerView.addSubview(flagView)
        containerView.addSubview(countryNameLabel)
        
        self.navigationItem.titleView = containerView
    }
    
    private func formatInfoText() {
        
        let details = countryMoreInfo.details(self.country)
        var formattedDetails = NSMutableAttributedString()

        var titles = Array(details.keys)
        titles.sort {
            $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending
        }
        
        titles.filter{
            var attributedString = self.formatInfoTextItem($0, content: details[$0]!)
            formattedDetails.appendAttributedString(attributedString)
            
            return true
        }
        
        var text = NSMutableAttributedString(string: "")
        text.appendAttributedString(formattedDetails)
        self.detailsTextView.attributedText = text
        self.detailsTextView.scrollEnabled = false
        self.detailsTextView.scrollRangeToVisible(NSMakeRange(0,0))
        self.detailsTextView.scrollEnabled = true
    }
    
    private func formatInfoTextItem(title: String, content: String) -> NSAttributedString {
        
        var attributedTitle = NSMutableAttributedString(string: title.uppercaseString)

        attributedTitle.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial-BoldMT", size: 20)!, range: NSMakeRange(0, attributedTitle.length))
        attributedTitle.addAttribute(NSStrokeColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedTitle.length))
        attributedTitle.addAttribute(NSStrokeWidthAttributeName, value: NSNumber(float: 3.0), range: NSMakeRange(0, attributedTitle.length))
        
        var attributedContent = NSMutableAttributedString(string: content)
        
        attributedContent.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial-BoldMT", size: 13)!, range: NSMakeRange(0, attributedContent.length))
        attributedContent.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedContent.length))
        
        var result = NSMutableAttributedString()
        result.appendAttributedString(attributedTitle)
        result.appendAttributedString(NSAttributedString(string: "\n\n"))
        result.appendAttributedString(attributedContent)
        result.appendAttributedString(NSAttributedString(string: "\n\n\n\n"))
        
        return result
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
