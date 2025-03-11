import SwiftUI

struct SignupView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isShowingSignup: Bool // To dismiss the sheet
    @AppStorage("savedUsername") private var savedUsername = ""
    @AppStorage("savedPassword") private var savedPassword = ""
    
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Create an Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()

                Button("Sign Up") {
                    signUpUser()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(username.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                .opacity(username.isEmpty || password.isEmpty || confirmPassword.isEmpty ? 0.6 : 1.0)
            }
            .padding()
        }
    }

    func signUpUser() {
        if username.isEmpty {
            errorMessage = "Username cannot be empty!"
            showError = true
        } else if password.isEmpty {
            errorMessage = "Password cannot be empty!"
            showError = true
        } else if password != confirmPassword {
            errorMessage = "Passwords do not match!"
            showError = true
        } else {
            savedUsername = username
            savedPassword = password
            isLoggedIn = true
            showError = false
            isShowingSignup = false // Dismiss the sheet
        }
    }
}

#Preview {
    SignupView(isLoggedIn: .constant(false), isShowingSignup: .constant(true))
}
