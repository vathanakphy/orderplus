import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'order_screen.dart';

class TableScreen extends StatefulWidget {
  final OrderService orderService;
  final ProductService productService;
  const TableScreen({
    super.key,
    required this.orderService,
    required this.productService,
  });

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  int? activeTableId;
  final Map<int, List<OrderItem>> _tableCarts = {};

  void _addTable() {
    final newId = widget.orderService.tables.length + 1;
    widget.orderService.addTable(newId);
    setState(() {});
  }

  void _selectTable(int tableId) {
    setState(() => activeTableId = tableId);
    final existingOrders = widget.orderService.getOrdersByTable(tableId);
    if (existingOrders.isNotEmpty) {
      final combinedItems = <OrderItem>[];
      for (var order in existingOrders) {
        combinedItems.addAll(order.items);
      }
      _tableCarts[tableId] = combinedItems;
    } else {
      _tableCarts.putIfAbsent(tableId, () => []);
    }
  }

  void _closeOrder() => setState(() => activeTableId = null);

  Color _getStatusColor(int tableId) =>
      widget.orderService.isTableBusy(tableId) ? Colors.orange : Colors.green;

  String _getStatusLabel(int tableId) =>
      widget.orderService.isTableBusy(tableId) ? "Busy" : "Available";

  @override
  Widget build(BuildContext context) {
    final allTables = widget.orderService.tables;

    if (activeTableId != null) {
      return OrderScreen(
        tableId: activeTableId!,
        cartItems: _tableCarts[activeTableId!]!,
        onBack: _closeOrder,
        onCartUpdated: (items) => _tableCarts[activeTableId!] = items,
        orderService: widget.orderService,
        productService: widget.productService,
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Tables & Areas",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  GestureDetector(
                    onTap: () => _selectTable(-1),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text(
                          "Pickup",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...allTables.map((tableId) {
                    return GestureDetector(
                      onTap: () => _selectTable(tableId),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _getStatusColor(tableId),
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Table $tableId",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getStatusLabel(tableId),
                                style: TextStyle(
                                  color: _getStatusColor(tableId),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "addTableFab",
        onPressed: _addTable,
        child: const Icon(Icons.add),
      ),
    );
  }
}
