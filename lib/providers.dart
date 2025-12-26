import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orderplus/data/order_repository.dart';
import 'package:orderplus/data/product_repository.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/data/sample_data.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final repo = OrderRepository();
  repo.addTables(List.generate(20, (i) => i + 1));
  return repo;
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final repo = ProductRepository();
  seedSampleProducts(repo);
  return repo;
});

final orderServiceProvider = Provider<OrderService>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return OrderService(repository: repo);
});

final productServiceProvider = Provider<ProductService>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductService(repo);
});

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
