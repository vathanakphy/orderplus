import 'package:flutter/widgets.dart';
import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';

class AppDependencies extends InheritedWidget {
  final OrderRepository orderRepository;
  final ProductRepository productRepository;
  final OrderService orderService;
  final ProductService productService;

  AppDependencies({
    super.key,
    required super.child,
    required this.orderRepository,
    required this.productRepository,
  }) : orderService = OrderService(repository: orderRepository),
      productService = ProductService(productRepository);

  static AppDependencies of(BuildContext context) {
    final AppDependencies? result = context
        .dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(result != null, 'AppDependencies not found in widget tree');
    return result!;
  }

  @override
  bool updateShouldNotify(AppDependencies oldWidget) {
    return orderRepository != oldWidget.orderRepository ||
        productRepository != oldWidget.productRepository;
  }
}
