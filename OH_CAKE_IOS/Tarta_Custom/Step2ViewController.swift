//
//  Step2ViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 10/5/22.
//

import UIKit

class Step2ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var size = ""
    var shape = ""
    
    @IBOutlet weak var formacollection: UICollectionView!
    
    @IBOutlet weak var foto_muestra: UIImageView!
    var Phase2Data:[[String:Any]] = [[:]]
    var urlfotoforma = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Phase2Data[0].isEmpty{
            Phase2Data.remove(at: 0)
        }

        formacollection.delegate = self
        formacollection.dataSource = self
        
        self.getPhase2()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Phase2Data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formacell", for: indexPath) as! FormaCell
        
        if Phase2Data.count > 1{
            let urlString = Phase2Data[indexPath.item]["image"] as! String
            guard let url = URL(string: urlString) else {return cell}
            urlfotoforma = urlString
            cell.foto_forma.load(url: url)
    
            cell.nombre_forma.text = Phase2Data[indexPath.item]["name"] as! String
            
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
        
        let selectedCell:UICollectionViewCell = formacollection.cellForItem(at: indexPath)!
        
        selectedCell.contentView.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        
        shape = Phase2Data[indexPath.item]["name"] as! String
       
        
        let urlString = Phase2Data[indexPath.item]["image_customization"] as! String
        guard let url = URL(string: urlString) else {return}
        urlfotoforma = urlString
        self.foto_muestra.load(url: url)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
 
        //Esto hay que hacerlo con un if let por que ios destruye las celdas que no estan en pantalla asi que si la pulsas de vuelta despues de hacer scroll, le da ansiedad, se muere y peta
        if let cellToDeselect:UICollectionViewCell = formacollection.cellForItem(at: indexPath){
            cellToDeselect.contentView.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func step3Btn(_ sender: Any) {
        
        //Si la forma no esta seleccionada, lanza un error
        if shape == ""{
            let alert = UIAlertController(title: "Error", message: "¡No has elegido la forma!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        //Si todo esta bien instancia el siguiente vc
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "paso3") as! Step3ViewController
            
            //Le voy pasando los datos en cascada, quiere decir que la peticion estara en el ultimo vc de la customizacion
            vc.size = size
            vc.shape = shape
            
            vc.urlfoto = urlfotoforma
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func getPhase2(){
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/customcakemodel/1"
        
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
                
                self.Phase2Data = cosas
                
                    DispatchQueue.main.async {
                        self.formacollection.reloadData()
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
