import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task7/main.dart';

void main() {
  group('E-Commerce App Tests', () {
    testWidgets('App should display the initial list of products', (
      WidgetTester tester,
    ) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const EcommerceApp());

      // Verify that the initial products from home_screen.dart are displayed
      expect(find.text('HP Laptop Core i7'), findsOneWidget);
      expect(find.text('Samsung Galaxy S23'), findsOneWidget);
      expect(find.text('iPhone 15'), findsOneWidget);
      // Verify prices are displayed
      expect(find.text('1099.99 Birr'), findsOneWidget);
    });

    testWidgets('User can add a new product and see it in the list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const EcommerceApp());

      // 1. Find the Floating Action Button (Add button) and tap it
      final addBtn = find.byIcon(Icons.add);
      await tester.tap(addBtn);

      // 2. Wait for the navigation animation to finish
      await tester.pumpAndSettle();

      // 3. Verify we are on the "Add Product" screen
      expect(find.text('Add Product'), findsOneWidget);

      await tester.tap(find.text('Create Product'));
      await tester.pump(); // Rebuild to show error text

      // Expect validation error
      expect(find.text('Enter a title'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Product Title'),
        'Gaming Mouse',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        'RGB Mouse',
      );
      await tester.enterText(find.widgetWithText(TextFormField, 'Price'), '50');

      // Submit the form
      await tester.tap(find.text('Create Product'));

      // Wait for the navigation back to home
      await tester.pumpAndSettle();

      // 4. Verify the new product appears in the list [cite: 51]
      expect(find.text('Gaming Mouse'), findsOneWidget);
      expect(find.text('50.00 Birr'), findsOneWidget);
    });

    testWidgets(
      'Tapping a product opens details, Back button returns to list',
      (WidgetTester tester) async {
        await tester.pumpWidget(const EcommerceApp());

        // 1. Tap on the "HP Laptop Core i7" item
        await tester.tap(find.text('HP Laptop Core i7'));

        // Wait for the slide animation
        await tester.pumpAndSettle();

        // Verify the specific detail title
        expect(find.text('HP Laptop Core i7'), findsOneWidget);
        // Verify a part of the description is visible
        expect(
          find.textContaining('An HP laptop with a Core i7 processor'),
          findsOneWidget,
        );

        // 3. Tap the Back Button in the AppBar
        await tester.tap(
          find.byTooltip('Back'),
        ); // Flutter default back button has tooltip 'Back'

        // Wait for animation
        await tester.pumpAndSettle();

        // 4. Verify we are back on the Home Screen
        expect(find.text('E-Commerce Products List'), findsOneWidget);
        expect(find.text('Samsung Galaxy S23'), findsOneWidget);
      },
    );
  });
}
