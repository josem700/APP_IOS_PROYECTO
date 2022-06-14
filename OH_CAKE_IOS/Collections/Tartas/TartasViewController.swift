//
//  TartasViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 26/5/22.
//

import UIKit

class TartasViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var TartasCollection: UICollectionView!
    @IBOutlet weak var CategoriaLabel: UILabel!
    
    //Esto funciona de la misma forma que en el controller de las categorias
    var tartas:[[String:Any]] = [[:]]
    
    //Esto se lo paso al instanciar este controlador en las categorias
    var id_categoria = 0
    var nombreCat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.TartasCollection.delegate = self
        self.TartasCollection.dataSource = self
        self.CategoriaLabel.text = nombreCat
        
       
        self.getTartas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tartas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tartascell", for: indexPath) as! TartasCell
    
        //Si el array de tartas no esta vacio hace cosas
        if !tartas[indexPath.row].isEmpty {
            cell.NombreLabel.text = tartas[indexPath.row]["name"] as! String
            let urlString = tartas[indexPath.row]["image"] as! String
            guard let url = URL(string: urlString) else {return cell}
            cell.Foto_tarta.load(url: url)
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "singletarta") as! UnaTartaViewController
        
        vc.id_tarta = tartas[indexPath.item]["id"] as! Int
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getTartas(){
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/defaultcakecategory/\(id_categoria)"
        
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
                let cosas = try JSONSerialization.jsonObject(with: datos, options: .fragmentsAllowed) as! [String:Any]
                
                //Asigno los datos de las tartas de esta categoria
                self.tartas = cosas["default_cakes"] as! [[String : Any]]
                
                DispatchQueue.main.async {
                    //Actualizo la tabla
                    self.TartasCollection.reloadData()
                }
                
            }
            catch{
                print("Error: \(error)")
            }

        }.resume()
    }

}
