import 'package:center_monitor/core/utils/debounce.dart';
import 'package:center_monitor/presentation/providers/center_search/center_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptiloAppBar extends StatelessWidget {
  const OptiloAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final centerSearchProvider = context.watch<CenterSearchProvider>();
    return centerSearchProvider.state.isSearching
        ? SearchDevice()
        : Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/images/map.png',
                  width: 50,
                  height: 50,
                ),
              ),
              Expanded(
                flex: 5,
                child: SizedBox(),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(centerSearchProvider.state.isSearching
                      ? Icons.close
                      : Icons.search),
                  onPressed: () {
                    centerSearchProvider.toggleSearch();
                  },
                ),
              ),
              SizedBox(width: 20),
            ],
          );
  }
}

class SearchDevice extends StatelessWidget {
  SearchDevice({super.key});
  final debounce = Debounce(millonseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(width: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<CenterSearchProvider>().toggleSearch();
              },
              icon: Icon(Icons.arrow_back_ios,
                  size: 20, color: Colors.black), // 아이콘 색상 검정
              label: SizedBox.shrink(), // 텍스트 없애기
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // 배경색을 흰색으로 설정
                foregroundColor: Colors.black, // 버튼 내 아이콘/텍스트 색상을 검정으로
                shadowColor: Colors.transparent, // 그림자 제거
                elevation: 0, // 버튼의 입체감을 없애고 Flat한 스타일로 만들기
                padding: EdgeInsets.zero, // 내부 패딩 최소화
                minimumSize: Size(30, 50), // 최소 크기 설정
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 터치 영역 최소화
                shape: RoundedRectangleBorder(
                  side: BorderSide.none, // 테두리 없애기
                ),
              ),
            ),
          ),
          searchDeviceTextField(context),
        ],
      ),
    );
  }

  SizedBox searchDeviceTextField(BuildContext context) {
    final TextEditingController _controller = TextEditingController(); //
    _controller.text = context.watch<CenterSearchProvider>().state.searchTerm;

    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.80,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          label: Text(
            '센터를 검색해주세요.',
            // textAlign: TextAlign.center, // 중앙 정렬
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)), // 둥근 테두리
            borderSide: BorderSide.none, // 기본 테두리 제거
          ),
          filled: true,
          // prefixIcon: Icon(Icons.search),
        ),
        onChanged: (String? newSearchTerm) {
          if (newSearchTerm != null) {
            debounce.run(
              () {
                context
                    .read<CenterSearchProvider>()
                    .setSearchTerm(newSearchTerm);
              },
            );
          }
        },
      ),
    );
  }
}