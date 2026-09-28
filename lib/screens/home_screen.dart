import 'package:contact/common/app_colors.dart';
import 'package:contact/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'dart:typed_data';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = '';
  String mail = '';
  String phone = '';

  XFile? selectedImage;
  final ImagePicker imagePicker = ImagePicker();
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24, top: 24),
          child: Image.asset('assets/route.png', width: 120),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: contacts.isEmpty
                  ? Column(
                      children: [
                        Lottie.asset(
                          'assets/list_purple.json',
                          height: 400,
                          fit: BoxFit.fill,
                        ),

                        Text(
                          'There is No Contacts Added Here',
                          style: TextStyle(
                            color: AppColors.goldColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : drawGridView(),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: contacts.isEmpty
                  ? null
                  : FloatingActionButton(
                      backgroundColor: AppColors.redColor,
                      onPressed: () {
                        setState(() {
                          contacts.removeLast();
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        color: AppColors.goldColor,
                        size: 24,
                      ),
                    ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: AppColors.goldColor,
                onPressed: () {
                  showBottomSheet(context);
                },
                child: Icon(Icons.add, color: AppColors.darkBlue, size: 24),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  GridView drawGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 300,
      ),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];

        return Card(
          elevation: 3,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: 10,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,

                    child: FutureBuilder<Uint8List>(
                      future: contact.image.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasData) {
                          return
                          ClipRRect( borderRadius: const BorderRadius.only( topLeft: Radius.circular(12), topRight: Radius.circular(12), ),child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ));
                        }

                        return const SizedBox(height: 180);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.goldColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        contact.name,
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.mail, size: 20, color: AppColors.darkBlue),
                    Text(
                      contact.mail,
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(
                      Icons.phone_in_talk,
                      size: 20,
                      color: AppColors.darkBlue,
                    ),
                    Text(
                      contact.number,
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        contacts.removeAt(index);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      foregroundColor: AppColors.goldColor,
                      overlayColor: Colors.transparent,
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, size: 12, color: AppColors.goldColor),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: AppColors.goldColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              color: AppColors.darkBlue,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final XFile? image = await imagePicker
                                    .pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  setModalState(() {
                                    selectedImage = XFile(image.path);
                                  });
                                }
                              },
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.darkBlue,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.goldColor,
                                    width: 2,
                                  ),
                                ),
                                child: selectedImage != null
                                    ? FutureBuilder<Uint8List>(
                                        future: selectedImage!.readAsBytes(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          if (snapshot.hasData) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.memory(
                                                snapshot.data!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }

                                          return const Icon(
                                            Icons.person,
                                            color: AppColors.goldColor,
                                            size: 50,
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Lottie.asset(
                                          'assets/image_picker.json',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          spacing: (8),
                          children: [
                            Text(
                              name.isEmpty ? 'User Name' : name,
                              style: TextStyle(
                                color: AppColors.goldColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              mail.isEmpty ? 'example@email.com' : mail,
                              style: TextStyle(
                                color: AppColors.goldColor,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              phone.isEmpty ? '+20000000000' : phone,
                              style: TextStyle(
                                color: AppColors.goldColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    TextField(
                      onChanged: (value) {
                        setModalState(() {
                          name = value;
                        });
                      },
                      style: TextStyle(
                        color: AppColors.goldColor,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.darkBlue,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.redColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.goldColor,
                          ),
                        ),
                        hintText: 'Enter User Name',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        setModalState(() {
                          mail = value;
                        });
                      },
                      style: TextStyle(
                        color: AppColors.goldColor,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.darkBlue,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.redColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.goldColor,
                          ),
                        ),
                        hintText: 'Enter User Email',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        setModalState(() {
                          phone = value;
                        });
                      },
                      style: TextStyle(
                        color: AppColors.goldColor,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        filled: true,

                        fillColor: AppColors.darkBlue,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.redColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.goldColor,
                          ),
                        ),
                        hintText: 'Enter User Phone',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (name.isNotEmpty &&
                              mail.isNotEmpty &&
                              phone.isNotEmpty &&
                              selectedImage != null) {
                            final Contact newContact = Contact(
                              name: name,
                              mail: mail,
                              number: phone,
                              image: selectedImage!,
                            );
                            setState(() {
                              contacts.add(newContact);
                            });

                            name = '';
                            mail = '';
                            phone = '';
                            selectedImage = null;
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldColor,
                          foregroundColor: AppColors.darkBlue,
                          overlayColor: Colors.transparent,
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Enter User',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
///////////////////////
