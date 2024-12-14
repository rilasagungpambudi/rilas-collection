import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String author;
  final String isbn;
  final VoidCallback onTap;

  const BookCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.author,
    required this.isbn,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 2.75, // Gambar persegi
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      imagePath,
                    ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
