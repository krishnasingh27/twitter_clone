import 'package:flutter/material.dart';

class MessageMainScreen extends StatefulWidget {
  const MessageMainScreen({super.key});

  @override
  State<MessageMainScreen> createState() => _MessageMainScreenState();
}

class _MessageMainScreenState extends State<MessageMainScreen> {
  static List messageContent = [
    {
      "user_image":
          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Martha Craig",
      "user_name": "@craig_love",
      "message_date": "1-1-24",
      "message": "You: You’re very welcome AzizDjan!",
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Maximmilian",
      "user_name": "@maxjacobson",
      "message_date": "1-1-24",
      "message": "You accepted the request",
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Tabitha Potter",
      "user_name": "@mis_potter",
      "message_date": "1-1-24",
      "message": "You accepted the request",
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1500336624523-d727130c3328?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Karennne",
      "user_name": "@karennne",
      "message_date": "1-1-24",
      "message":
          r"""You: I would greatly appreciate if you could retweet this if you think its worthy :)""",
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Martha Craig",
      "user_name": "@craig_love",
      "message_date": "1-1-24",
      "message": "sent you a link: Hello Pixsellz,",
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Maximmilian",
      "user_name": "@maxjacobson",
      "message_date": "1-1-24",
      "message": "You: Just started 5 months ago",
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Tabitha Potter",
      "user_name": "@mis_potter",
      "message_date": "1-1-24",
      "message": "You accepted the request",
    },
    {
      "user_image":
          "https://images.unsplash.com/photo-1500336624523-d727130c3328?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "user_full_name": "Karennne",
      "user_name": "@karennne",
      "message_date": "1-1-24",
      "message":
          r"""You: Hi Kiero, let me see what I can do gfor you. I will get back to you soon. Our """,
    },
  ];

  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff4C9EEB),
        shape: const StadiumBorder(),
        onPressed: () {},
        child: Image.asset(
          'assets/new_message_icon.png',
          height: 24,
        ),
      ),
      body: Column(
        children: [
          searchBarWidget(),
          Divider(),
          Expanded(
              child: ListView.builder(
            itemCount: messageContent.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  bottom: 10,
                  right: 20,
                ),
                child: Column(
                  children: [messageScreenWidget(index), const Divider()],
                ),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget searchBarWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 32,
        // Add padding around the search bar
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        // Use a Material design search bar
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 2.0),
            hintText: 'Search for people and groups',
            // Add a search icon or button to the search bar
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Perform the search here
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget messageScreenWidget(int index) {
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
                  usernameAndIdWidget(index),
                  messagesWidegt(index),
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
              image: NetworkImage(messageContent[index]["user_image"]),
              fit: BoxFit.cover)),
    );
  }

  usernameAndIdWidget(int index) {
    return Row(
      children: [
        Text(
          "${messageContent[index]["user_full_name"]}",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(" ${messageContent[index]["user_name"]}",
            style: const TextStyle(
                color: Color(0xff687684),
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        Spacer(),
        Text(".${messageContent[index]['message_date']}",
            style: const TextStyle(
                color: Color(0xff687684),
                fontSize: 16,
                fontWeight: FontWeight.w500))
      ],
    );
  }

  Widget messagesWidegt(int index) {
    return RichText(
        text: TextSpan(
      text: "${messageContent[index]["message"]}",
      style: const TextStyle(
          color: Color(0xff141619), fontSize: 16, fontWeight: FontWeight.w500),
    ));
  }
}
