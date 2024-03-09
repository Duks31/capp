import "package:capp/auth/auth_service.dart";
import "package:capp/components/my_button.dart";
import "package:capp/components/my_textfield.dart";
import "package:flutter/material.dart";

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function()? onTap;

  Future<void> login(BuildContext context) async {
    //auth service

    final authservice = AuthService();

    // try login
    try {
      await authservice.signInWithEmailAndPassword(
        _emailController.text, 
        _passwordController.text
      );
    }

    // catch any errors
    catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),);
    }
  }
  
  LoginPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message, 
            size: 60, 
            color: Theme.of(context).colorScheme.primary, 
          ),

          const SizedBox(height: 50), 

          Text("Welcome Back, you have been missed!",
          style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
          ),),

          const SizedBox(height: 25),

          MyTextField(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(height: 15),

          MyTextField(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
          ),

          const SizedBox(height: 15),
        
          MyButton(
            text: "Login", 
            onTap: () => login(context),
          ),

          const SizedBox(height: 25), 

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Not a member?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                )
              ),
              GestureDetector(
                onTap: onTap, 
                child: Text("Register now", 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
                ),
              ) 
            ],
          )
        ],
      )
    );
  }
}
