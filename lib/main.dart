import 'package:flutter/material.dart';

void main() => runApp(const ExpenseTrackerApp());

// ─────────────────────────────────────────────
//  App
// ─────────────────────────────────────────────
class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00897B),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  Category enum
// ─────────────────────────────────────────────
enum Category { food, transport, shopping, health, entertainment, other }

extension CategoryInfo on Category {
  String get label {
    switch (this) {
      case Category.food:          return 'Food';
      case Category.transport:     return 'Transport';
      case Category.shopping:      return 'Shopping';
      case Category.health:        return 'Health';
      case Category.entertainment: return 'Entertainment';
      case Category.other:         return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.food:          return Icons.restaurant;
      case Category.transport:     return Icons.directions_car;
      case Category.shopping:      return Icons.shopping_bag;
      case Category.health:        return Icons.favorite;
      case Category.entertainment: return Icons.movie;
      case Category.other:         return Icons.category;
    }
  }

  Color get color {
    switch (this) {
      case Category.food:          return const Color(0xFFFF7043);
      case Category.transport:     return const Color(0xFF42A5F5);
      case Category.shopping:      return const Color(0xFFAB47BC);
      case Category.health:        return const Color(0xFFEF5350);
      case Category.entertainment: return const Color(0xFFFFCA28);
      case Category.other:         return const Color(0xFF78909C);
    }
  }
}

// ─────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────
class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    this.category = Category.other,
  });
}

// ─────────────────────────────────────────────
//  Home Screen
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController  = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  Category _selectedCategory = Category.food;

  final List<Transaction> _transactions = [
    Transaction(title: 'New Shoes',  amount: 450.0, date: DateTime.now(), category: Category.shopping),
    Transaction(title: 'Groceries',  amount: 120.5, date: DateTime.now(), category: Category.food),
    Transaction(title: 'Coffee',     amount: 15.0,  date: DateTime.now(), category: Category.food),
  ];

  void _deleteTransaction(int index) {
    setState(() => _transactions.removeAt(index));
  }

  void _showAddForm(BuildContext ctx) {
    _selectedCategory = Category.food;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text('New Expense',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Title field
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Expense Name',
                      hintText: 'e.g. Lunch',
                      prefixIcon: const Icon(Icons.edit_note),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Amount field
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount (DH)',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Category dropdown
                  DropdownButtonFormField<Category>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      prefixIcon: const Icon(Icons.label_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: Category.values.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Row(children: [
                        Icon(cat.icon, color: cat.color, size: 18),
                        const SizedBox(width: 8),
                        Text(cat.label),
                      ]),
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Submit button
                  FilledButton.icon(
                    onPressed: () {
                      if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;
                      final amount = double.tryParse(_amountController.text);
                      if (amount == null || amount <= 0) return;
                      setState(() {
                        _transactions.insert(0, Transaction(
                          title: _titleController.text,
                          amount: amount,
                          date: DateTime.now(),
                          category: _selectedCategory,
                        ));
                      });
                      _titleController.clear();
                      _amountController.clear();
                      Navigator.of(sheetCtx).pop();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Expense'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double total = _transactions.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        title: const Text('My Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Gradient Dashboard Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Text('Total Spent',
                  style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Text('${total.toStringAsFixed(2)} DH',
                  style: const TextStyle(
                    color: Colors.white, fontSize: 40,
                    fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_transactions.length} transaction${_transactions.length == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // ── Transaction list or empty state ──
          Expanded(
            child: _transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long, size: 72, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No expenses yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[500])),
                      const SizedBox(height: 4),
                      Text('Tap + to add one',
                        style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final tx = _transactions[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                      ),
                      onDismissed: (_) => _deleteTransaction(index),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: tx.category.color.withOpacity(0.15),
                            child: Icon(tx.category.icon, color: tx.category.color, size: 22),
                          ),
                          title: Text(tx.title,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          subtitle: Text(
                            '${tx.category.label}  •  ${tx.date.day}/${tx.date.month}/${tx.date.year}',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                          trailing: Text(
                            '-${tx.amount.toStringAsFixed(2)} DH',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddForm(context),
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}