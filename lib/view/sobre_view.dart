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
              Icons.info,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Sobre',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec sit amet ex ante. Nunc aliquam lacinia ligula, venenatis pharetra orci faucibus id. Etiam suscipit vel nisl non aliquam. Vivamus iaculis nulla turpis, ut auctor neque molestie id. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque laoreet facilisis nunc, nec gravida tellus consectetur vitae. Donec consequat urna id ligula pharetra ultricies. Vivamus scelerisque purus nec enim commodo posuere. Nunc aliquam mauris elit, et fringilla nisi imperdiet et. Mauris semper massa metus, et facilisis erat mattis sagittis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi sapien ligula, elementum at imperdiet eget, mollis in tortor. Cras laoreet iaculis dolor vel eleifend. Ut ut arcu sit amet justo dictum tempus.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
