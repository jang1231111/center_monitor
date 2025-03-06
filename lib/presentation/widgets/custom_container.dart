import 'package:center_monitor/config/constants/style.dart';
import 'package:flutter/material.dart';

Widget greyBorderNoShadowConatiner(Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: optiloGrey,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 254, 246, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    ),
  );
}

Widget greyBorderConatiner(Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: optiloGrey,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 254, 246, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white70,
              offset: Offset(-8, -8),
              blurRadius: 16,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black26, // 아래쪽 어두운 그림자
              offset: Offset(8, 8),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
    ),
  );
}

Widget blueBorderConatiner(Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: optiloBlue,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 254, 246, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white70,
              offset: Offset(-8, -8),
              blurRadius: 16,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black26, // 아래쪽 어두운 그림자
              offset: Offset(8, 8),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
    ),
  );
}

Widget dividerRowContainer() {
  return Container(
    height: 1,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Color(0xFFDDDDDD), // 살짝 어두운 배경색
      borderRadius: BorderRadius.circular(1),
      boxShadow: [
        BoxShadow(
          color: Colors.white, // 위쪽 하이라이트 효과
          offset: Offset(-1, -1),
          blurRadius: 1,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3), // 아래쪽 그림자
          offset: Offset(1, 1),
          blurRadius: 1,
        ),
      ],
    ),
  );
}

Widget dividerColumnContainer() {
  return Container(
    height: double.infinity, // 조금 더 두껍게
    width: 1,
    decoration: BoxDecoration(
      color: Color(0xFFDDDDDD), // 살짝 어두운 배경색
      borderRadius: BorderRadius.circular(1),
      boxShadow: [
        BoxShadow(
          color: Colors.white, // 위쪽 하이라이트 효과
          offset: Offset(-1, -1),
          blurRadius: 1,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3), // 아래쪽 그림자
          offset: Offset(1, 1),
          blurRadius: 1,
        ),
      ],
    ),
  );
}
