import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/twitter_screens/home/view/add_post_page.dart';

class DuplicateHomeScreen extends StatefulWidget {
  const DuplicateHomeScreen({super.key});

  @override
  State<DuplicateHomeScreen> createState() => _DuplicateHomeScreenState();
}

class _DuplicateHomeScreenState extends State<DuplicateHomeScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff4C9EEB),
          shape: const StadiumBorder(),
          onPressed: () {
            print('new screen');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const AddPostPage();
                },
              ),
            );
          },
          child: Image.asset(
            'assets/add_text_icon.png',
            height: 24,
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('post').get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('error hai'),
              );
            } else if (snapshot.hasData) {
              return Center(
                  // ((snapshot.data?.docs as List)[0] as QueryDocumentSnapshot).data()
                  child: ListView.builder(
                itemCount: (snapshot.data?.docs as List).length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      bottom: 10,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        postWidget(((snapshot.data?.docs as List)[index]
                                as QueryDocumentSnapshot)
                            .data() as Map),
                        const Divider()
                      ],
                    ),
                  );
                },
              ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget postWidget(Map postContent2) {
    Map activity = {
      "liked": postLikeWidget(postContent2),
      "retweet": postRetweetWidget(postContent2)
    };
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userImage(postContent2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  activity[postContent2["activity"]["type"]],
                  const SizedBox(
                    height: 4,
                  ),
                  usernameAndIdWidget(postContent2),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: postContent2['post_images_url'].length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.network(
                              postContent2['post_images_url'][index],
                              fit: BoxFit.fill,
                            ),
                            Text(
                                '${index + 1}/${postContent2['post_images_url'].length}')
                          ],
                        );
                      },
                    ),
                  ),
                  captionWidegt(postContent2),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/home_icons/commet_stroke_icon.png",
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                  postContent2["comment_count"].toString()),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/home_icons/retweet_stroke_icon.png",
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child:
                                  Text(postContent2["repost_count"].toString()),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  postContent2["isliked"] =
                                      !postContent2["isliked"];
                                  if (postContent2["isliked"]) {
                                    postContent2["like_count"]++;
                                  } else {
                                    postContent2["like_count"]--;
                                  }
                                });
                              },
                              child: postContent2["isliked"]
                                  ? Image.asset(
                                      "assets/home_icons/heart_solid_icon.png",
                                      color: Colors.red,
                                      height: 15,
                                    )
                                  : Image.asset(
                                      "assets/home_icons/heart_stroke_icon.png",
                                      height: 15,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child:
                                  Text(postContent2["like_count"].toString()),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40.0),
                          child: Image.asset(
                              "assets/home_icons/share_stroke_icon.png",
                              height: 15),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    ]);
  }

  Widget userImage(Map postContent) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(postContent["user_image"]),
              fit: BoxFit.cover)),
    );
  }

  Widget postLikeWidget(Map postContent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/home_icons/heart_solid_icon.png",
          height: 12,
        ),
        RichText(
            text: TextSpan(
                text: " ",
                children: [
                  for (int i = 0;
                      i < postContent["activity"]["users"].length;
                      i++)
                    TextSpan(
                        text: postContent["activity"]["users"][i],
                        children: [
                          if (i < postContent["activity"]["users"].length - 1)
                            const TextSpan(text: " and")
                        ]),
                  const TextSpan(text: " Liked")
                ],
                style: const TextStyle(color: Color(0xff687684))))
      ],
    );
  }

  Widget postRetweetWidget(Map postContent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/home_icons/retweet_stroke_icon.png",
          height: 12,
        ),
        RichText(
            text: TextSpan(
                text: " ",
                children: [
                  for (int i = 0;
                      i < postContent["activity"]["users"].length;
                      i++)
                    TextSpan(
                        text: postContent["activity"]["users"][i],
                        children: [
                          if (i < postContent["activity"]["users"].length - 1)
                            const TextSpan(text: " and")
                        ]),
                  const TextSpan(text: " Retweeted")
                ],
                style: const TextStyle(color: Color(0xff687684))))
      ],
    );
  }

  usernameAndIdWidget(Map postContent) {
    return Column(
      children: [
        Text(
          "${postContent["user_full_name"]}",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Visibility(
          visible: postContent["is_verified"],
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4),
            child:
                Image.asset("assets/home_icons/blue_tick_icon.png", height: 14),
          ),
        ),
        Text("${postContent["user_name"]}",
            style: const TextStyle(
                color: Color(0xff687684),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        // Text(
        //     ".${DateTime.now().difference(postContent['posted_at']).inHours.toString()}h",
        //     style: const TextStyle(
        //         color: Color(0xff687684),
        //         fontSize: 16,
        //         fontWeight: FontWeight.w500))
      ],
    );
  }

  Widget captionWidegt(Map postContent) {
    return RichText(
        text: TextSpan(
            text: "${postContent["caption"]}",
            style: const TextStyle(
                color: Color(0xff141619),
                fontSize: 16,
                fontWeight: FontWeight.w500),
            children: [
          for (int i = 0; i < postContent['hashtags'].length; i++)
            TextSpan(
                text: ' ${postContent['hashtags'][i]} ',
                style: const TextStyle(color: Colors.blue))
        ]));
  }
}
