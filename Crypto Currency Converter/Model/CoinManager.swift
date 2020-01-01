//
//  CoinManager.swift
//  Crypto Currency Converter
//
//  Created by Mustafa on 13/12/19.
//  Copyright © 2019 Mustafa. All rights reserved.
//


import Foundation

//MARK: - PROTOCOL WITH TWO FUNC
protocol CoinManagerDelegate {
    func didUpdatePrice(price: Double)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate:CoinManagerDelegate?
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var newCurrencyArray = ["BTC","ETH","LTC","BCH","XRP","XMR","ZEC"]
    
    func getCoinPrice(currency:String){
        let finalURL = "\(baseURL)\(currency)"
        performRequest(with: finalURL)
    }
    
    //MARK: - NETWORKING
    func performRequest(with urlString:String){
        // Implimenting Four Functions of Networking
        // 1 - Create URL
        if let url = URL(string: urlString){
            // 2 - Create a URL Session
            let session = URLSession(configuration: .default)
            // 3 - Give Session a Task
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                } else {
                    if let safeData = data {
                        let currencyData = self.parseJSON(safeData)
                        self.delegate?.didUpdatePrice(price: currencyData!)
                    }
                }
            } // 4 - Start the Task
            task.resume()
        }
    }
    //MARK: - CONVERTING DATA IN JSON FORMAT
    
    func parseJSON(_ data:Data)->Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.last
            return lastPrice
        } catch {
            delegate?.didFailWithError(error:error)
            return nil
        }
    }
    
}


