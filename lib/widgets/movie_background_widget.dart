import 'package:flutter/material.dart';

class MovieBackgroundWidget extends StatelessWidget {
  final String backdropUrl;
  final Widget child;

  const MovieBackgroundWidget({
    super.key,
    required this.backdropUrl,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 이미지
        SizedBox.expand(
          child: Image.network(
            backdropUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF1A1A1A),
                child: const Icon(Icons.movie, color: Colors.grey, size: 100),
              );
            },
          ),
        ),
        // 어두운 오버레이
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        // 그라데이션 오버레이
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
        ),
        // 내용
        child,
      ],
    );
  }
}
