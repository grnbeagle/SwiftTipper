//
//  ViewController.swift
//  SwiftTipper
//
//  Created by Amie Kweon on 4/13/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!

    let formatter = NSNumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.numberStyle = .CurrencyStyle
        updateCurrency()

        tipLabel.text = formatter.stringFromNumber(0)
        totalLabel.text = formatter.stringFromNumber(0)

        restoreFromCacheIfLessThan10MinutesAgo()
        billField.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        updateCurrency()
        calculate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        calculate()

        let settingsManager = SettingsManager.sharedSettingsManager()
        settingsManager.setSetting("amount", value: billField.text)
        println("SAVED \(billField.text)")
        settingsManager.setSetting("datetime", value: Int(NSDate().timeIntervalSince1970))
        println("SAVED \(Int(NSDate().timeIntervalSince1970))")
    }

    func loadPercentageSelectorAndReturnArray() -> [Double] {
        var tipPercentages = [Double]()

        let settingsManager = SettingsManager.sharedSettingsManager()
        let startValue: Double = (settingsManager.getSettingByKey("start") as NSString).doubleValue
        var incrementValue: Double = (settingsManager.getSettingByKey("increment") as NSString).doubleValue

        for i in 0...2 {
            // SettingsManager provides default values, so safe to unwrap
            tipPercentages.append(startValue / Double(100.0) + Double(i) * (incrementValue / Double(100.0)))
            var valueInPercent = startValue + Double(i) * incrementValue
            tipControl.setTitle(String(format: "%.0f%%", valueInPercent), forSegmentAtIndex: i)

        }
        return tipPercentages
    }

    func updateCurrency() {
        formatter.locale = NSLocale(localeIdentifier: SettingsManager.sharedSettingsManager().getLocaleIdentifier())
        billField.placeholder = formatter.currencySymbol!
    }

    func calculate() {
        var tipPercentages = loadPercentageSelectorAndReturnArray()
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]

        var billAmount = (billField.text as NSString).doubleValue
        var tip = billAmount * tipPercentage
        var total = billAmount + tip

        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
    }

    func restoreFromCacheIfLessThan10MinutesAgo() {
        var datetime: Int = SettingsManager.sharedSettingsManager().getSettingByKey("datetime")
        var tenMinutes = 10 * 60 * 1000
        if (Int(NSDate().timeIntervalSince1970) - datetime < tenMinutes) {
            var amount: String = SettingsManager.sharedSettingsManager().getSettingByKey("amount")
            println("RESTORED \(datetime) - \(amount)")
            billField.text = amount
        } else {
            println("EXPIRED")
        }
    }


    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

}

