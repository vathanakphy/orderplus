import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orderplus/providers.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/ui/screen/order_screen.dart';

class TableScreen extends ConsumerStatefulWidget {
  const TableScreen({super.key});

  @override
  ConsumerState<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
  int? activeTableId;
  final Map<int, List<OrderItem>> _tableCarts = {};

  void _addTable() {
    final orderService = ref.read(orderServiceProvider);
    final newId = orderService.tables.length + 1;
    orderService.addTable(newId);
    setState(() {});
  }

  void _selectTable(int tableId) {
    setState(() => activeTableId = tableId);
    if (!_tableCarts.containsKey(tableId)) _tableCarts[tableId] = [];
  }

  void _closeOrder() {
    setState(() => activeTableId = null);
  }

  Color _getStatusColor(OrderService service, int tableId) =>
      service.isTableBusy(tableId) ? Colors.orange : Colors.green;

  String _getStatusLabel(OrderService service, int tableId) =>
      service.isTableBusy(tableId) ? "Busy" : "Available";

  @override
  Widget build(BuildContext context) {
    final orderService = ref.watch(orderServiceProvider);
    final allTables = orderService.tables;

    // Show order screen if a table is active
    if (activeTableId != null) {
      return OrderScreen(
        tableId: activeTableId!,
        cartItems: _tableCarts[activeTableId!]!,
        onBack: _closeOrder,
        onCartUpdated: (items) => _tableCarts[activeTableId!] = items,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              GestureDetector(
                onTap: () => _selectTable(0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      "Walk-in / Takeaway",
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
                        color: _getStatusColor(orderService, tableId),
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
                            _getStatusLabel(orderService, tableId),
                            style: TextStyle(
                              color: _getStatusColor(orderService, tableId),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTable,
        child: const Icon(Icons.add),
      ),
    );
  }
}
