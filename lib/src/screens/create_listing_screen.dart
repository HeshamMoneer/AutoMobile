import 'dart:io';

import 'package:AutoMobile/src/models/listing.dart';
import 'package:AutoMobile/src/provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      Navigator.of(context).pushReplacementNamed('/mainscreen');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 600,
        margin: EdgeInsets.only(top: 100, left: 10, right: 10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Create Listing",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: titleController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                ),
                DateTimeField(
                  decoration: InputDecoration(labelText: "End bid date"),
                  firstDate: DateTime.now(),
                  selectedDate: endBidDateController,
                  mode: DateTimeFieldPickerMode.dateAndTime,
                  onDateSelected: selectEndBidDate,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Intial price"),
                  controller: initialPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[0-9]+.?[0-9]*'))
                  ],
                ),
                CarouselSlider(
                  options: CarouselOptions(
                      height: 150.0, enableInfiniteScroll: false),
                  items: imagesFile.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.blueGrey),
                            child: Image.file(i));
                      },
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    uploadImage();
                  },
                  child: Text("Upload image"),
                ),
                ElevatedButton(
                  onPressed: () {
                    createListing();
                  },
                  child: Text("Done"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
