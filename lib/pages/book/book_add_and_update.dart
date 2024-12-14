import 'package:bookcolection/global/widget/app_bar.dart';
import 'package:bookcolection/state/book_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class AddBookPage extends StatefulWidget {
  final Map<String, String>? bookData;

  const AddBookPage({Key? key, this.bookData}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.bookData != null) {
      _titleController.text = widget.bookData!['title'] ?? '';
      _isbnController.text = widget.bookData!['isbn'] ?? '';
      _yearController.text = widget.bookData!['year'] ?? '';
      _publisherController.text = widget.bookData!['publisher'] ?? '';
      _authorController.text = widget.bookData!['author'] ?? '';
      _synopsisController.text = widget.bookData!['synopsis'] ?? '';
      if (widget.bookData!['image'] != null) {
        _selectedImage = File(widget.bookData!['image']!);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic>? bookData = {
        'title': _titleController.text,
        'isbn': _isbnController.text,
        'year': _yearController.text,
        'publisher': _publisherController.text,
        'author': _authorController.text,
        'synopsis': _synopsisController.text,
        'image': _selectedImage?.path ?? '',
      };
      Provider.of<ProviderBook>(context, listen: false).addPost(data: bookData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(
        centerTitle: true,
        title: widget.bookData?['title'] != null ? 'Edit Book' : 'Add Book',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_selectedImage!,
                            width: 150, height: 220, fit: BoxFit.cover),
                      )
                    : Container(
                        width: 150,
                        height: 220,
                        color: Colors.grey[300],
                        child: const Icon(Icons.add_a_photo,
                            size: 50, color: Colors.white70),
                      ),
              ),
              const SizedBox(height: 16),
              _buildTextField(_titleController, 'Judul Buku'),
              const SizedBox(height: 12),
              _buildTextField(_isbnController, 'Kode Buku (ISBN)'),
              const SizedBox(height: 12),
              _buildTextField(_yearController, 'Tahun Terbit',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(_publisherController, 'Nama Penerbit'),
              const SizedBox(height: 12),
              _buildTextField(_authorController, 'Nama Penulis'),
              const SizedBox(height: 12),
              _buildTextField(_synopsisController, 'Sinopsis Buku',
                  maxLines: 5),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveBook,
                child: const Text('Save Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }
}
