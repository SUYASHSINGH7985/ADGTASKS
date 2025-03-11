import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isShowingLogin: Bool // To dismiss the sheet
    @AppStorage("savedUsername") private var savedUsername = ""
    @AppStorage("savedPassword") private var savedPassword = ""
    
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var rememberMe = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "cart.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    HStack {
                        Toggle("Remember Me", isOn: $rememberMe)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .font(.caption)
                        Spacer()
                        Button("Forgot Password?") {
                            // Handle forgot password action
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                }
                .padding()
                
                Button(action: authenticateUser) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(username.isEmpty || password.isEmpty || isLoading)
                .opacity(username.isEmpty || password.isEmpty ? 0.6 : 1.0)
                
                Button("Continue as Guest") {
                    isLoggedIn = true
                    isShowingLogin = false // Dismiss the sheet
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    Button("Sign Up") {
                        isShowingLogin = false // Dismiss login sheet
                    }
                    .foregroundColor(.blue)
                }
                .font(.caption)
            }
            .padding()
        }
        .navigationTitle("Login")
    }
    
    func authenticateUser() {
        isLoading = true
        showError = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if username.isEmpty || password.isEmpty {
                errorMessage = "Username and password cannot be empty!"
                showError = true
            } else if username == savedUsername && password == savedPassword {
                isLoggedIn = true
                if rememberMe {
                    savedUsername = username
                    savedPassword = password
                }
                isShowingLogin = false // Dismiss the sheet
            } else {
                errorMessage = "Invalid username or password!"
                showError = true
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false), isShowingLogin: .constant(true))
}
