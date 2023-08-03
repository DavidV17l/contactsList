import UIKit
import Eureka

final class CustomRow: Row<CustomCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<CustomCell>(nibName: "CustomCell")
    }
}
