import 'dart:io';

import 'package:AutoMobile/src/models/listing.dart';
import 'package:AutoMobile/src/provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class CreateListingScreen extends StatefulWidget {
  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var initialPriceController = TextEditingController();
  bool newUserMode = false;
  DateTime endBidDateController = DateTime.now();
  List<String> imagesUrl = [];
  var imagesFile = [];
  void toggleMode() {
    setState(() {
      newUserMode = !newUserMode;
    });
  }

  void selectEndBidDate(DateTime value) {
    setState(() {
      endBidDateController = value;
    });
  }

  void uploadImage() async {
    final _imagePicker = ImagePicker();
    XFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var file = File(image.path);
        imagesFile.add(file);
        //Upload to Firebase
        var downloadUrl = await AllProvider()
            .repository
            .fireBaseHandler
            .uploadImage(
                AllProvider().repository.fireBaseHandler.getCurrentUserId(),
                file);
        setState(() {
          imagesUrl.add(downloadUrl);
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  void createListing() async {
    var allProvider = Provider.of<AllProvider>(context, listen: false);
    try {
      Listing listing = new Listing(
          userId: allProvider.getCurrentUserId(),
          title: titleController.text,
          id: "",
          description: descriptionController.text,
          imageUrls: imagesUrl,
          bids: List.empty(),
          endBidDate: endBidDateController,
          initialPrice: double.parse(initialPriceController.text),
          creationDate: DateTime.now());
      await allProvider.addListing(listing);
      //TODO: this code executes even if an error is thrown
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Create Listing",
                style: GoogleFonts.bebasNeue(fontSize: 50),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Title "),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Description"),
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: DateTimeField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "End bid date"),
                        firstDate: DateTime.now(),
                        selectedDate: endBidDateController,
                        mode: DateTimeFieldPickerMode.dateAndTime,
                        onDateSelected: selectEndBidDate,
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: initialPriceController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Intial price"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]+.?[0-9]*'))
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                            height: 150.0, enableInfiniteScroll: false),
                        items: imagesFile.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration:
                                      BoxDecoration(color: Colors.blueGrey),
                                  child: Image.file(i));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: (() {
                  uploadImage();
                }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(12)),
                    child: GestureDetector(
                      child: Center(
                          child: Text(
                        imagesUrl.isEmpty
                            ? "Upload image"
                            : "Upload one more image",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: (() {
                    Navigator.of(context).pop();
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(12)),
                      child: GestureDetector(
                        child: Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    createListing();
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(12)),
                      child: GestureDetector(
                        child: Center(
                            child: Text(
                          "Done",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
