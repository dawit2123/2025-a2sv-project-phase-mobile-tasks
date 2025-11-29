import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/constants.dart';

// Assuming Product, AppColors, and AppTextStyles are defined elsewhere.

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Placeholder function for product deletion logic.
    void onDelete() {
      // Logic for deleting the product will go here
    }
    // Placeholder function for product update navigation.
    void onUpdate() {
      // Logic for navigating to the update screen will go here
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Page'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Scrollable content area.
      body: SingleChildScrollView(
        child: Center(
          // Center the content on wider screens.
          child: ConstrainedBox(
            // Limit the maximum width of the content block for desktop/tablet viewing.
            constraints: const BoxConstraints(
              maxWidth: 800.0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Section: centered and constrained.
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600.0,
                      ),
                      child: AspectRatio(
                        aspectRatio: 4 / 3, // Maintain image proportion.
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              // Display a broken image icon if the image asset fails to load.
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 80,
                                    color: AppColors.secondary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Product Name and Price Row: prevents horizontal overflow.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Allow the product name to take up available space and truncate if necessary.
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppTextStyles.headlineLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 12), // Separation between name and price.

                      // Price display, which maintains its required size.
                      Row(
                        children: [
                          // Original price with strike-through.
                          Text(
                            '\$${product.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Calculated price (e.g., final price).
                          Text(
                            '\$${(product.price * 1.2).toInt()}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Size:',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  // Wrap widget for displaying available sizes with appropriate spacing.
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: product.sizes.map((size) {
                      // Styled container for each size, highlighting a selected size (e.g., 40).
                      return Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          color: size == 40 ? AppColors.primary : Colors.white,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            size.toString(),
                            style: TextStyle(
                              color: size == 40 ? Colors.white : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  // Display the product description.
                  Text(
                    product.description,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 32),

                  // Responsive button group for actions.
                  Row(
                    children: [
                      // 1. DELETE Button: takes up half the available space.
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDelete,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text(
                            'DELETE',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // 2. UPDATE Button: takes up the other half of the available space.
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Add necessary padding at the bottom to clear the system's safe area (e.g., gesture bar).
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}