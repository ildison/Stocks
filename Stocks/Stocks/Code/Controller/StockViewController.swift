//
//  StockViewController.swift
//  Stocks
//
//  Created by 18574302 on 11.11.2020.
//

import UIKit

let offset: CGFloat = 40

class StockViewController: UIViewController {
	
	private lazy var companyNameLabel = UILabel()
	private lazy var symbolLabel = UILabel()
	private lazy var priceLabel = UILabel()
	private lazy var priceChangeLabel = UILabel()
	private lazy var companyPickerView = UIPickerView()
	private lazy var activityIndicator = UIActivityIndicatorView()
	private let api: StockApi = StockApi()
	private var stockModel: Stock?
	
	private lazy var companies = [
		"Apple": "AAPl",
		"Microsoft": "MSFT",
		"Google": "GOOG",
		"Amazon": "AMZN",
		"Facebook": "FB"
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		setupConstraints()
		requestQuoteUpdate()
	}
	
	func setupUI() {
		view.backgroundColor = .white
		
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.hidesWhenStopped = true
		view.addSubview(activityIndicator)
		
		setupStaticLabels()
		setupDinamicLabels()
		setupCompanyPickerView()
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			companyNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset),
			companyNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
			
			symbolLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset),
			symbolLabel.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: offset),

			priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset),
			priceLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: offset),
			
			priceChangeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset),
			priceChangeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: offset),
			
			companyPickerView.rightAnchor.constraint(equalTo: view.rightAnchor),
			companyPickerView.leftAnchor.constraint(equalTo: view.leftAnchor),
			companyPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			companyPickerView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
			
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	func setupStaticLabels() {
		let company = UILabel()
		company.translatesAutoresizingMaskIntoConstraints = false
		company.textAlignment = .left
		company.text = "Company name"
		view.addSubview(company)
		
		let symbol = UILabel()
		symbol.translatesAutoresizingMaskIntoConstraints = false
		symbol.textAlignment = .left
		symbol.text = "Symbol"
		view.addSubview(symbol)
		
		let price = UILabel()
		price.translatesAutoresizingMaskIntoConstraints = false
		price.textAlignment = .right
		price.text = "Price"
		view.addSubview(price)

		let priceChange = UILabel()
		priceChange.translatesAutoresizingMaskIntoConstraints = false
		priceChange.textAlignment = .right
		priceChange.text = "Price change"
		view.addSubview(priceChange)
		
		NSLayoutConstraint.activate([
			company.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
			company.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
			
			symbol.leadingAnchor.constraint(equalTo: company.leadingAnchor),
			symbol.topAnchor.constraint(equalTo: company.bottomAnchor, constant: offset),
			
			price.leadingAnchor.constraint(equalTo: company.leadingAnchor),
			price.topAnchor.constraint(equalTo: symbol.bottomAnchor, constant: offset),
			
			priceChange.leadingAnchor.constraint(equalTo: company.leadingAnchor),
			priceChange.topAnchor.constraint(equalTo: price.bottomAnchor, constant: offset)
		])
	}
	
	func setupDinamicLabels() {
		companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
		companyNameLabel.textAlignment = .right
		companyNameLabel.text = "-"
		view.addSubview(companyNameLabel)
		
		symbolLabel.translatesAutoresizingMaskIntoConstraints = false
		symbolLabel.textAlignment = .right
		symbolLabel.text = "-"
		view.addSubview(symbolLabel)
		
		priceLabel.translatesAutoresizingMaskIntoConstraints = false
		priceLabel.textAlignment = .right
		priceLabel.text = "-"
		view.addSubview(priceLabel)
		
		priceChangeLabel.translatesAutoresizingMaskIntoConstraints = false
		priceChangeLabel.textAlignment = .right
		priceChangeLabel.text = "-"
		view.addSubview(priceChangeLabel)
	}
	
	func setupCompanyPickerView() {
		companyPickerView.translatesAutoresizingMaskIntoConstraints = false
		companyPickerView.dataSource = self
		companyPickerView.delegate = self
		view.addSubview(companyPickerView)
	}
	
	func parseQuote(from data: Data) {
		do {
			let json = try JSONDecoder().decode(Stock.self, from: data)
			DispatchQueue.main.async { [weak self] in
				self?.displayStockInfo(for: json)
			}
		} catch {
			print("JSON parsing error: " + error.localizedDescription)
		}
	}
	
	private func requestQuoteUpdate() {
		activityIndicator.startAnimating()
		symbolLabel.text = "-"
		priceLabel.text = "-"
		priceChangeLabel.text = "-"
		
		let selectedRow = companyPickerView.selectedRow(inComponent: 0)
		let selectedSymbol = Array(companies.values)[selectedRow]
		api.requestQoute(from: selectedSymbol, completion: parseQuote(from:))
	}
	
	func displayStockInfo(for stock: Stock) {
		activityIndicator.stopAnimating()
		companyNameLabel.text = stock.companyName
		symbolLabel.text = stock.symbol
		priceLabel.text = "\(stock.latestPrice)"
		priceChangeLabel.text = "\(stock.change)"
	}
	
}

extension StockViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return companies.count
	}
}

extension StockViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return Array(companies.keys)[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		requestQuoteUpdate()
	}
}
