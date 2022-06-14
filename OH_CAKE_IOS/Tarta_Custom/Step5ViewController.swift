//
//  Step5ViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 12/5/22.
//

import UIKit

class Step5ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    var size = ""
    var shape = ""
    var base = ""
    var relleno = ""
    
    var ingredientes:[[Int:Int]] = [[0:0]]
    var Ingredients:[[String:Any]] = [[:]]
    
    var urlStringforma = ""
    var urlStringBase = ""
    var urlStringRelleno = ""
    
    
    @IBOutlet weak var foto_forma: UIImageView!
    @IBOutlet weak var foto_base: UIImageView!
    @IBOutlet weak var foto_relleno: UIImageView!
    @IBOutlet weak var foto_ingrediente: UIImageView!
    
    
    var isSelected = false
    
    @IBOutlet weak var IngredientesCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let urlForma = URL(string: urlStringforma) else {return}
        guard let urlBase = URL(string: urlStringBase) else {return}
        guard let urlRelleno = URL(string: urlStringRelleno) else {return}

        self.foto_forma.load(url: urlForma)
        self.foto_base.load(url: urlBase)
        self.foto_relleno.load(url: urlRelleno)

        
        
        if Ingredients[0].isEmpty{
            Ingredients.remove(at: 0)
        }
        
        if ingredientes[0] == [0:0]{
            ingredientes.remove(at: 0)
        }

        IngredientesCollection.delegate = self
        IngredientesCollection.dataSource = self
        
        self.GetIngredientes()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaIngrediente", for: indexPath) as! IngredientesCell
        
        if Ingredients.count > 1{
            
            let urlString = Ingredients[indexPath.item]["image"] as! String
            guard let url = URL(string: urlString) else {return cell}
            
            cell.foto_Ingrediente.load(url: url)
            cell.nombre_ingrediente.text = Ingredients[indexPath.item]["name"] as! String
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Capturar aqui que boton ha pulsado
        
        //ingredientes.append("\(Ingredients[indexPath.item]["name"] as! String)",3)
        print(ingredientes)
        
        let selectedCell = IngredientesCollection.cellForItem(at: indexPath) as! IngredientesCell
        
       
        if !isSelected {
            let urlString = Ingredients[indexPath.item]["image_customization"] as! String
            guard let url = URL(string: urlString) else {return}
            
            foto_ingrediente.load(url: url)
            
            selectedCell.contentView.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
            if selectedCell.currentUnidades < 1{
                selectedCell.currentUnidades = 1
            }
            
            ingredientes.append([Ingredients[indexPath.item]["id"] as! Int:selectedCell.currentUnidades])
            print(ingredientes)
            isSelected = true
            
        }
        
        else{
            
            self.foto_ingrediente.image = nil
            selectedCell.contentView.backgroundColor = UIColor.clear
            selectedCell.currentUnidades = 0
            //ingredientes.remove(at: indexPath.item)
            print(ingredientes)
            isSelected = false
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cellToDeselect:UICollectionViewCell = IngredientesCollection.cellForItem(at: indexPath){
            cellToDeselect.contentView.backgroundColor = UIColor.clear
        }
        
    }

    @IBAction func FinalStepBtn(_ sender: Any) {
        
        if ingredientes.isEmpty{
            
            let alert = UIAlertController(title: "Error", message: "¡No has elegido ningun ingrediente!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "final") as! FinalStepViewController
            
            vc.size = size
            vc.shape = shape
            vc.base = base
            vc.relleno = relleno
            vc.ingredientes = ingredientes
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    func GetIngredientes(){
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/customcakemodel/4"
        
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
                
                var Phase5Data:[[String:Any]] = [[:]]
                Phase5Data = cosas

                    DispatchQueue.main.async {
                        
                        for i in 0...Phase5Data.count - 1{
                        
                            let nombre = Phase5Data[i]["name"] as! String
                            
                            if nombre.contains(self.shape){
                                self.Ingredients.append(Phase5Data[i])
                                print(self.Ingredients)
                            }
                        }
                        self.IngredientesCollection.reloadData()
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
