import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_harmonyos/providers/life_provider.dart';

class PostFormPage extends StatefulWidget {
  const PostFormPage({super.key});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String _selectedMood = '😊';
  String _selectedMoodLabel = '开心';
  Uint8List? _selectedBytes;
  bool _isUploading = false;

  final List<Map<String, String>> _moods = [
    {'emoji': '😊', 'label': '开心'},
    {'emoji': '😐', 'label': '平静'},
    {'emoji': '😰', 'label': '焦虑'},
    {'emoji': '😫', 'label': '疲惫'},
    {'emoji': '😢', 'label': '难过'},
  ];

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final xFile = await _picker.pickImage(
      source: source,
    );
    if (xFile == null) return;

    final bytes = await xFile.readAsBytes();
    setState(() {
      _selectedBytes = bytes;
    });
  }

  Future<void> _publish() async {
    final content = _contentController.text.trim();
    if (content.isEmpty && _selectedBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入文字或添加图片再发布吧～')),
      );
      return;
    }

    setState(() => _isUploading = true);

    final provider = context.read<LifeProvider>();

    String? base64Image;
    if (_selectedBytes != null) {
      base64Image = base64Encode(_selectedBytes!);
    }

    await provider.addPost(
      content,
      _selectedMood,
      _selectedMoodLabel,
      base64Image: base64Image,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('动态已发布')),
      );
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPublish =
        (_contentController.text.trim().isNotEmpty || _selectedBytes != null) &&
            !_isUploading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('发布动态'),
        actions: [
          TextButton(
            onPressed: canPublish ? _publish : null,
            child: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFFF98C53)),
                  )
                : const Text('发布'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今天的心情怎么样？', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood['emoji'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood['emoji']!;
                      _selectedMoodLabel = mood['label']!;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primaryContainer
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(mood['emoji']!,
                            style: const TextStyle(fontSize: 28)),
                        Text(mood['label']!, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: '分享你的想法...',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('添加图片', style: theme.textTheme.titleSmall),
                const Spacer(),
                if (_selectedBytes != null)
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedBytes = null);
                    },
                    child: const Text('删除',
                        style:
                            TextStyle(color: Color(0xFFE57373), fontSize: 13)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: _isUploading ? null : _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: _selectedBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _selectedBytes!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                size: 32,
                                color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(height: 4),
                            Text('添加图片',
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
