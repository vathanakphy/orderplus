import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/data/sample_data.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';

// 1. Initialize Repositories
final OrderRepository orderRepository = OrderRepository();
final ProductRepository productRepository = ProductRepository();

void initializeData() {
  seedProducts(productRepository);  
  seedOrders(orderRepository, productRepository.products);
}

// 3. Initialize Services
final OrderService orderService = OrderService(repository: orderRepository);
final ProductService productService = ProductService(productRepository);