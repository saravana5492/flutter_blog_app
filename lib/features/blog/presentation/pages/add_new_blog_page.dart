import 'dart:io';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/image_picker.dart';
import 'package:blog_app/core/utils/snack_bar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/add_blog_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? selectedImage;

  void selectImage() async {
    final image = await pickImage();
    if (image != null) {
      selectedImage = image;
      setState(() {});
    }
  }

  void _uploadBlog() {
    if (formKey.currentState!.validate()) {
      if (selectedTopics.isEmpty) {
        showSnackBar(context, "Please select at least one topic.");
        return;
      } else if (selectedImage == null) {
        showSnackBar(context, "Please add image for the topic.");
        return;
      } else {
        final posterId =
            (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
        context.read<BlogBloc>().add(BlogUpload(
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: selectedImage!,
              topics: selectedTopics,
              posterId: posterId,
            ));
      }
    }
    return;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Blog"),
        actions: [
          IconButton(
            onPressed: _uploadBlog,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.message);
            } else if (state is BlogUploadSuccess) {
              Navigator.of(context).pop(true);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => selectImage(),
                        child: (selectedImage != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImage!,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : DottedBorder(
                                dashPattern: const [10, 4],
                                radius: const Radius.circular(10.0),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                color: AppPallete.borderColor,
                                child: const SizedBox(
                                  width: double.infinity,
                                  height: 150.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        "Select your image",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            "Business",
                            "Technology",
                            "Programming",
                            "Entertainment",
                          ].map((value) {
                            return GestureDetector(
                              onTap: () {
                                if (selectedTopics.contains(value)) {
                                  selectedTopics.remove(value);
                                } else {
                                  selectedTopics.add(value);
                                }
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Chip(
                                  label: Text(value),
                                  side: selectedTopics.contains(value)
                                      ? BorderSide.none
                                      : const BorderSide(
                                          color: AppPallete.borderColor),
                                  color: selectedTopics.contains(value)
                                      ? const MaterialStatePropertyAll(
                                          AppPallete.gradient1)
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      AddBlogField(
                        hintText: "Blog title",
                        controller: titleController,
                      ),
                      const SizedBox(height: 15),
                      AddBlogField(
                        hintText: "Blog content",
                        controller: contentController,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
