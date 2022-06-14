//
//  CarritoViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 3/6/22.
//

import UIKit
import Alamofire
class CarritoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var SubtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var Finalizar: UIButton!
    @IBOutlet weak var ProductosTableView: UITableView!
    @IBOutlet weak var Botonfinalizar: UIButton!
    
    var currentSubtotal = 0.0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ProductosTableView.delegate = self
        self.ProductosTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ProductosTableView.reloadData()
        
        if carrito.isEmpty{
            Finalizar.isEnabled = false
        }
        else{
            Finalizar.isEnabled = true
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carrito.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "producto", for: indexPath) as! ProductoCell
    
        if carrito.count > 0 {
            
            cell.Nombre_Producto_Label.text = carrito[indexPath.item]["nombre"] as? String
            cell.Precio_Producto_label.text = carrito[indexPath.item]["precio"] as? String
            
            let urlString = carrito[indexPath.item]["image"] as? String
            
            if urlString != nil{
                guard let url = URL(string: urlString!) else {return cell}
                
                cell.foto_producto.load(url: url)
            }
            
            /// TO DO : Arreglar por aqui el tema de la cantidad
            guard let numStr = carrito[indexPath.item]["precio"] as? String else {
                return cell
            }
  
            let precio = Double(numStr)
                
            let subt = precio! * Double(cell.currentUnidades)
                
            print(subt)
            
            SubtotalLabel.text = "\(currentSubtotal + subt) €"
        
        }
        return cell
    }

    @IBAction func FinalizarBtn(_ sender: Any) {
        PedirCarrito(carritoPedido: carrito)
    }
    
    
    func PedirCarrito(carritoPedido: [[String:Any]]){
        
        var carritoVacio = [String:String]()
        
        for i in 0...carritoPedido.count - 1{
            carritoVacio["default_cake\(i)"] = "\(carritoPedido[i]["Id"] ?? "")"
        }
        
        let parametros:[String:Any] = [
            "user_id":defaults.object(forKey: "usuario_id"),
            "products":[
                "default_cake":carritoVacio
            ]
        ]
       
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/order"
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: parametros, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json{
            print(json)
        }
        
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.validate(statusCode: 200..<300)
        alamoRequest.responseString { response in
            print(response.result)
            
            if response.response?.statusCode == 201{
                let alert = UIAlertController(title: "¡Genial!", message: "¡Muchas Gracias por hacer tu pedido con nosotros, Disfruta :D!", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
                carrito.removeAll()
                carritoVacio.removeAll()
                self.Botonfinalizar.isEnabled = false
                self.ProductosTableView.reloadData()
            }
            else{
                let alert = UIAlertController(title: "¡Vaya!", message: "¡Parece que algo salio mal con tu pedido!, Comprueba que estas conectado a la red e intentalo de nuevo", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: {_ in
                    self.dismiss(animated: true)
                })
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}
