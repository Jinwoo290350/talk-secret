import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var previousNumber: Double?
    @State private var currentOperation: String?
    @State private var specialSequence = false
    @State private var showSheet: Bool = false
    
    let buttons: [[String]] = [
        ["AC", "±", "%", "/"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        ZStack{
            Color(.black)
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Text(display)
                        .font(.system(size: 65))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                }
                Divider()
                ForEach(buttons, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.buttonTapped(button)
                            }) {
                                Text(button)
                                    .font(.largeTitle)
                                    .frame(width: button == "0" ? 172 : 80, height: 80)
                                    .background(self.buttonBackgroundColor(button))
                                    .cornerRadius(40)
                                    .padding(5)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSheet, content: {
            SwiftUIView()
        })
    }
    
    func buttonTapped(_ button: String) {
        switch button {
        case "0"..."9", ".":
            if display == "0" || display == "Error" {
                display = button
            } else {
                display += button
            }
        case "+", "-", "x", "/":
            if let number = Double(display) {
                // ตรวจสอบลำดับพิเศษ 789 +
                if number == 789 && button == "+" {
                    specialSequence = true
                } else {
                    specialSequence = false
                }
                previousNumber = number
                currentOperation = button
                display = "0"
            }
        case "=":
            if let number = Double(display), let previous = previousNumber, let operation = currentOperation {
                if specialSequence && number == 264 {
                    display = "Welcome 🕵🏻‍♂️"
                    if display == "Welcome 🕵🏻‍♂️" {
                        showSheet.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                            display = "0"
                            previousNumber = nil
                            currentOperation = nil
                            
                        })
                    }
                }
                else {
                    switch operation {
                    case "+":
                        display = String(previous + number)
                    case "-":
                        display = String(previous - number)
                    case "x":
                        display = String(previous * number)
                    case "/":
                        if number != 0 {
                            display = String(previous / number)
                        } else {
                            display = "Error"
                        }
                    default:
                        break
                    }
                }
                specialSequence = false
            }
            previousNumber = nil
            currentOperation = nil
        case "AC":
            display = "0"
            previousNumber = nil
            currentOperation = nil
        case "±":
            if let number = Double(display) {
                display = String(number * -1)
            }
        case "%":
            if let number = Double(display) {
                display = String(number / 100)
            }
        default:
            break
        }
    }
    
    func buttonBackgroundColor(_ button: String) -> Color {
        if ["AC", "±", "%"].contains(button) {
            return Color.gray
        } else if ["/", "x", "-", "+", "="].contains(button) {
            return Color.orange
        } else {
            return Color.grayyy
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
