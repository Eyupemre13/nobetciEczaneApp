//
//  ViewController.swift
//  Nobetci-Eczane-App
//
//  Created by Eyüp Emre Aygün on 11.05.2022.
//

import UIKit
import Foundation


class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var txtSehir: UITextField!
    @IBOutlet weak var aramaButton: UIButton!
    @IBOutlet weak var tarihButton: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var nameArray = [String]()
    var distArray = [String]()
    var addressArray = [String]()
    var phoneArray = [String]()
    var locArray = [String]()
    var il: String = "Edirne"
    @IBAction func araButton(_ sender: Any) {
        if txtSehir.text?.isEmpty != true {
            il.removeAll()
            il = txtSehir.text!
            title = "\(il) Nöbetçi Eczaneler".capitalized
            
            il = try! txtSehir.text!.lowercased().convertedToSlug()
            
            print("temizlenmiş il adı --> \(il)")
            txtSehir.text = ""
            
            nameArray.removeAll()
            distArray.removeAll()
            addressArray.removeAll()
            phoneArray.removeAll()
            locArray.removeAll()
            tableView.reloadData()
            
            getJsonUrl()
        }
        
        else{
            let alert = UIAlertController(title: "Uyarı!", message: "Lütfen bir şehir adı giriniz.", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (action: UIAlertAction!) in
                  print("uyari kapatıldı")
            }))
            present(alert, animated: true, completion: nil)
        }
        
        var il: String = "Edirne"
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMMM"
                formatter.timeZone = TimeZone(abbreviation: "UTC+3")!
                formatter.locale = Locale(identifier: "tr-TR")
                
                let utcTimeZoneStr = formatter.string(from: date)
                print("geçerli tarih: \(utcTimeZoneStr)")
                
                tarihButton.text = "\(utcTimeZoneStr) tarihi için nöbetçi eczaneler"
                
                title = "\(il.capitalized) Nöbetçi Eczaneler".capitalized
                print("viewdidload \(il)")
                
               
                
                getJsonUrl()
       
    }
    func getJsonUrl() {
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 4TEQx3szhl8y36FNhKlmlZ:61twqeLpGVCotPzttNrYcx"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/health/dutyPharmacy?ilce=%C3%87ankaya&il=Ankara")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
            
            print("session başlatıldı...")
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                        //print(jsonResponse!["result"])
                        
                        if let eczaArray = jsonResponse!.value(forKey: "result") as? NSArray {
                            for ecza in eczaArray{
                                if let eczaDict = ecza as? NSDictionary {
                                    if let name = eczaDict.value(forKey: "name") {
                                        self.nameArray.append(name as! String)
                                    }
                                    if let name = eczaDict.value(forKey: "dist") {
                                        self.distArray.append(name as! String)
                                    }
                                    if let name = eczaDict.value(forKey: "address") {
                                        self.addressArray.append(name as! String)
                                    }
                                    if let name = eczaDict.value(forKey: "phone") {
                                        self.phoneArray.append(name as! String)
                                    }
                                    if let name = eczaDict.value(forKey: "loc") {
                                        self.locArray.append(name as! String)
                                    }
                                }
                            }
                        }
                        
                        OperationQueue.main.addOperation({
                            self.tableView.reloadData()
                        })
                        
                    }
                    catch {
                        print("do try catch hatası")
                    }
                }
            })
            dataTask.resume()
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 95.0;
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return nameArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            
            cell.lblName.text = nameArray[indexPath.row].uppercased()
            
            if cell.lblName.text!.hasSuffix("Sİ") || cell.lblName.text!.hasSuffix("SI")  == true {
    //            print("including the word")
            }
            else{
                cell.lblName.text!.append(" ECZANESİ")
            }
            
            cell.lblDist.text = "・" + distArray[indexPath.row].capitalized
            cell.lblAdress.text = addressArray[indexPath.row].capitalized
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            detailVC.nameString = nameArray[indexPath.row]
            detailVC.distString = distArray[indexPath.row]
            detailVC.addressString = addressArray[indexPath.row]
            detailVC.phoneString = phoneArray[indexPath.row]
            detailVC.locString = locArray[indexPath.row]
            
    //      self.navigationController?.pushViewController(detailVC, animated: true)
            
            let navController = UINavigationController(rootViewController: detailVC)
            self.present(navController, animated:true, completion: nil)
        }
    }

    enum SlugConversionError: Error {
        case failedToConvert
    }

    extension String {
        private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")

        private func convertedToSlugBackCompat() -> String? {
            if let data = self.data(using: .ascii, allowLossyConversion: true) {
                if let str = String(data: data, encoding: .ascii) {
                    let urlComponents = str.lowercased().components(separatedBy: String.slugSafeCharacters.inverted)
                    return urlComponents.filter { $0 != "" }.joined(separator: "-")
                }
            }
            return nil
        }

        public func convertedToSlug() throws -> String {
            var result: String? = nil

            #if os(Linux)
                result = convertedToSlugBackCompat()
            #else
                if #available(OSX 10.11, *) {
                    if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
                        let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
                        result = urlComponents.filter { $0 != "" }.joined(separator: "-")
                    }
                } else {
                    result = convertedToSlugBackCompat()
                }
            #endif

            if let result = result {
                if result.count > 0 {
                    return result
                }
            }

            throw SlugConversionError.failedToConvert
        }
    }




