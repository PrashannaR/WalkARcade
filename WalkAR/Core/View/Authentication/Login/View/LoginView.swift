//
//  LoginView.swift
//  WalkAR
//
//  Created by Prashanna Rajbhandari on 01/10/2023.
//
import SwiftUI

struct LoginView: View {
    
    @State var username: String = ""
    @State var passowrd: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.white
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    greetingsText()
                    
                    TextFields()
                        .padding()
                    
                    NavigationLink(destination: HomeView()) {
                        CustomButton(title: "Sign In")
                    }
                    
                    Spacer()
                    
                    bottomText()
                        .onTapGesture {
                            //TODO: add auth code here
                        }
                    
                    
                }
                .padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            LoginView()
        }
    }
}


extension LoginView{
    private func greetingsText() -> some View{
        VStack(alignment: .leading) {
            Text("Hi There! 👋")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            Text("Welcome back, sign in to your account")
                .foregroundColor(Color.black.opacity(0.4))
                .padding(.top,2)
        }
    }
    
    private func bottomText() -> some View{
        HStack{
            Spacer()
            Text("Don't have an account?")
                .foregroundColor(Color.black.opacity(0.4))
                
            NavigationLink(destination: SignUp()) {
                Text("Sign Up")
                    .foregroundColor(Color.blue)
                    .bold()
            }
            
            Spacer()
        }
        .font(.footnote)
    }
    
    private func textFieldBackground() -> some View{
        RoundedRectangle(cornerRadius: 15)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .foregroundColor(Color.black.opacity(0.15))
    }
    
    private func TextFields() -> some View{
        VStack(alignment: .leading) {
            TextField("UserName", text: $username)
                .foregroundColor(.accentColor)
                .padding()
                .background{
                    textFieldBackground()
                }
                .padding(.top)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $passowrd)
                .foregroundColor(.accentColor)
                .padding()
                .background{
                    textFieldBackground()
                }
                .padding(.top)
        }
    }
}
