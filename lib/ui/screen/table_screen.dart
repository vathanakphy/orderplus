import 'package:flutter/material.dart';
import 'package:orderplus/domain/service/order_service.dart';
import 'package:orderplus/domain/service/product_service.dart';
import 'package:orderplus/ui/widget/cards/flexible_image.dart';
import '../widget/cards/table_card.dart';
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

  void _addTable() async {
    final newId = widget.orderService.tables.isEmpty
        ? 1
        : widget.orderService.tables.last + 1;
    await widget.orderService.addTable(newId);
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
      await widget.orderService.removeTable(tableId);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Table $tableId deleted")));
      }
      setState(() {});
    }
  }

  void _openOrder(int tableId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(
          tableId: tableId,
          orderService: widget.orderService,
          productService: widget.productService,
        ),
      ),
    );
    setState(() {});
  }

  Color _getStatusColor(int tableId) =>
      widget.orderService.isTableBusy(tableId) ? Colors.orange : Colors.green;

  String _getStatusLabel(int tableId) =>
      widget.orderService.isTableBusy(tableId) ? "Busy" : "Available";

  @override
  Widget build(BuildContext context) {
    final allTables = widget.orderService.tables;
    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FlexibleImage(
                  imagePath: "assets/app_logo.png",
                  fit: BoxFit.fitWidth,
                  width: 150,
                ),
              ),
              IconButton(
                icon: Icon(isEditMode ? Icons.close : Icons.edit),
                onPressed: () => setState(() => isEditMode = !isEditMode),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                // Pickup
                TableCard(
                  label: "Pickup",
                  statusColor: Colors.white,
                  color: Colors.deepOrange,
                  icon: Icons.shopping_bag_rounded,
                  titleColor: Colors.white,
                  onTap: () => _openOrder(-1),
                ),
                ...allTables.map((tableId) {
                  return TableCard(
                    label: "Table $tableId",
                    statusLabel: _getStatusLabel(tableId),
                    statusColor: _getStatusColor(tableId),
                    onTap: () => _openOrder(tableId),
                    showEditOverlay: isEditMode,
                    onDeleteTap: () => _deleteTable(tableId),
                  );
                }),
              ],
            ),
          ),
        ),
        if (isEditMode)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FloatingActionButton(
              onPressed: _addTable,
              child: const Icon(Icons.add),
            ),
          ),
      ],
    );
  }
}
