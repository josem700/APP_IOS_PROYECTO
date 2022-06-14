//
//  Step3ViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 10/5/22.
//

import UIKit

class Step3ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var size = ""
    var shape = ""
    var base = ""
    
    
    @IBOutlet weak var foto_forma: UIImageView!
    @IBOutlet weak var basecollection: UICollectionView!
    
    var urlfoto = ""
    var urlfoto_base = ""
    var Bases:[[String:Any]] = [[:]]
    
    @IBOutlet weak var foto_base: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Bases[0].isEmpty{
            Bases.remove(at: 0)
        }
        // Do any additional setup after loading the view.
        guard let url = URL(string: urlfoto) else {return}
        foto_forma.load(url: url)
        
        basecollection.delegate = self
        basecollection.dataSource = self
        
        self.getphase3()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Bases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basecell", for: indexPath) as! BaseCell
        
        
        if Bases.count > 1{
            
            let nombre = Bases[indexPath.item]["name"] as! String
            let index = nombre.firstIndex(of: " ")!
            let recorte = nombre[..<index]
            let recortado = String(recorte)
            cell.Nombre_Base.text = recortado
            
                let urlString = Bases[indexPath.item]["image"] as! String
                guard let url = URL(string: urlString) else {return cell}
                cell.foto_Base.load(url: url)
        }
        
      
        if cell.isSelected {
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        }
        else{
            cell.contentView.backgroundColor = UIColor.clear
        }
        
        return cell
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Capturar aqui que boton ha pulsado
        
        var urlString = Bases[indexPath.item]["image_customization"] as! String
        guard let url = URL(string: urlString) else {return}
        foto_base.load(url: url)
        
        urlfoto_base = urlString
        base = Bases[indexPath.item]["name"] as! String
        
        let selectedCell:UICollectionViewCell = basecollection.cellForItem(at: indexPath)!
  
        selectedCell.contentView.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cellToDeselect:UICollectionViewCell = basecollection.cellForItem(at: indexPath){
            cellToDeselect.contentView.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func rellenoBtn(_ sender: Any) {
        
        if base == ""{
            let alert = UIAlertController(title: "Error", message: "¡No has elegido la Base!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "paso4") as! Step4ViewController
            
            vc.size = size
            vc.shape = shape
            vc.base = base
            
            vc.urlStringforma = urlfoto
            vc.urlStringBase = urlfoto_base 
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getphase3(){
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/customcakemodel/2"
        
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){(data,response,error) in

            //Si el error no es nulo que nos diga que está pasando
            if error != nil {
                print ("Error: \(error!.localizedDescription)")
            }
            //Si la respuesta es nula,que nos digo que no hay respuesta
            if response != nil {
                print (response ?? "No se ha obtenido respuesta")
            }
            if let res = response as? HTTPURLResponse {
                print("Status code: \(res.statusCode)")
            }
            
            guard let datos = data else {return}
            
            do{
                let cosas = try JSONSerialization.jsonObject(with: datos, options: .fragmentsAllowed) as! [[String:Any]]
                
                print(cosas)
                
                var Phase3Data:[[String:Any]] = [[:]]
                Phase3Data = cosas

                    DispatchQueue.main.async {
                        
                        for i in 0...Phase3Data.count - 1{
                        
                            let nombre = Phase3Data[i]["name"] as! String
                            
                            if nombre.contains(self.shape){
                                self.Bases.append(Phase3Data[i])
                                print(self.Bases)
                            }
                        }
                        self.basecollection.reloadData()
                    }
                }
            
            catch{
                print("Error: \(error)")
            }

        }.resume()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
