import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Export extends StatelessWidget {
  const Export({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Project Manager',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          'Projects',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Import'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Export'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          'Evaluators',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Import'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Export'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
