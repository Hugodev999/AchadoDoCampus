import 'package:flutter/material.dart';
import 'app_database.dart';
import 'auth_page.dart';

class HomePage extends StatefulWidget {
  final String userEmail;
  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase _db = AppDatabase();
  final TextEditingController _itemController = TextEditingController();

  void _addNewItem() {
    if (_itemController.text.trim().isEmpty) return;

    setState(() {
      _db.addItem(widget.userEmail, _itemController.text.trim());
      _itemController.clear();
    });

    Navigator.pop(context);
  }

  void _showAddItemModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cadastrar Item Perdido/Achado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _itemController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Descreva o item e o local...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addNewItem,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
              child: const Text('Publicar Item', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = _db.getUserName(widget.userEmail);
    final items = _db.getItems(widget.userEmail);

    return Scaffold(
      appBar: AppBar(
        title: Text('Achados do Campus - $userName'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Nenhum item cadastrado.\nToque no botão abaixo para cadastrar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, color: Color(0xFF2563EB)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            items[index],
                            style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemModal,
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Novo Item', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}