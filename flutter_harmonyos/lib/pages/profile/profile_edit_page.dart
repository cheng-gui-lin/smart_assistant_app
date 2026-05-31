import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_harmonyos/providers/user_provider.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nicknameController;
  late TextEditingController _accountController;
  late TextEditingController _bioController;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    final profile = context.read<UserProvider>().profile;
    _nicknameController = TextEditingController(text: profile.nickname);
    _accountController = TextEditingController(text: profile.account);
    _bioController = TextEditingController(text: profile.bio);
    if (profile.avatarBase64 != null) {
      _avatarBytes = base64Decode(profile.avatarBase64!);
    }
  }

  Future<void> _pickAvatar() async {
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

    final xFile = await _picker.pickImage(source: source);
    if (xFile == null) return;

    final bytes = await xFile.readAsBytes();
    setState(() {
      _avatarBytes = bytes;
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _accountController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    final userProvider = context.read<UserProvider>();
    if (_nicknameController.text.trim().isNotEmpty) {
      userProvider.updateNickname(_nicknameController.text.trim());
    }
    if (_accountController.text.trim().isNotEmpty) {
      userProvider.updateAccount(_accountController.text.trim());
    }
    userProvider.updateBio(_bioController.text.trim());
    if (_avatarBytes != null) {
      userProvider.updateAvatar(base64Encode(_avatarBytes!));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('编辑个人信息'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              '保存',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCCEB4),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x20F98C53),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _avatarBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.memory(
                              _avatarBytes!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.person_rounded,
                            size: 48, color: Color(0xFFF98C53)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF98C53),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('昵称', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(
                        hintText: '输入昵称',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('账号', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _accountController,
                      decoration: const InputDecoration(
                        hintText: '输入账号',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('个人签名', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _bioController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: '写一句签名...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF98C53),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text('保存修改',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
