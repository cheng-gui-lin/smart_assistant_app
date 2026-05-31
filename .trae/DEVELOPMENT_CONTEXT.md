# 智能日常助手 — 开发记忆文档

> 📖 **配套文档**：架构/数据库/数据流 → `../README.md` · 功能需求 → `../功能文档.md` · 页面导航 → `../开发文档.md`

---

## 一、快速启动

**项目根目录**：`d:\HarmonyOS\FlutterApplication\flutter_harmonyos`

```bash
cd d:\HarmonyOS\FlutterApplication\flutter_harmonyos
flutter pub get
flutter analyze    # 当前 0 错误
flutter run
```

**当前依赖（pubspec.yaml）**：`provider` `hive` `hive_flutter` `intl` `http`

---

## 二、当前代码状态

### ✅ 已完成（可直接用）

- 6 个 Provider 中 5 个已实现 + 完整业务逻辑（ThemeProvider / TodoProvider / GoalProvider / UserProvider / PomodoroProvider）
- 13 个页面全部有 UI，数据在 Provider 的 `_initMockData()` 中硬编码
- 路由系统 9 条路由 + `onGenerateRoute` 完整
- 深色模式 / 首页礼貌用语 / 日历月视图 / 番茄钟待办绑定 / 目标子目标编辑 / 个人设置保存 / 专注统计环图
- `flutter analyze` 零错误

### ❌ 缺失（待开发，6 个新文件 + 3 个页面改造）

| 文件 | 类型 | 说明 |
|------|------|------|
| `models/post.dart` | 🆕 | Post 模型（content / moodEmoji / moodLabel / imagePaths / aiComment / createdAt） |
| `models/chat_session.dart` | 🆕 | ChatSession 模型（title / createdAt / List\<ChatMessage\> 内嵌） |
| `providers/life_provider.dart` | 🆕 | 管理 Post 列表 + ChatSession 列表，含 `addPost()` 和 `sendToAI()` |
| `services/deepseek_service.dart` | 🆕 | DeepSeek API 调用（chatText / chatWithImage / generateDailySummary） |
| `services/notification_service.dart` | 🆕 | 7 种本地通知 |
| `services/image_service.dart` | 🆕 | 图片选取/压缩/裁剪/保存 |
| `pages/life/life_page.dart` | 🔧 | 从硬编码改为 `context.watch<LifeProvider>` |
| `pages/life/post_form_page.dart` | 🔧 | 增加图片选取/上传流程 |
| `pages/life/post_detail_page.dart` | 🔧 | 从 LifeProvider 读取真实 Post |

---

## 三、开发顺序（严格按此执行）

### Phase 1：Model 层（基础设施）

**第一步** — `models/post.dart`：
```dart
class Post {
  String id;           // DateTime.now().millisecondsSinceEpoch.toString()
  String content;
  String moodEmoji;    // 😊😐😰😫😢
  String moodLabel;    // 开心/平静/焦虑/疲惫/难过
  List<String>? imagePaths;  // 图片本地文件名列表
  String? aiComment;
  DateTime createdAt;
}
```

**第二步** — `models/chat_session.dart`：
```dart
class ChatMessage {    // 内嵌，不独立文件
  String role;         // 'user' | 'ai'
  String content;
  String? imagePath;
  DateTime timestamp;
}

class ChatSession {
  String id;
  String title;        // 第一条用户消息截断 20 字
  DateTime createdAt;
  List<ChatMessage> messages;  // 内嵌
}
```

### Phase 2：Service 层（后端封装）

**第三步** — `services/deepseek_service.dart`：
- `chatText(String userMessage, {String? systemPrompt})` → HTTP POST
- `chatWithImage(String text, String imageBase64, String moodLabel)` → 多模态 POST
- `detectEmotion(String text)` → 本地规则引擎（不调 API）
- 端点：`POST https://api.deepseek.com/v1/chat/completions`
- 超时 10s，失败降级返回预设文字

**第四步** — `services/image_service.dart`：
- `pickFromCamera()` / `pickFromGallery()` → 调 `image_picker`
- `saveToAppDir(File image)` → 复制到 `getApplicationDocumentsDirectory()/posts/`，返回文件名
- `deleteImage(String fileName)` → 删除文件
- 权限：相机 + 存储，被拒时 SnackBar 提示

**第五步** — `services/notification_service.dart`：
- 7 种通知，详情见 README 第八章

### Phase 3：Provider 层（状态接入）

