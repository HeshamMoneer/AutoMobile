import 'package:AutoMobile/src/models/user.dart';
import 'package:AutoMobile/src/provider/provider.dart';
import 'package:AutoMobile/src/screens/my_bids.dart';
import 'package:AutoMobile/src/screens/my_listings_screen.dart';
import 'package:AutoMobile/src/themes/theme.dart';
import 'package:AutoMobile/src/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen();
  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

void goToUserProfile(BuildContext myContext, String userId) {
  Navigator.of(myContext)
      .pushNamed('/userProfile', arguments: {'userId': userId});
}

class _UserProfileScreen extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<AllProvider>(context);
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    String userId = routeArgs?['userId'] ?? myProvider.getCurrentUserId();
    bool isMe = (userId == myProvider.getCurrentUserId());
    Future<User> user = myProvider.getUserById(userId);

    final appBar = AppBar(
      actions: [
        !isMe
            ? IconButton(
                onPressed: () {
                  user.then((value) => Navigator.of(context)
                      .pushNamed('/inbox/chat', arguments: value));
                },
                icon: Icon(Icons.chat_bubble_outline_outlined))
            : Container()
      ],
      title: Text("Profile",
          style: AppTheme
              .titleStyle2), //TextStyle(color: ThemeColor.titleTextColor)),
    );

    final MyListings = ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyListingsScreen()),
          );
        },
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child:
              const Icon(Icons.post_add_outlined, color: ThemeColor.lightblack),
        ),
        title:
            Text("My Listings", style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.2)),
          child: const Icon(LineAwesomeIcons.angle_right,
              size: 18, color: Color.fromARGB(255, 58, 57, 57)),
        ));
    // container

    final profileEdit = ListTile(
        onTap: () {
          Navigator.of(context).pushNamed('/editProfile');
        },
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.edit_note, color: ThemeColor.lightblack),
        ),
        title: Text("Edit My Profile",
            style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.2)),
          child: const Icon(LineAwesomeIcons.angle_right,
              size: 18, color: Color.fromARGB(255, 58, 57, 57)),
        ));

    final mybids = ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyBidsScreen()),
          );
        },
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.list_alt, color: ThemeColor.lightblack),
        ),
        title: Text("My Bids", style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.2)),
          child: const Icon(LineAwesomeIcons.angle_right,
              size: 18, color: Color.fromARGB(255, 58, 57, 57)),
        ));

    final logout = ListTile(
        onTap: () {
          myProvider.repository.fireBaseHandler.signout().then(
              (value) => Navigator.of(context).pushReplacementNamed('/login'));
        },
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.logout, color: ThemeColor.lightblack),
        ),
        title: Text("Log out", style: Theme.of(context).textTheme.bodyText1),
        trailing: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.2)),
          child: const Icon(LineAwesomeIcons.angle_right,
              size: 18, color: Color.fromARGB(255, 58, 57, 57)),
        ));

    final profileImage = FutureBuilder<User>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? curUser = snapshot.data;
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              curUser!.profilePicPath,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${curUser.firstName} ${curUser.lastName}",
                      style: AppTheme.titleStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${curUser.email}',
                      style: AppTheme.titleStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // if (isMe) editProfile,
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.date_range_outlined),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Birth Date',
                                style: AppTheme.titleStyle,
                              ),
                              Text(
                                '${curUser.birthDate}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          leading:
                              Icon(curUser.isMale ? Icons.male : Icons.female),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gender',
                                style: AppTheme.titleStyle,
                              ),
                              Text(
                                '${curUser.isMale ? 'Male' : 'Female'}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.phone_android),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone Number',
                                style: AppTheme.titleStyle,
                              ),
                              Text(
                                '${curUser.phoneNumber}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Joining Date',
                                style: AppTheme.titleStyle,
                              ),
                              Text(
                                '${curUser.joiningDate}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (isMe) profileEdit,
                        if (isMe) MyListings,
                        if (isMe) mybids,
                        if (isMe) logout
                      ],
                    )
                  ],
                )),
          );
        } else if (snapshot.hasError) {
          return ErrorWidget(
              "The user data could not be found!! + ${snapshot.error}");
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    return Scaffold(
      appBar: appBar,
      body: profileImage,
    );
  }
}
