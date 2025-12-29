import 'package:flutter/material.dart';
import 'package:orderplus/domain/model/order_item.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/ui/widget/cards/table_card.dart';
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
  bool isEditMode = false;
  final Map<int, List<OrderItem>> _tableCarts = {};

  void _addTable() {
    final newId = widget.orderService.tables.isEmpty
        ? 1
        : widget.orderService.tables.last + 1;
    widget.orderService.addTable(newId);
    setState(() {});
  }

  void _deleteTable(int tableId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Table"),
        content: Text("Are you sure you want to delete Table $tableId?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      widget.orderService.removeTable(tableId);
      _tableCarts.remove(tableId);
      setState(() {});
    }
  }

  void _selectTable(int tableId) {
    setState(() => activeTableId = tableId);
    _tableCarts[tableId] = [];
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
      appBar: AppBar(
        title: const Text("Tables & Areas"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.close : Icons.edit),
            onPressed: () => setState(() => isEditMode = !isEditMode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            // Pickup tile
            TableCard(
              label: "Pickup",
              color: Colors.deepOrange,
              onTap: () => _selectTable(-1),
            ),
            ...allTables.map((tableId) {
              return TableCard(
                label: "Table $tableId",
                statusLabel: _getStatusLabel(tableId),
                statusColor: _getStatusColor(tableId),
                onTap: () => _selectTable(tableId),
                showEditOverlay: isEditMode,
                onDeleteTap: () => _deleteTable(tableId),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: isEditMode
          ? FloatingActionButton(
              onPressed: _addTable,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
