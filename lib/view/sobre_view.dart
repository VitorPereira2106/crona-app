import 'package:flutter/material.dart';

class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 28,
              color: Colors.black,
            ),
            SizedBox(width: 8),
            Text(
              'Sobre',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: []),
        ),
      ),
    );
  }
}
