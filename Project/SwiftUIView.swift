import SwiftUI

struct SwiftUIView: View {
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var field3 = ""
    @State private var textSuccess = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        ZStack {
            Color(.black)
                .ignoresSafeArea(.all)
                .opacity(0.95)
            VStack(spacing: 20) {
                Text("Secret Mode 😘")
                    .font(.system(size: 35))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Text("\(textSuccess)")
                    .font(.title)
                    .foregroundColor(.white)
                HStack {
                    Text("Date")
                        .foregroundColor(.white)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Text("Time")
                        .foregroundColor(.white)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                HStack(spacing: 10) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .accentColor(.black)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .accentColor(.black)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                HStack {
                    Text("Detail")
                        .foregroundColor(.white)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                TextField("Detail", text: $field3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: .infinity, height: 10)
                ZStack {
                    Color(.orange)
                        .frame(width: 100, height: 50)
                        .cornerRadius(15)
                    Button(action: submitData) {
                        Text("Submit")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(5)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .padding()
        }
    }
    
    func submitData() {
        let url = URL(string: "Create a web app in AppScript and put it here.")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let parameters: [String: Any] = [
            "Date": dateFormatter.string(from: selectedDate),
            "Time": timeFormatter.string(from: selectedTime),
            "Detail": field3
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    textSuccess = "Success ✅"
                    field3 = ""
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                        dismiss()
                    })
                }
            } else {
                DispatchQueue.main.async {
                    textSuccess = "Failed ❌"
                }
            }
        }.resume()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

#Preview {
    SwiftUIView()
}
