import SwiftUI

struct CreateView: View {
    @State private var title: String = ""
    @Environment(\.dismiss) var dismiss
    
    @State private var isPresentedAlert = false
    @State private var alertDetails: AlertDetails?
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("タイトル")
                TextField("", text: $title)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                createInventories()
            } label: {
                Text("作成する")
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.orange)
            }
        }
        .alert("", isPresented: $isPresentedAlert, presenting: alertDetails) { details in
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
    }
}

extension CreateView {
    private func createInventories() {
        if title.isEmpty {
            alertDetails = AlertDetails(type: .error("タイトルを入力してください"))
            isPresentedAlert = true
            return
        }
        Task {
            do {
                try await APIClient.shared.createInventories(title: title)
                alertDetails = AlertDetails(type: .success("在庫データの作成が完了しました"))
                isPresentedAlert = true
            } catch {
                alertDetails = AlertDetails(type: .error("登録に失敗しました：\(error.localizedDescription)"))
                isPresentedAlert = true
            }
        }
    }
}

extension CreateView {
    struct AlertDetails: Identifiable {
        let id = UUID()
        let type: AlertType
    }

    enum AlertType {
        case success(String)
        case error(String)
    }
}

#Preview {
    CreateView()
}
