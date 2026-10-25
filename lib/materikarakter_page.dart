import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Import yang benar
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MateriKarakterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materi Karakter'),
        backgroundColor: Color.fromARGB(255, 134, 87, 217), // Warna latar belakang AppBar
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0), // Padding di sekitar ListView
        children: <Widget>[
          VideoListItem(
            title: 'Karakter Akhlak Mulia',
            videoUrl: 'https://youtu.be/2UwY8VXauXs?si=fDQcxUS8TouXdwKX',
            thumbnailUrl: 'https://img.youtube.com/vi/2UwY8VXauXs/hqdefault.jpg',
          ),
          VideoListItem(
            title: 'Karakter Mandiri',
            videoUrl: 'https://youtu.be/USUxKwQX-jM?si=uuIexa3u8--2uE5o',
            thumbnailUrl: 'https://img.youtube.com/vi/USUxKwQX-jM/hqdefault.jpg',
          ),
          VideoListItem(
            title: 'Karakter Gotong Royong',
            videoUrl: 'https://youtu.be/imAOHmh_hm8?si=wQ2Nbxn2r1P8JN-Ro',
            thumbnailUrl: 'https://img.youtube.com/vi/imAOHmh_hm8/hqdefault.jpg',
          ),
          VideoListItem(
            title: 'Karakter Nasionalis & Bhineka Tunggal Ika',
            videoUrl: 'https://youtu.be/atHRx87M_fY?si=l3JPz8VORRiuU4PD',
            thumbnailUrl: 'https://img.youtube.com/vi/atHRx87M_fY/hqdefault.jpg',
          ),
          VideoListItem(
            title: 'Karakter Kreatif',
            videoUrl: 'https://youtu.be/Pmn6-6jJUp8?si=jAP6syNaB7ugbWOm',
            thumbnailUrl: 'https://img.youtube.com/vi/Pmn6-6jJUp8/hqdefault.jpg',
          ),
          // Tambahkan daftar video lainnya di sini
        ],
      ),
    );
  }
}

class VideoListItem extends StatelessWidget {
  final String title;
  final String videoUrl;
  final String thumbnailUrl;

  const VideoListItem({
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0), // Jarak antar card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Sudut melengkung
      ),
      elevation: 5, // Bayangan card
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0), // Padding di dalam ListTile
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            thumbnailUrl,
            width: 120.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Navigasi ke halaman pemutar video saat item video dipilih
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(videoUrl: videoUrl),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({
    required this.videoUrl,
  });

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _youtubeController;
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool isYoutube = false;

  @override
  void initState() {
    super.initState();
    isYoutube = YoutubePlayer.convertUrlToId(widget.videoUrl) != null;
    if (isYoutube) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pemutar Video'),
        backgroundColor: Colors.deepPurple, // Warna latar belakang AppBar
      ),
      body: isYoutube
          ? YoutubePlayer(
              controller: _youtubeController,
              showVideoProgressIndicator: true,
            )
          : FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: isYoutube
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_videoPlayerController.value.isPlaying) {
                    _videoPlayerController.pause();
                  } else {
                    _videoPlayerController.play();
                  }
                });
              },
              child: Icon(
                _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              backgroundColor: Color.fromARGB(255, 138, 92, 219), // Warna tombol
            ),
    );
  }

  @override
  void dispose() {
    if (isYoutube) {
      _youtubeController.dispose();
    } else {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }
}
