import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/constants.dart'; // Assuming AppColors and AppTextStyles are defined here

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // START: Responsive Image Block using AspectRatio
          AspectRatio(
            aspectRatio: 16 / 9, // Image height is 9/16ths of its width
            child: Container(
              // The fixed 'height: 180,' is removed
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover, // Ensures image covers the area, scaling appropriately
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.broken_image,
                              color: Colors.red.shade400,
                              size: 50
                          ),
                          const SizedBox(height: 8),
                          Text('Image not found', style: AppTextStyles.bodySmall.copyWith(color: Colors.red.shade400)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // END: Responsive Image Block

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      '\$${product.price.toInt()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: product.price > 7000 ? Colors.red.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.price > 7000 ? 'High number' : 'Low number',
                    style: TextStyle(
                      fontSize: 10,
                      color: product.price > 7000 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}