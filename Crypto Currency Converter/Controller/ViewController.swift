//
//  ViewController.swift
//  Crypto Currency Converter
//
//  Created by Mustafa on 13/12/19.
//  Copyright © 2019 Mustafa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var cryptoCurrencylbl: UILabel!
    @IBOutlet weak var currencylbl: UILabel!
    @IBOutlet weak var cryptoCurrencyPickerView: UIPickerView!
    
    var currencySymbol:String = ""
    var crytoCurrency:String = ""
    var selectedCurrency:String = ""
    var finalCurrency:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cryptoCurrencyPickerView.dataSource = self
        cryptoCurrencyPickerView.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - PICKERVIEW DATASOURCE AND DELEGATE

extension ViewController : UIPickerViewDataSource,UIPickerViewDelegate  {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return coinManager.newCurrencyArray.count
        } else {
            return coinManager.currencyArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return coinManager.newCurrencyArray[row]
        } else {
            return coinManager.currencyArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            crytoCurrency = coinManager.newCurrencyArray[row]
        }
        else if component == 1 {
            if crytoCurrency == "" {
                crytoCurrency = "BTC"
                selectedCurrency = coinManager.currencyArray[row]
                currencySymbol = coinManager.currencyArray[row]
                finalCurrency = crytoCurrency+selectedCurrency
                coinManager.getCoinPrice(currency:finalCurrency)
            } else {
                selectedCurrency = coinManager.currencyArray[row]
                currencySymbol = coinManager.currencyArray[row]
                finalCurrency = crytoCurrency+selectedCurrency
                coinManager.getCoinPrice(currency:finalCurrency)
            }
        }
    }
}
//MARK: - COIN MANAGER DELEGATE

extension ViewController:CoinManagerDelegate {
    func didUpdatePrice(price: Double) {
        DispatchQueue.main.async {
            self.cryptoCurrencylbl.text = String(price)
            self.currencylbl.text = self.currencySymbol
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

