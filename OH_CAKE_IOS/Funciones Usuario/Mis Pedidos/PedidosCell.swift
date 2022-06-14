//
//  PedidosCell.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 26/5/22.
//

import UIKit

class PedidosCell: UITableViewCell {

    @IBOutlet weak var Num_Pedido_Label: UILabel!
    @IBOutlet weak var Estado_Pedido_Label: UILabel!
    @IBOutlet weak var Descripcion_Pedido_Label: UILabel!
    @IBOutlet weak var Fecha_Pedido_Label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
