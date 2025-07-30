import SwiftUI

final class CreateViewController: UIHostingController<CreateView> {
    init() {
        super.init(rootView: CreateView())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not call")
    }
}
