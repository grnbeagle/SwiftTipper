//
//  SettingsManager.swift
//  SwiftTipper
//
//  Created by Amie Kweon on 4/13/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class SettingsManager {

    let currencyArray = [
        "U.S. Dollar (USD)",
        "European Euro (EUR)",
        "Japanese Yen (JPY)",
        "Korean Won (KRW)",
        "Mexican Peso (MXN)"
    ]
    let localeIdentifiers = ["en_US", "en_GB", "ja_JP", "ko_KR", "es_MX"]

    let defaultStart = "15"
    let defaultIncrement = "3"

    class func sharedSettingsManager() -> SettingsManager {
        return _sharedSettingsManager
    }

    func getSettingByKey(key: String) -> String {
        var returnValue = ""
        var defaults = NSUserDefaults.standardUserDefaults()
        var settingValue = defaults.objectForKey(key) as? String

        if let actualValue = settingValue {
            returnValue = actualValue
        } else {
            switch key {
            case "start":
                returnValue = defaultStart
            case "increment":
                returnValue = defaultIncrement
            default:
                returnValue = ""
            }
        }
        return returnValue
    }

    func getSettingByKey(key: String) -> Int {
        var returnValue = 0
        var defaults = NSUserDefaults.standardUserDefaults()
        var settingValue = defaults.objectForKey(key) as? Int

        if let actualValue = settingValue {
            returnValue = actualValue
        }
        return returnValue
    }

    func setSetting(key: String, value: String) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }

    func setSetting(key: String, value: Int) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(value, forKey: key)
        defaults.synchronize()
    }

    func setLocalIdentifier(row: Int) {
        setSetting("localeIdentifier", value: localeIdentifiers[row])
    }

    func getLocaleIdentifier() -> String {
        var returnValue: String
        var defaults = NSUserDefaults.standardUserDefaults()
        var settingValue = defaults.objectForKey("localeIdentifier") as? String

        if let actualValue = settingValue {
            returnValue = actualValue
        } else {
            returnValue = localeIdentifiers[0]
        }
        return returnValue
    }
}
private let _sharedSettingsManager = SettingsManager()
