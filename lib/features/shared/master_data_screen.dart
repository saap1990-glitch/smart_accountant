import 'package:flutter/material.dart';

class MasterDataScreen extends StatefulWidget {

  const MasterDataScreen({
    super.key,
    required this.title,
    required this.data,
    required this.columnKeys,
    required this.columnTitles,
    required this.onSave,
    required this.onDelete,
    required this.getItems,
    required this.refresh,
  });
  final String title;
  final List<Map<String, dynamic>> data;
  final List<String> columnKeys;
  final List<String> columnTitles;
  final Future<void> Function(Map<String, dynamic>) onSave;
  final Future<void> Function(int) onDelete;
  final List<Map<String, dynamic>> Function() getItems;
  final void Function() refresh;

  @override
  State<MasterDataScreen> createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends State<MasterDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  void _showForm([Map<String, dynamic>? existing]) {
    for (final key in widget.columnKeys) {
      _controllers[key] = TextEditingController(text: existing?[key]?.toString() ?? '');
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing != null ? 'تعديل' : 'إضافة'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.columnKeys.map((key) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TextFormField(
                    controller: _controllers[key],
                    decoration: InputDecoration(labelText: widget.columnTitles[widget.columnKeys.indexOf(key)]),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final data = <String, dynamic>{};
                for (final key in widget.columnKeys) {
                  data[key] = _controllers[key]!.text;
                }
                await widget.onSave(data);
                Navigator.pop(ctx);
                widget.refresh();
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: widget.data.isEmpty
          ? const Center(child: Text('لا توجد بيانات'))
          : ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (ctx, index) {
                final item = widget.data[index];
                return ListTile(
                  title: Text(item[widget.columnKeys.first]?.toString() ?? ''),
                  subtitle: Text(widget.columnKeys.skip(1).map((k) => '${widget.columnTitles[widget.columnKeys.indexOf(k)]}: ${item[k]}').join(' | ')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showForm(item)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await widget.onDelete(item['id'] as int);
                          widget.refresh();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
