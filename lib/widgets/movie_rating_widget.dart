import 'package:flutter/material.dart';

class MovieRatingWidget extends StatelessWidget {
  final double voteAverage;

  const MovieRatingWidget({
    super.key,
    required this.voteAverage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 평점에 따른 별 개수 계산 (최대 5개)
        ...List.generate(5, (index) {
          if (index < (voteAverage / 2).floor()) {
            return const Icon(Icons.star, color: Colors.amber, size: 22);
          } else if (index == (voteAverage / 2).floor() &&
              (voteAverage / 2) % 1 > 0) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 22);
          } else {
            return const Icon(Icons.star_border, color: Colors.amber, size: 22);
          }
        }),
        const SizedBox(width: 8),
        Text(
          '${voteAverage.toStringAsFixed(1)}/10',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
