import 'package:center_monitor/config/constants/style.dart';
import 'package:center_monitor/presentation/pages/main_page.dart';
import 'package:center_monitor/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  static const String routeName = '/navigation';
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _MainPageState();
}

class _MainPageState extends State<NavigationPage> {
  final repaintBoundary = GlobalKey();
  int _selectedIndex = 0; // 선택된 탭 인덱스

  // 탭에 따라 다른 화면을 보여주기 위한 리스트
  final List<Widget> _pages = [
    MainPage(), // 메인 화면
    SettingPage(), // 상세 페이지
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 탭 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: Color.fromRGBO(254, 246, 255, 1),
        child: SafeArea(
          top: true,
          bottom: false,
          child: Scaffold(
            body: _pages[_selectedIndex], // 선택된 페이지를 보여줌
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.device_thermostat_sharp),
                  label: 'Temperature',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Setting',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: optiloBlue, // 선택된 아이템 색상
              unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
              onTap: _onItemTapped, // 탭 클릭 시 호출되는 함수
            ),
          ),
        ),
      ),
    );
  }
}
