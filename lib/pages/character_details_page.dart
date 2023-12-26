import 'package:flutter/material.dart';
import 'characters_controller.dart';

class CharacterDetailsPage extends StatefulWidget {
  final dynamic character;
  final CharactersController charactersController;

  CharacterDetailsPage({
    Key? key,
    required this.character,
    required this.charactersController,
  }) : super(key: key);

  @override
  _CharacterDetailsPageState createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentPageIndex;
  late OverlayEntry _overlayEntry;

  late AnimationController _heartColorAnimationController;

  @override
  void initState() {
    super.initState();
    _currentPageIndex =
        widget.charactersController.characters.indexOf(widget.character);
    _pageController = PageController();
    _pageController.addListener(_handlePageChange);

    _overlayEntry = _createOverlayEntry();

    _heartColorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_overlayEntry);
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => TutorialOverlayWidget(
        onClose: () {
          _overlayEntry.remove();
        },
      ),
    );
  }

  void _handlePageChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentPageIndex = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _heartColorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.charactersController.characters[_currentPageIndex]['name']),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.charactersController.characters.length,
            itemBuilder: (context, index) {
              return buildCharacterCard(
                widget.charactersController.characters[index],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCharacterCard(dynamic character) {
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: 'character_image_${character['id']}',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Image.network(
                  character['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedBuilder(
                      animation: _heartColorAnimationController,
                      builder: (context, child) {
                        return IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: (character['liked'] ?? false)
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              character['liked'] =
                                  !(character['liked'] ?? false);
                            });

                            if (character['liked']!) {
                              _heartColorAnimationController.forward(from: 0);
                            } else {
                              _heartColorAnimationController.reverse();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  character['name'],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Status: ${character['status']}'),
                Text('Species: ${character['species']}'),
                Text('Type: ${character['type']}'),
                Text('Gender: ${character['gender']}'),
                Text('Origin: ${character['origin']['name']}'),
                Text('Last Known Location: ${character['location']['name']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialOverlayWidget extends StatelessWidget {
  final VoidCallback onClose;

  TutorialOverlayWidget({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 30,
          left: MediaQuery.of(context).size.width / 2 - 100,
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_ios),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Desliza hacia la derecha para ver más \n'
                    'personajes y hacia la izquierda\n'
                    'para devolverte',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onClose,
                    child: Text('Got it'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
