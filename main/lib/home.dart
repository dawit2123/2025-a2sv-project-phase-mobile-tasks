import 'package:flutter/material.dart';
import 'product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data list
  List<Product> products = [
    Product(
      id: '1',
      name: 'HP Laptop Core i7',
      description:
          'An HP laptop with a Core i7 processor is a high-performance device designed for demanding tasks like multitasking, video editing, and gaming, featuring fast processors, ample memory (often 8GB to 32GB RAM), quick SSD storage, and high-resolution displays. Depending on the model, features can include dedicated or integrated graphics, a variety of ports (USB-C, Thunderbolt), fast Wi-Fi, and a backlit keyboard.',
      price: 999.99,
    ),
    Product(
      id: '2',
      name: 'Samsung Galaxy S23',
      description:
          'The Samsung Galaxy S23 is a smartphone with a 6.1-inch Dynamic AMOLED 2X display, powered by the Snapdragon 8 Gen 2 Mobile Platform for Galaxy. It features a versatile camera system with a 50MP main wide lens, an 8GB RAM, and storage options up to 512GB. Other features include a 3,900 mAh battery, IP68 water resistance, and a durable design with Gorilla Glass Victus 2.',
      price: 1299.00,
    ),
    Product(
      id: '3',
      name: 'iPhone 15',
      description:
          'The iPhone 15 is a 6.1-inch smartphone featuring an A16 Bionic chip, a USB-C port, and a Super Retina XDR display with Dynamic Island. It has a 48MP main camera with a 2x telephoto zoom, a durable design with color-infused matte back glass, and is rated IP68 for water and dust resistance. It runs on iOS 17 and uses Face ID for security. ',
      price: 1099.99,
    ),
  ];

  // Navigate to Add/Edit Screen and await result
  void _navigateToAddEdit({Product? product}) async {
    final result = await Navigator.pushNamed(
      context,
      '/add_edit',
      arguments: product, // Pass product if editing, null if adding
    );

    // Update list if data is returned from the other screen
    if (result != null && result is Product) {
      setState(() {
        int index = products.indexWhere((p) => p.id == result.id);
        if (index != -1) {
          // Update existing
          products[index] = result;
        } else {
          // Add new
          products.add(result);
        }
      });
    }
  }

  void _deleteProduct(String id) {
    setState(() {
      products.removeWhere((p) => p.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-Commerce Products List')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: Text(product.name),
              subtitle: Text('${product.price.toStringAsFixed(2)} Birr'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _navigateToAddEdit(product: product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(product.id),
                  ),
                ],
              ),
              // Navigate to Details Screen [cite: 9, 10]
              onTap: () {
                Navigator.pushNamed(context, '/details', arguments: product);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEdit(product: null), // Add new product
        child: const Icon(Icons.add),
      ),
    );
  }
}
