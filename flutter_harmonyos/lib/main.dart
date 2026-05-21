import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '商品推荐',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const ProductGridPage(),
    );
  }
}

class ProductGridPage extends StatelessWidget {
  const ProductGridPage({super.key});

  static const List<_Product> _products = [
    _Product(name: '简约双肩包', price: '¥129.00'),
    _Product(name: '无线蓝牙耳机', price: '¥259.00'),
    _Product(name: '复古台灯', price: '¥89.00'),
    _Product(name: 'ins风水杯', price: '¥39.00'),
    _Product(name: '简约手表', price: '¥199.00'),
    _Product(name: '皮革笔记本', price: '¥45.00'),
    _Product(name: '桌面收纳盒', price: '¥29.00'),
    _Product(name: '护眼台灯', price: '¥149.00'),
    _Product(name: '保温杯', price: '¥79.00'),
    _Product(name: '平板保护套', price: '¥59.00'),
    _Product(name: '运动手环', price: '¥169.00'),
    _Product(name: '桌面风扇', price: '¥99.00'),
    _Product(name: '手机支架', price: '¥19.00'),
    _Product(name: '便携充电宝', price: '¥139.00'),
    _Product(name: '蓝牙音箱', price: '¥299.00'),
    _Product(name: '鼠标垫', price: '¥25.00'),
    _Product(name: 'USB集线器', price: '¥49.00'),
    _Product(name: '书立架', price: '¥35.00'),
    _Product(name: '桌面时钟', price: '¥69.00'),
    _Product(name: '收纳挂袋', price: '¥42.00'),
  ];

  int _columnCount(double width) {
    if (width < 550) return 2;
    if (width < 900) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '商品推荐',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        elevation: 0.5,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _columnCount(constraints.maxWidth);
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) =>
                _ProductCard(product: _products[index]),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: const Color(0xFFF0F0F0),
              child: const Center(
                child: Icon(Icons.image_outlined,
                    size: 40, color: Color(0xFFCCCCCC)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.price,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Product {
  final String name;
  final String price;

  const _Product({required this.name, required this.price});
}
