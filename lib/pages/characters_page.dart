import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'characters_controller.dart';
import 'character_details_page.dart';

class CharactersPage extends StatelessWidget {
  final CharactersController charactersController =
      Get.put(CharactersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Rick and Morty Characters',
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          isRepeatingAnimation: true,
        ),
      ),
      body: Obx(() => charactersController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: charactersController.characters.length,
              itemBuilder: (context, index) {
                return CharacterListItem(
                  character: charactersController.characters[index],
                  charactersController:
                      charactersController, // Pasa el controlador
                );
              },
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            )),
    );
  }
}

class CharacterListItem extends StatelessWidget {
  final dynamic character;
  final CharactersController charactersController;

  const CharacterListItem(
      {Key? key, required this.character, required this.charactersController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => CharacterDetailsPage(
            character: character,
            charactersController: charactersController,
          ),
          transition: Transition.fadeIn,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Hero(
          tag: 'character_image_${character['id']}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image.network(
                  character['image'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        character['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        character['status'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