**第六步** — `providers/life_provider.dart`：
```dart
class LifeProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<ChatSession> _chatSessions = [];
  ChatSession? _currentSession;

  List<Post> get posts => _posts..sort((a,b) => b.createdAt.compareTo(a.createdAt));
  List<ChatSession> get chatSessions => _chatSessions;
  ChatSession? get currentSession => _currentSession;

  // 动态发布（写入 Hive → 调 DeepSeek 多模态 → 回写 aiComment → 通知 UI）
  void addPost(String content, String moodEmoji, String moodLabel, [List<String>? imageNames]);

  // AI 对话（追加 userMsg → 取最近 20 条 history → 调 DeepSeek → 追加 aiMsg → 通知 UI）
  void sendToAI(String sessionId, String text);

  void createSession(String firstMessage);
  void switchSession(String sessionId);
  void deleteSession(String id);
  void deletePost(String id);
}
```

### Phase 4：页面改造

**第七步** — `pages/life/life_page.dart`：
- `_FeedTab`：`context.watch<LifeProvider>().posts` 替换硬编码 `_posts`
- `_AIChatTab`：`context.watch<LifeProvider>().currentSession?.messages` 替换局部 `_messages`
- 增加会话切换器和"新建对话"按钮

**第八步** — `pages/life/post_form_page.dart`：
- 新增正方形图片预览区（点击弹出拍照/相册选择）
- "上传"按钮：选图前禁用，上传中显示进度
- 发布按钮：调用 `LifeProvider.addPost()`

**第九步** — `pages/life/post_detail_page.dart`：
- 通过 `goalId` 从 `LifeProvider` 读取真实 Post 数据

### Phase 5：Hive 持久化（已有 Provider 接入存储）

**第十步** — 为 5 个已有 Provider 接入 Hive 读写：
- 每个 Provider 构造时从 `Hive.box()` 加载数据（无数据降级 Mock）
- 每次增删改后 `box.put()` 写入 Hive

**第十一步** — `main.dart` 扩展：
- 注册 7 个 TypeAdapter + 打开 6 个 Box
- `MultiProvider` 中注册 `LifeProvider`
- 初始化通知插件

### Phase 6：通知与交付

**第十二步** — 通知集成 + APK 构建 + 演示视频

---

## 四、核心数据流示例（供参考）

### 发布图文动态的完整链路

```
PostFormPage.发布()
  → LifeProvider.addPost(content, mood, imageNames)
     → 1. new Post(id, content, mood, imageNames, null, now)
     → 2. Hive.box<Post>('posts').put(id, post)
     → 3. notifyListeners() — UI 先显示动态（aiComment 为空）
     → 4. DeepSeekService.chatWithImage(content, imageBase64, moodLabel)
          POST messages: [{system:"用户发动态..."}, {user: text + image_url}]
     → 5. post.aiComment = response
     → 6. Hive.box<Post>('posts').put(id, post) — 回写
     → 7. notifyListeners() — UI 刷新显示 AI 评论
```

### AI 多轮对话的完整链路

```
_AIChatTab.发送(text)
  → LifeProvider.sendToAI(sessionId, text)
     → 1. session = Hive.box<ChatSession>('chat_sessions').get(sessionId)
     → 2. session.messages.add(ChatMessage(role:'user', content:text))
     → 3. box.put(sessionId, session)
     → 4. history = session.messages.takeLast(20).map(...)
     → 5. DeepSeekService.chatText(history)
     → 6. session.messages.add(ChatMessage(role:'ai', content:response))
     → 7. box.put(sessionId, session)
     → 8. notifyListeners()
```

---

## 五、关键约束

1. **代码风格**：不添加注释（除非必须），匹配现有代码的命名和缩进
2. **Provider 隔离**：Provider 间不互相调用（仅 LifeProvider 通过 DeepSeekService 发 HTTP 是例外）
3. **ChatMessage 不独立文件**：内嵌在 `chat_session.dart` 中，类比 SubGoal 内嵌于 Goal
4. **图片存文件系统**：Hive 的 `Post.imagePaths` 只存文件名，本体在文档目录
5. **SharedPreferences 存设置**：5 个 key（theme_mode / pomodoro_default / day_summary / todo_reminder / goal_reminder）
6. **DeepSeek API Key**：先硬编码占位符，注释标注 `// TODO: 替换为真实 API Key`
7. **提交前跑 `flutter analyze`**：确保零错误零警告
