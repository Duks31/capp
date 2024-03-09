import "package:capp/auth/auth_service.dart";
import "package:capp/components/my_button.dart";
import "package:capp/components/my_textfield.dart";
import "package:flutter/material.dart";

class RegisterPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void register(BuildContext context) {
    final _auth = AuthService();

    // password match create user
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        _auth.signUpWithEmailAndPassword(_emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),);
      }
    }
    else {
      showDialog(context: context, builder: (context) => const AlertDialog(
        title: Text("Password don't match"),
        ),
      );
    }
  }

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

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

          const SizedBox(height: 20), 

          Text("Lets create an account!",
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

          MyTextField(
            hintText: "Confirm Password",
            obscureText: true,
            controller: _confirmPasswordController,
          ),

          const SizedBox(height: 15),
        
          MyButton(
            text: "Register", 
            onTap: () => register(context),
          ),

          const SizedBox(height: 25), 

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                )
              ),
              GestureDetector(
                onTap: onTap,
                child: Text("Login now", 
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