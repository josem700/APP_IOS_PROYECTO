//
//  Step4ViewController.swift
//  OH_CAKE_IOS
//
//  Created by Practica_libre on 11/5/22.
//

import UIKit

class Step4ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var rellenoCollection: UICollectionView!
    
    var size = ""
    var shape = ""
    var base = ""
    var relleno = ""
    
    @IBOutlet weak var foto_forma: UIImageView!
    @IBOutlet weak var foto_relleno: UIImageView!
    @IBOutlet weak var Foto_Base: UIImageView!
    
    var urlStringforma = ""
    var urlStringBase = ""
    var urlStringRelleno = ""
    
    var Rellenos:[[String:Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlForma = URL(string: urlStringforma) else {return}
        guard let urlBase = URL(string: urlStringBase) else {return}
        
        foto_forma.load(url: urlForma)
        Foto_Base.load(url: urlBase)
        
        if Rellenos[0].isEmpty{
            Rellenos.remove(at: 0)
        }

        // Do any additional setup after loading the view.
        rellenoCollection.delegate = self
        rellenoCollection.dataSource = self
        
        self.getPhase4()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Rellenos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdarelleno", for: indexPath) as! RellenoCell
        
        
        if Rellenos.count > 1{
            
            let urlString = Rellenos[indexPath.item]["image"] as! String
            guard let url = URL(string: urlString) else {return cell}
            
            cell.foto_relleno.load(url: url)
            let nombre = Rellenos[indexPath.item]["name"] as! String
            let index = nombre.firstIndex(of: " ")!
            let recorte = nombre[..<index]
            let recortado = String(recorte)
            cell.nombre_relleno.text = recortado
            
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
        
        let urlString = Rellenos[indexPath.item]["image_customization"] as! String
        guard let url = URL(string: urlString) else {return}
        
        foto_relleno.load(url: url)
        relleno = Rellenos[indexPath.item]["name"] as! String
        urlStringRelleno = Rellenos[indexPath.item]["image_customization"] as! String
        
        let selectedCell:UICollectionViewCell = rellenoCollection.cellForItem(at: indexPath)!

        selectedCell.contentView.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cellToDeselect:UICollectionViewCell = rellenoCollection.cellForItem(at: indexPath){
            cellToDeselect.contentView.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func ingredientesBtn(_ sender: Any) {
        
        if relleno == ""{
            let alert = UIAlertController(title: "Error", message: "¡No has elegido el relleno!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "paso5") as! Step5ViewController
            
            vc.size = size
            vc.shape = shape
            vc.base = base
            vc.relleno = relleno
            
            vc.urlStringforma = urlStringforma
            vc.urlStringBase = urlStringBase
            vc.urlStringRelleno = urlStringRelleno
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func getPhase4(){
        
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/customcakemodel/3"
        
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
                
                var Phase4Data:[[String:Any]] = [[:]]
                Phase4Data = cosas

                    DispatchQueue.main.async {
                        
                        for i in 0...Phase4Data.count - 1{
                        
                            let nombre = Phase4Data[i]["name"] as! String
                            
                            if nombre.contains(self.shape){
                                self.Rellenos.append(Phase4Data[i])
                                print(self.Rellenos)
                            }
                        }
                        self.rellenoCollection.reloadData()
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
