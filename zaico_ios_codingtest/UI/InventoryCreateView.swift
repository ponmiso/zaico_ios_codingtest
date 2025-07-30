import SwiftUI

struct InventoryCreateView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var adapter = InventoryCreateAdapter()
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("タイトル")
                TextField("", text: $adapter.title)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("InventoryCreateView_titleTextField")
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                adapter.didTapCreate()
            } label: {
                Text("作成する")
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.orange)
            }
            .accessibilityIdentifier("InventoryCreateView_createButton")
        }
        .alert("", isPresented: $adapter.isPresentedAlert, presenting: adapter.alertDetails) { details in
            Button("OK") {
                switch details.type {
                case .success:
                    dismiss()
                case .error:
                    break
                }
            }
        } message: { details in
            switch details.type {
            case let .success(message), let .error(message):
                Text(message)
            }
        }
        .onAppear { adapter.inject() }
    }
}

#Preview {
    InventoryCreateView()
}
