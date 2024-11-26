import 'package:flutter/material.dart';

class Post {
  final String title;
  final String author;
  final DateTime time;
  final String content;
  List<String> comments;
  int heartCount;

  Post({
    required this.title,
    required this.author,
    required this.time,
    required this.content,
    this.comments = const [],
    this.heartCount = 0,
  });

  void incrementHeartCount() {
    heartCount++;
  }
}

List<Post> posts = [];

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  void _addNewPost(BuildContext context) async {
    final newPost = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPostScreen(),
      ),
    );

    if (newPost != null) {
      setState(() {
        posts.insert(0, newPost);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
        backgroundColor: Colors.lightBlue[200],
      ),
      body: ListView(
        children: posts.reversed.map((post) {
          return Card(
            color: Colors.lightBlue[50],
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                '${post.title}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('글쓴이: ${post.author}', style: TextStyle(color: Colors.green)),
                  Text('시간: ${post.time}', style: TextStyle(color: Colors.green)),
                  SizedBox(height: 8),
                  Text(
                    '내용: ${post.content}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        post.incrementHeartCount();
                      });
                    },
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${post.heartCount}',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: post),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewPost(context),
        tooltip: '새 글 작성',
        child: Icon(Icons.add),
      ),
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Post post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 상세 내용'),
        backgroundColor: Colors.lightBlue[200],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post.title}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                Text('글쓴이: ${post.author}', style: TextStyle(color: Colors.green)),
                Text('시간: ${post.time}', style: TextStyle(color: Colors.green)),
                SizedBox(height: 16),
                Text('내용:', style: TextStyle(fontSize: 20, color: Colors.black87)),
                Text(
                  '${post.content}',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: post.comments.map((comment) {
                return Card(
                  color: Colors.lightGreen[100],
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      '댓글: ${comment}',
                      style: TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          CommentInputField(post: post),
        ],
      ),
    );
  }
}

class NewPostScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  void _submitPost(BuildContext context) {
    String title = titleController.text;
    String author = authorController.text;
    String content = contentController.text;

    if (title.isNotEmpty && author.isNotEmpty && content.isNotEmpty) {
      Post newPost = Post(
        title: title,
        author: author,
        time: DateTime.now(),
        content: content,
        comments: [],
      );
      Navigator.pop(context, newPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 글 작성'),
        backgroundColor: Colors.lightBlue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: authorController,
              decoration: InputDecoration(
                labelText: '글쓴이',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _submitPost(context),
              child: Text('작성 완료'),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentInputField extends StatefulWidget {
  final Post post;

  CommentInputField({required this.post});

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController commentController = TextEditingController();

  void _submitComment() {
    String comment = commentController.text;

    if (comment.isNotEmpty) {
      setState(() {
        widget.post.comments.insert(0, comment);
        commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[300],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: '댓글을 작성하세요…',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _submitComment,
          ),
        ],
      ),
    );
  }
}