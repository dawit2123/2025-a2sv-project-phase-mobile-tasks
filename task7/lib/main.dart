import 'package:flutter/material.dart';
import 'product_model.dart';
import 'home.dart';
import 'add_edit_product.dart';
import 'details.dart';

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Set a light background color for scaffolds
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      // Setting the initial route
      initialRoute: '/',

      // Implementing Named Routes with Custom Animations [cite: 11, 19]
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _animatedRoute(const HomeScreen());
          case '/details':
            // Extracting arguments passed to the route
            final product = settings.arguments as Product;
            return _animatedRoute(DetailsScreen(product: product));
          case '/add_edit':
            // Arguments might be null if adding a new product
            final product = settings.arguments as Product?;
            return _animatedRoute(AddEditProductScreen(product: product));
          default:
            return null;
        }
      },
    );
  }

  // Helper for Smooth Navigation Animations
  PageRouteBuilder _animatedRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
