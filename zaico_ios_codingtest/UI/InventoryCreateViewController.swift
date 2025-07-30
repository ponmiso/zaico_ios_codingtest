import SwiftUI

final class InventoryCreateViewController: UIHostingController<InventoryCreateView> {
    init() {
        super.init(rootView: InventoryCreateView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not call")
    }
}
