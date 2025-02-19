import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  static const String routeName = '/my';
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('설정'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10, child: Divider()),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '계정 정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // 테두리 색상
                      width: 1.5, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(12), // 테두리 둥글게 만들기
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        print('click');
                      },
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                                'assets/icons/background.jpeg'), // 프로필 이미지
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '사용자 이름',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                const Text('ID: user@example.com'),
                              ],
                            ),
                          ),
                          Expanded(child: Icon(Icons.keyboard_arrow_right))
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('로그아웃'),
                  onTap: () {
                    // 로그아웃 기능 추가 가능
                  },
                ),
                const SizedBox(height: 20, child: Divider()),
                Text(
                  '앱 정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: const Icon(Icons.announcement),
                  title: const Text('공지 사항'),
                  onTap: () {
                    // 로그아웃 기능 추가 가능
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.verified_user_outlined),
                  title: const Text('버전'),
                  onTap: () {
                    // 로그아웃 기능 추가 가능
                  },
                ),
                const SizedBox(height: 20, child: Divider()),
                Text(
                  '앱 사용자 설정',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: const Icon(Icons.monitor),
                  title: const Text('화면 스타일'),
                  onTap: () {
                    // 로그아웃 기능 추가 가능
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


            //  const SizedBox(
            //           height: 10,
            //           child: Divider(),
            //         ),
            //         ListTile(
            //           leading: const Icon(Icons.announcement),
            //           title: const Text('공지 사항'),
            //           onTap: () {
            //             // 프로필 수정 기능 추가 가능
            //           },
            //         ),

                       //      ListTile(
                //   leading: const Icon(Icons.logout),
                //   title: const Text('로그아웃'),
                //   onTap: () {
                //     // 로그아웃 기능 추가 가능
                //   },
                // ),

                //      ListTile(
                //   leading: const Icon(Icons.logout),
                //   title: const Text('회원탈퇴'),
                //   onTap: () {
                //     // 로그아웃 기능 추가 가능
                //   },
                // ),