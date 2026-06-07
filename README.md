# 智能日常助手（随记）

> 面向大学生的个人成长管家 + AI 情感陪伴助手。  
> 解决目标规划混乱、任务拖延、时间利用率低、情绪内耗等问题。  
> 移动开发技术课程期末项目 · Flutter 3.x + Provider + Hive + DeepSeek API

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6-0175C2?logo=dart)](https://dart.dev)
[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-NEXT-orange)](https://developer.harmonyos.com)

---

## 项目介绍

智能日常助手是一款专为大学生设计的个人效率与情感陪伴 App，围绕两大场景设计：

| 场景 | 解决的问题 |
|------|-----------|
| **时间事务管理** | 多门课程、考级备考、日常琐事并行 —— 提供目标规划、待办管理、日历视图、番茄钟专注 |
| **情绪生活陪伴** | 学业压力带来的焦虑、孤独 —— 提供私密生活圈和 AI 陪伴对话 |

数据在两大场景间流动，形成「目标拆解 → 任务执行 → 专注记录 → 统计反馈」和「动态倾诉 → AI 情绪识别 → 共情回复」的完整闭环。

---

## 功能特性

### 核心功能

- **目标管理** — 创建长期/短期目标，子目标拆解，进度百分比自动计算，截止日期提醒
- **待办 + 日历** — 新增/编辑/完成待办，月历视图（优先级颜色标记），与首页数据实时同步
- **番茄钟** — 默认 25 分钟或自定义时长，可绑定待办任务，完成后自动标记待办完成
- **私密生活圈** — 发布图文动态（含 5 种心情标签），AI 自动生成共情评论，支持多轮追问
- **AI 陪伴对话** — 基于 DeepSeek 的多轮文字对话，温暖、正向、简短回复风格

### 辅助功能

- **数据统计** — 本周完成率、专注时长、近 7 天趋势柱状图
- **个人信息管理** — 头像/昵称/账号/签名编辑，头像更换
- **深色模式** — 一键切换，重启保持
- **本地通知** — 7 种通知类型（待办提醒、目标截止、每日小结、连续专注鼓励等）
- **全局持久化** — Hive + SharedPreferences，杀进程数据不丢失

---

## 技术栈

| 类别 | 技术 |
|------|------|
| 框架 | Flutter 3.x、Dart 3.6 |
| 状态管理 | Provider 6.1 |
| 本地存储 | Hive 2.2（6 个 Box）+ SharedPreferences 2.3（5 个 Key） |
| 网络请求 | HTTP 1.2 → DeepSeek Chat Completion API |
| 本地通知 | flutter_local_notifications 18.0 |
| 日期处理 | intl 0.19 |
| 图片选取 | image_picker 1.1 |
| 文件管理 | path_provider 2.1 |
| UI | Material Design 3 + 深色模式 + 响应式布局 |
| 平台 | Android（最低 API 21）、HarmonyOS NEXT |

---

## 快速开始

### 环境要求

- Flutter SDK 3.x（Dart 3.6）
- Android Studio / VS Code + Flutter 插件
- Android 设备或模拟器（API 21+）
- Git

### 克隆项目

```bash
git clone <your-repo-url>
cd FlutterApplication/flutter_harmonyos
```

### 安装依赖

```bash
flutter pub get
```

### 配置 DeepSeek API Key（可选）

API Key 通过编译参数传入，不写死在代码中：

```bash
# Android
flutter run --dart-define=DEEPSEEK_API_KEY=your_api_key_here
```

如果不配置 API Key，AI 对话功能会自动返回降级文案，不影响其他功能使用。

### 运行项目

```bash
# 静态分析（确保零错误）
flutter analyze

# 在已连接的 Android 设备/模拟器上运行
flutter run
```

### 构建 APK

```bash
flutter build apk --release --dart-define=DEEPSEEK_API_KEY=your_api_key_here
```

APK 生成在 `build/app/outputs/flutter-apk/app-release.apk`。

---

## 项目结构

```
flutter_harmonyos/
├── lib/
│   ├── main.dart                  # 入口：Provider 注册、Hive 初始化、主题配置
│   ├── models/                    # 数据模型（纯 Dart，含序列化）
│   │   ├── todo.dart              # 待办事项
│   │   ├── goal.dart              # 目标 + 子目标
│   │   ├── user_profile.dart      # 用户信息
│   │   ├── pomodoro_record.dart   # 番茄钟记录
│   │   ├── post.dart              # 生活动态（含 AI 回复线程）
│   │   └── chat_session.dart      # AI 对话会话（含 ChatMessage）
│   ├── providers/                 # 状态管理（ChangeNotifier）
│   │   ├── theme_provider.dart    # 深色模式
│   │   ├── todo_provider.dart     # 待办（首页 + 日历共享）
│   │   ├── goal_provider.dart     # 目标 + 子目标
│   │   ├── user_provider.dart     # 用户信息
│   │   ├── pomodoro_provider.dart # 番茄钟记录 + 统计
│   │   └── life_provider.dart     # 动态 + AI 对话
│   ├── services/                  # 外部接口封装
│   │   ├── deepseek_service.dart  # DeepSeek API（对话 + 每日小结）
│   │   └── notification_service.dart # 7 种本地通知
│   ├── routes/                    # 路由管理
│   │   ├── app_routes.dart        # 9 条路由常量
│   │   └── app_router.dart        # onGenerateRoute 实现
│   └── pages/                     # 13 个页面
│       ├── main_shell.dart        # 底部导航容器（4 Tab + IndexedStack）
│       ├── home/home_page.dart    # 首页：问候语、待办概览、番茄钟入口、目标网格
│       ├── calendar/              # 日历模块
│       │   ├── calendar_page.dart     # 月视图 + 日详情
│       │   ├── todo_form_page.dart    # 新增/编辑待办
│       │   ├── todo_detail_page.dart  # 待办详情
│       │   ├── goal_form_page.dart    # 新增/编辑目标
│       │   └── goal_detail_page.dart  # 目标详情 + 子目标管理
│       ├── life/                  # 生活模块
│       │   ├── life_page.dart         # 动态时间线 + AI 聊天（TabBar）
│       │   ├── post_form_page.dart    # 发布动态（文字 + 图片 + 心情）
│       │   └── post_detail_page.dart  # 动态详情 + AI 多轮追问
│       ├── profile/               # 个人中心
│       │   ├── profile_page.dart          # 统计卡片 + 设置列表 + 今日成就
│       │   ├── profile_edit_page.dart     # 个人信息编辑（带保存）
│       │   ├── notification_settings_page.dart # 通知开关管理
│       │   └── usage_stats_page.dart      # 数据统计看板
│       └── pomodoro/pomodoro_page.dart    # 番茄钟（待办绑定 + 计时控制）
├── assets/icon/app_icon.png       # App 图标
├── pubspec.yaml                   # 依赖配置
├── analysis_options.yaml          # Lint 规则
└── README.md
```

**关键目录说明**：

| 目录 | 职责 |
|------|------|
| `models/` | 纯 Dart 数据对象，含 `toJson()`/`fromJson()`，不依赖框架 |
| `providers/` | 持有应用状态，暴露读写接口给 UI，调用 Service 层持久化 |
| `services/` | 封装外部调用（HTTP、通知），被 Provider 调用 |
| `pages/` | UI 渲染 + 用户交互，只通过 Provider 读写数据 |

---

## 开发指南

### 分层架构

```
Page  →  Provider  →  Service  →  Hive / HTTP
  ↓        ↓           ↓
Models   Models      Models
```

- **Page** 层：只用 `context.watch<T>()` / `context.read<T>()` 消费 Provider，不直接访问 Hive 或发 HTTP
- **Provider** 层：持有内存数据，提供增删改接口，每次修改后持久化 + `notifyListeners()`
- **Service** 层：封装 DeepSeek API 调用和通知发送
- **Model** 层：纯 Dart 对象，所有层共享

### 数据持久化

使用 **Hive** 存储结构化数据（6 个 Box）+ **SharedPreferences** 存储设置（5 个 Key）：

| 存储 | 内容 |
|------|------|
| Box `todos` | 待办列表 |
| Box `goals` | 目标 + 子目标 |
| Box `user_profile` | 用户信息（单条） |
| Box `pomodoro_records` | 番茄钟记录 |
| Box `posts` | 动态 + AI 回复 |
| Box `chat_sessions` | AI 对话历史 |
| SP `theme_mode` | 深色模式开关 |
| SP `pomodoro_default` | 番茄钟默认分钟数 |
| SP `day_summary` | 每日小结通知开关 |
| SP `todo_reminder` | 待办提醒通知开关 |
| SP `goal_reminder` | 目标截止提醒通知开关 |

### Provider 数据流

| Provider | 持有的数据 | 消费页面 |
|----------|----------|---------|
| ThemeProvider | ThemeMode | ProfilePage, 全局 |
| TodoProvider | List\<Todo\> | HomePage, CalendarPage, PomodoroPage, ProfilePage, UsageStatsPage |
| GoalProvider | List\<Goal\> | HomePage, GoalDetailPage, GoalFormPage |
| UserProvider | UserProfile | HomePage, ProfilePage, ProfileEditPage |
| PomodoroProvider | List\<PomodoroRecord\> | CalendarPage, PomodoroPage, ProfilePage, UsageStatsPage |
| LifeProvider | List\<Post\>, ChatSession | LifePage, PostFormPage, PostDetailPage |

### 路由表

| 路由 | 页面 | 参数 |
|------|------|------|
| `/` | MainShell（根容器） | — |
| `/pomodoro` | 番茄钟 | `int?` 自定义分钟数 |
| `/todoForm` | 新增待办 | `Map{'date': DateTime}?` |
| `/todoDetail` | 待办详情 | `String` 待办 ID |
| `/goalForm` | 新增目标 | — |
| `/goalDetail` | 目标详情 | `String` 目标 ID |
| `/postForm` | 发布动态 | — |
| `/postDetail` | 动态详情 | `Map` |
| `/profileEdit` | 编辑个人信息 | — |
| `/notificationSettings` | 通知设置 | — |
| `/usageStats` | 使用统计 | — |

### 开发命令

```bash
flutter pub get          # 安装依赖
flutter analyze          # 静态分析（保持零错误）
flutter run              # 运行到设备
flutter build apk        # 构建 APK
flutter clean            # 清理构建缓存
```

---

## 许可证

本项目仅用于学习和课程演示目的。

---

## 相关文档

- [功能文档.md](./功能文档.md) — 功能设计（业务规则、流程、异常处理、验收标准）
- [开发文档.md](./开发文档.md) — 页面设计、交互说明、UI 布局
