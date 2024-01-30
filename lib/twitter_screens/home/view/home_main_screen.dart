import 'package:flutter/material.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  static List postContent = [
    {
      "user_image":
          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Martha Craig",
      "user_name": "@craig_love",
      "posted_at": DateTime.now().subtract(Duration(hours: 12)),
      "caption":
          r"""UXR/UX: You can only bring one item to a remote island to assist your research of native use of tools and usability. What do you bring?""",
      "hashtags": ["#TellMeAboutYou", "#TellMeAboutThem", "#life", "#letsgo"],
      "comment_count": 29,
      "repost_count": 5,
      "like_count": 21,
      "activity": {
        "type": "liked",
        "users": ["Kieron Dotson", " Zack John"]
      },
      "is_verified": false,
      "isliked": false
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Maximmilian",
      "user_name": "@maxjacobson",
      "posted_at": DateTime.now().subtract(Duration(hours: 3)),
      "caption": "Y’all ready for this next post?",
      "hashtags": [],
      "comment_count": 29,
      "repost_count": 1,
      "like_count": 11,
      "activity": {
        "type": "liked",
        "users": ["Zack John"]
      },
      "is_verified": false,
      "isliked": true
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Tabitha Potter",
      "user_name": "@mis_potter",
      "posted_at": DateTime.now().subtract(Duration(hours: 14)),
      "caption":
          r"""Kobe’s passing is really sticking w/ me in a way I didn’t expect.

He was an icon, the kind of person who wouldn’t die this way. My wife compared it to Princess Di’s accident.

But the end can happen for anyone at any time, & I can’t help but think of anything else lately.""",
      "hashtags": "",
      "comment_count": 29,
      "repost_count": 5,
      "like_count": 122,
      "activity": {
        "type": "retweet",
        "users": ["Kieron Dotson"]
      },
      "is_verified": true,
      "isliked": false
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1500336624523-d727130c3328?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Karennne",
      "user_name": "@karennne",
      "posted_at": DateTime.now().subtract(Duration(hours: 10)),
      "caption":
          r"""Name a show where the lead character is the worst character on the show I’ll get Sabrina Spellman.""",
      "hashtags": [],
      "comment_count": 1096,
      "repost_count": 1249,
      "like_count": 7461,
      "activity": {
        "type": "liked",
        "users": ["Zack John"]
      },
      "is_verified": false,
      "isliked": true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff4C9EEB),
          shape: const StadiumBorder(),
          onPressed: () {},
          child: Image.asset(
            'assets/add_text_icon.png',
            height: 24,
          ),
        ),
        body: ListView.builder(
          itemCount: postContent.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                bottom: 10,
                right: 20,
              ),
              child: Column(
                children: [postWidget(index), const Divider()],
              ),
            );
          },
        ));
  }

  Widget postWidget(int index) {
    Map activity = {
      "liked": postLikeWidget(index),
      "retweet": postRetweetWidget(index)
    };
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userImage(index),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  activity[postContent[index]["activity"]["type"]],
                  SizedBox(
                    height: 4,
                  ),
                  usernameAndIdWidget(index),
                  captionWidegt(index),
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
                              child: Text(postContent[index]["comment_count"]
                                  .toString()),
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
                              child: Text(postContent[index]["repost_count"]
                                  .toString()),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  postContent[index]["isliked"] =
                                      !postContent[index]["isliked"];
                                  if (postContent[index]["isliked"]) {
                                    postContent[index]["like_count"]++;
                                  } else {
                                    postContent[index]["like_count"]--;
                                  }
                                });
                              },
                              child: postContent[index]["isliked"]
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
                              child: Text(
                                  postContent[index]["like_count"].toString()),
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

  Widget userImage(int index) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(postContent[index]["user_image"]),
              fit: BoxFit.cover)),
    );
  }

  Widget postLikeWidget(int index) {
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
                      i < postContent[index]["activity"]["users"].length;
                      i++)
                    TextSpan(
                        text: postContent[index]["activity"]["users"][i],
                        children: [
                          if (i <
                              postContent[index]["activity"]["users"].length -
                                  1)
                            const TextSpan(text: " and")
                        ]),
                  TextSpan(text: " Liked")
                ],
                style: const TextStyle(color: Color(0xff687684))))
      ],
    );
  }

  Widget postRetweetWidget(int index) {
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
                      i < postContent[index]["activity"]["users"].length;
                      i++)
                    TextSpan(
                        text: postContent[index]["activity"]["users"][i],
                        children: [
                          if (i <
                              postContent[index]["activity"]["users"].length -
                                  1)
                            const TextSpan(text: " and")
                        ]),
                  TextSpan(text: " Retweeted")
                ],
                style: const TextStyle(color: Color(0xff687684))))
      ],
    );
  }

  usernameAndIdWidget(int index) {
    return Row(
      children: [
        Text(
          "${postContent[index]["user_full_name"]}",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Visibility(
          visible: postContent[index]["is_verified"],
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4),
            child:
                Image.asset("assets/home_icons/blue_tick_icon.png", height: 14),
          ),
        ),
        Text("${postContent[index]["user_name"]}",
            style: const TextStyle(
                color: Color(0xff687684),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        Text(
            ".${DateTime.now().difference(postContent[index]['posted_at']).inHours.toString()}h",
            style: const TextStyle(
                color: Color(0xff687684),
                fontSize: 16,
                fontWeight: FontWeight.w500))
      ],
    );
  }

  Widget captionWidegt(int index) {
    return RichText(
        text: TextSpan(
            text: "${postContent[index]["caption"]}",
            style: const TextStyle(
                color: Color(0xff141619),
                fontSize: 16,
                fontWeight: FontWeight.w500),
            children: [
          for (int i = 0; i < postContent[index]['hashtags'].length; i++)
            TextSpan(
                text: ' ${postContent[index]['hashtags'][i]} ',
                style: const TextStyle(color: Colors.blue))
        ]));
  }
}
