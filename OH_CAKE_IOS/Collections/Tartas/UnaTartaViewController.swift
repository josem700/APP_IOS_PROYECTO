//
//  UnaTartaViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 31/5/22.
//

import UIKit

class UnaTartaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //El tableview donde van los ingredientes
    @IBOutlet weak var IngredientesTable: UITableView!
    @IBOutlet weak var AlergenosTable: UITableView!
    
    //Outlets de los campos
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var foto_tarta: UIImageView!
    @IBOutlet weak var NombreTartaLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    
    //Tres vistas que se usan a modo de "TabLayout"
    @IBOutlet weak var VistaIngredientes: UIView!
    @IBOutlet weak var VistaDescripcion: UIView!
    @IBOutlet weak var VistaAlergenos: UIView!
    
    
    var detalles:[String:Any] = [:]
    var ingredientes:[[String:Any]] = [[:]]
    var alergenos:[[String:Any]] = [[:]]
    
    var id_tarta = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.IngredientesTable.delegate = self
        self.IngredientesTable.dataSource = self
        
        self.AlergenosTable.delegate = self
        self.AlergenosTable.dataSource = self

        self.getTarta()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == IngredientesTable {
            return ingredientes.count
        }
        else{
            return alergenos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == IngredientesTable{
            let ingrediente = tableView.dequeueReusableCell(withIdentifier: "ingredientes", for: indexPath) as! TartaCell
            if ingredientes.count > 1{
                ingrediente.IngredienteLabel.text = ingredientes[indexPath.item]["name"] as! String
            }
            
            return ingrediente
        }
        
        else{
            let alergeno = tableView.dequeueReusableCell(withIdentifier: "alergenos", for: indexPath) as! AllergenCell
            if alergenos[0].isEmpty{
                self.alergenos.remove(at: 0)
            }
            if alergenos.count > 1{
                
                alergeno.AlergenoLabel.text = alergenos[indexPath.item]["name"] as! String
            }
            
            return alergeno
        }
    }
    
    //Las vistas estan stackeadas una dentro de otra en el siguiente orden => Ingredientes(Principal) -> Descripcion(Dentro de ingredientes) -> Alergenos(Dentro de Descripcion)
    //Lo que hago es esconder las vistas que hay debajo en funcion del seleccionado tipo si elijo ingredientes se esconden descripcion y alergenos o si elijo alergenos no se esconde ninguno
    @IBAction func IngredientesBtn(_ sender: Any) {
        self.VistaAlergenos.isHidden = true
        self.VistaDescripcion.isHidden = true
    }
    
    @IBAction func DescriptionBtn(_ sender: Any) {
        self.VistaAlergenos.isHidden = true
        self.VistaDescripcion.isHidden = false
    }
    
    @IBAction func AlergenosBt(_ sender: Any) {
        self.VistaDescripcion.isHidden = false
        self.VistaAlergenos.isHidden = false
    }
    
    @IBAction func CarritoBtn(_ sender: Any) {
        
        let id = detalles["id"] as! Int
        let imagen = detalles["image"] as! String
        let precio = detalles["cost"] as! String
        let nombre = detalles["name"] as! String
        
        let tarta = ["Id":id,"image":imagen,"precio":precio,"nombre":nombre, "cantidad":1] as [String : Any]
        
        if !defaults.bool(forKey: "logued"){
            let alert = UIAlertController(title: "¿Quieres más?", message: "¡Registrate para personalizar tu propia tarta!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                
                self.tabBarController?.selectedIndex = 4
            })
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        else{
            carrito.append(tarta)
            let alert = UIAlertController(title: "¡Genial!", message: "Tu tarta ha sido añadida al carrito", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            print(carrito)
        }

    }

    func getalergenos(id_ingrediente: Int){
            let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/allergeningredient/\(id_ingrediente)"
            
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
                    
                    print(cosas)
                    
                    DispatchQueue.main.async {
                        //Actualizo la tabla
                        self.alergenos.append(contentsOf: cosas["allergens"] as! [[String : Any]])
                        self.AlergenosTable.reloadData()
                    }
                    
                }
                catch{
                    print("Error: \(error)")
                }

            }.resume()
    }
    
    func getTarta(){
        
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/defaultcakeingredient/\(id_tarta)"
        
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
                
                //En detalles meto el resto de detalles de la tarta
                self.detalles = cosas
                
                //Y aqui saco los ingredientes a parte
                self.ingredientes = cosas["ingredients"] as! [[String : Any]]
                
                print(cosas)
                
                DispatchQueue.main.async {
                    //Actualizo la tabla
                    self.IngredientesTable.reloadData()
                    
                    //Aplico la imagen
                    let string = cosas["image"] as! String
                    guard let url = URL(string: string) else {return}
                    self.foto_tarta.load(url: url)
                    //Aplico nombre, descripcion y demases de la tarta
                    self.NombreTartaLabel.text = cosas["name"] as! String
                    self.DescriptionLabel.text = cosas["description"] as! String
                    self.precioLabel.text = "\(cosas["cost"] as! String) €"
                    
                    for i in 0...self.ingredientes.count - 1{
                        self.getalergenos(id_ingrediente: self.ingredientes[i]["id"] as! Int)
                    }
                }
            }
            catch{
                print("Error: \(error)")
            }

        }.resume()
    }
    
    
}
