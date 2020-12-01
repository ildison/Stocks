//
//  Api.swift
//  Stocks
//
//  Created by 18574302 on 18.11.2020.
//

import UIKit

protocol StockApiProtocol {
	static var token: String { get }
	
	func requestQoute(from company: String, completion: @escaping (Data) -> Void)
}

struct StockApi: StockApiProtocol {
	
	static var token = "pk_cf10be9dc1e948b088452241e8b6a1c8"
	
	func requestQoute(from company: String, completion: @escaping (Data) -> Void) {
		guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(company)/quote?token=\(StockApi.token)") else {
			return
		}
		let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 {
				completion(data)
			} else {
				print("Network error")
			}
		}
		dataTask.resume()
	}
}
