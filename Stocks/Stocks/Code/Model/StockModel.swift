//
//  StockModel.swift
//  Stocks
//
//  Created by 18574302 on 18.11.2020.
//

import Foundation

struct Stock: Codable {
	var companyName: String
	var symbol: String
	var latestPrice: Double
	var change: Double
}
