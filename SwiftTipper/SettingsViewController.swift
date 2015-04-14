//
//  SettingsViewController.swift
//  SwiftTipper
//
//  Created by Amie Kweon on 4/13/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let currencyArray = SettingsManager.sharedSettingsManager().currencyArray

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var incrementField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        currencyPicker.delegate = self
        currencyPicker.dataSource = self

        let settingsManager = SettingsManager.sharedSettingsManager()
        let selectedIndex = find(settingsManager.localeIdentifiers, settingsManager.getLocaleIdentifier())
        if let selectedIndex = selectedIndex {
            currencyPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        startField.text = settingsManager.getSettingByKey("start")
        incrementField.text = settingsManager.getSettingByKey("increment")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    //MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return currencyArray[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SettingsManager.sharedSettingsManager().setLocalIdentifier(row)
    }

    @IBAction func onStartFieldEdit(sender: AnyObject) {
        SettingsManager.sharedSettingsManager().setSetting("start", value: startField.text)
    }

    @IBAction func onIncrementFieldEdit(sender: AnyObject) {
        SettingsManager.sharedSettingsManager().setSetting("increment", value: incrementField.text)
    }
}
