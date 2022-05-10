
import 'package:coofit/common/state_enum.dart';
import 'package:coofit/model/menu/menu_response.dart';
import 'package:coofit/provider/detail_provider.dart';
import 'package:coofit/style/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class DetailPage extends StatefulWidget {

  static const routeName = '/detail_page';
  final String menuId;

  const DetailPage({Key? key, required this.menuId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DetailProvider>(context, listen: false)
          .getMenuDetail(widget.menuId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Consumer<DetailProvider>(
          builder: (context, value, child) {
            switch (value.state) {
              case RequestState.Success: {
                return Row(
                  children: [
                    Expanded(
                      child: _buildMenuDetail(value.menu),
                    ),
                    Expanded(
                      child: _buildMenuSupport(),
                    )
                  ],
                );
              }
              case RequestState.Default:
                return Container();
                break;
              case RequestState.Empty:
                return Container();
                break;
              case RequestState.Loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case RequestState.Error:
                return Center(
                  child: Text(value.message),
                );
                break;
            }
          }
        ),
      ),
    );
  }

  Widget _buildMenuDetail(MenuResponse menu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: coofitTextTheme.bodyText1,
        ),
        const SizedBox(height: 4.0),
        Text(
          "${menu.description} \n Kalori yang dihasilkan oleh ${menu.title} adalah sekitar ${menu.calories}",
          style: coofitTextTheme.subtitle2,
        ),
        const SizedBox(height: 24.0),
        Text(
          'Ingredients',
          style: coofitTextTheme.bodyText1,
        ),
        const SizedBox(height: 4.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: menu.ingredients.length,
          itemBuilder: (context, index) {
            return _buildIngredientsItem(menu.ingredients[index]);
          },
        ),
        const SizedBox(height: 24.0),
        Text(
          'Steps',
          style: coofitTextTheme.bodyText1,
        ),
        const SizedBox(height: 4.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: menu.steps.length,
          itemBuilder: (context, index) {
            return _buildStepsItem(menu.steps[index], (index + 1));
          },
        ),
      ],
    );
  }

  Widget _buildMenuSupport() {
    return Container();
  }

  Widget _buildIngredientsItem(String ingredient) {
    return Row(
      children: [
        const Icon(Icons.circle, color: primaryColor),
        const SizedBox(width: 8.0),
        Text(
          ingredient,
          style: coofitTextTheme.subtitle2,
        )
      ],
    );
  }

  Widget _buildStepsItem(String step, int position) {
    return Row(
      children: [
        Text(
          "$position.",
          style: coofitTextTheme.subtitle2,
        ),
        const SizedBox(width: 8.0),
        Text(
          step,
          style: coofitTextTheme.subtitle2,
        )
      ],
    );
  }
}