import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meal_ver2/viewmodel/MainViewModel.dart';

class SelectBibleView extends StatefulWidget {
  @override
  _SelectBibleViewState createState() => _SelectBibleViewState();
}

class _SelectBibleViewState extends State<SelectBibleView> {
  // 선택 상태를 저장하는 변수
  Map<String, bool> selectedBibles = {
    '개역개정.json': false,
    '개역한글.json': false,
  };

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Bibles"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: selectedBibles.keys.map((String bible) {
                return CheckboxListTile(
                  title: Text(bible),
                  value: selectedBibles[bible],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedBibles[bible] = value ?? false;  // 체크박스 상태 업데이트
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // 선택된 파일들만 리스트로 필터링
                List<String> selectedFiles = selectedBibles.entries
                    .where((entry) => entry.value)  // 선택된 파일들만 필터링
                    .map((entry) => entry.key)
                    .toList();

                // 선택한 성경 파일들을 MainViewModel로 넘기고 처리
                //viewModel.loadMultipleBibles(selectedFiles);

                // 창 종료
                Navigator.pop(context);
              },
              child: Text('완료'),
            ),
          ),
        ],
      ),
    );
  }
}