import 'package:bidverse_frontend/constants/constants.dart';
import 'package:bidverse_frontend/constants/urls.dart';
import 'package:bidverse_frontend/models/UserModel.dart';
import 'package:bidverse_frontend/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/ProductModel.dart';
import '../providers/user_provider.dart';
import '../services/http_service.dart';
import '../services/storage_service.dart';
import '../widgets/items.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<ProductModel> favouriteProducts = [];
  UserProvider userProvider = UserProvider();

  Future<bool> _fetchProducts() async {
    var response = await HttpService.get("${URLS.getUserFavouriteProducts}${userProvider.user!.id}", withAuth: true);

    if (response.success) {
      setState(() {
        favouriteProducts = (response.data!['products'] as List).map((prod) => ProductModel.fromJson(prod)).toList();
      });

      return true;
    } else {
      debugPrint("Error: ${response.error}");
      return false;
    }
  }

  Future<bool> _handleFavourite(String id) async {
    List<String> fav = userProvider.user!.favourites.contains(id)
        ? userProvider.user!.favourites.where((element) => element != id).toList()
        : [...userProvider.user!.favourites, id];

    var data = {'userId': userProvider.user!.id, 'favourites': fav};

    var response = await HttpService.put(URLS.favouriteProduct, data: data, withAuth: true);

    if (response.success) {
      UserModel user = UserModel.fromJson(response.data!['user'] as Map<String, dynamic>);
      userProvider.setUser(user);
      StorageService.setAuthUser(user);

      return true;
    } else {
      debugPrint("Error: ${response.error}");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      _fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomAppBar(
              title: "Favourites",
            ),
            favouriteProducts.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const Center(
                      child: Text("No Uploaded Products"),
                    ),
                  )
                : GridView.count(
                    childAspectRatio: 0.68,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: favouriteProducts
                        .map(
                          (prod) => ItemsWidget(prod.name, prod.description, prod.price, prod.image, prod.id, _handleFavourite),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
