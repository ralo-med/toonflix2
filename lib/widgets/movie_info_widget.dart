import 'package:flutter/material.dart';

class MovieInfoWidget extends StatelessWidget {
  final String releaseDate;
  final int? runtime;
  final String tagline;

  const MovieInfoWidget({
    super.key,
    required this.releaseDate,
    this.runtime,
    required this.tagline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 개봉일과 러닝타임
        Row(
          children: [
            if (releaseDate.isNotEmpty)
              Expanded(
                child: Text(
                  'Release: $releaseDate',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            if (runtime != null)
              Expanded(
                child: Text(
                  'Runtime: ${runtime}min',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.end,
                ),
              ),
          ],
        ),
        if (tagline.isNotEmpty) ...[
          const SizedBox(height: 8),
          // 태그라인
          Text(
            '"$tagline"',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
