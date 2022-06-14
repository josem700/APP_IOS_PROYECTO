//
//  ProductoCell.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 3/6/22.
//

import UIKit

class ProductoCell: UITableViewCell {

    @IBOutlet weak var Nombre_Producto_Label: UILabel!
    @IBOutlet weak var Precio_Producto_label: UILabel!
    @IBOutlet weak var Unidades_Produto_Label: UILabel!
    @IBOutlet weak var foto_producto: UIImageView!
    @IBOutlet weak var Subtotal_Label: UILabel!
    
    
    var currentUnidades: Int = 1{
            didSet{
                Unidades_Produto_Label.text = "\(currentUnidades)"
            }
        }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func masBtn(_ sender: Any) {
        currentUnidades += 1
        self.reloadInputViews()
    }
    
    @IBAction func menosBtn(_ sender: Any) {
        if currentUnidades > 1 {
            currentUnidades -= 1
            self.reloadInputViews()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
