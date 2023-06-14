import 'package:bidverse_frontend/constants/urls.dart';
import 'package:bidverse_frontend/models/UserModel.dart';
import 'package:bidverse_frontend/providers/user_provider.dart';
import 'package:bidverse_frontend/services/http_service.dart';
import 'package:bidverse_frontend/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/ProductModel.dart';
import '../widgets/categories.dart';
import '../widgets/items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> allProducts = [];
  List<ProductModel?> featuredProducts = [];
  List<ProductModel?> nonFeaturedAndDisplayProducts = [];

  List<String> categories = ["Fashion", "Electronics", "Furnitures", "Others"];
  String selectedCategory = '';

  TextEditingController searchFieldText = TextEditingController();
  UserProvider userProvider = UserProvider();

  Future<bool> _fetchProducts() async {
    var response = await HttpService.get(URLS.getProducts, withAuth: true);

    if (response.success) {
      setState(() {
        allProducts = (response.data!['products'] as List).map((prod) => ProductModel.fromJson(prod)).toList();
        featuredProducts = allProducts.map((prod) {
          if (prod.isFeatured) {
            return prod;
          }
        }).toList();
        featuredProducts.removeWhere((element) => element == null);
        nonFeaturedAndDisplayProducts = allProducts.map((prod) {
          if (!prod.isFeatured) {
            return prod;
          }
        }).toList();
        nonFeaturedAndDisplayProducts.removeWhere((element) => element == null);
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
      userProvider.setUser(UserModel.fromJson(response.data!['user'] as Map<String, dynamic>));

      return true;
    } else {
      debugPrint("Error: ${response.error}");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return ListView(children: [
      CustomAppBar("Home"),
      Container(
        padding: const EdgeInsets.only(top: 15),
        decoration: const BoxDecoration(
          color: Color(0xFFEDECF2),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular((35)),
          //   topRight: Radius.circular(35),
          // ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  height: 50,
                  width: 200,
                  child: TextFormField(
                    controller: searchFieldText,
                    onChanged: (value) {
                      if (value != '') {
                        setState(() {
                          nonFeaturedAndDisplayProducts = allProducts
                              .where((element) => element.name.toLowerCase().contains(value.toLowerCase()) && !element.isFeatured)
                              .toList();
                        });
                      } else {
                        setState(() {
                          nonFeaturedAndDisplayProducts = allProducts.where((element) => !element.isFeatured).toList();
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here...",
                    ),
                  ),
                ),
                const Spacer(),
                // const Icon(
                //   Icons.camera_alt,
                //   size: 27,
                // ),
              ]),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: categories
                      .map((cat) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCategory == cat) {
                                selectedCategory = '';
                              } else {
                                selectedCategory = cat;
                              }
                              if (selectedCategory != '') {
                                nonFeaturedAndDisplayProducts = allProducts.map((prod) {
                                  if (prod.category == selectedCategory && !prod.isFeatured) {
                                    return prod;
                                  }
                                }).toList();
                                nonFeaturedAndDisplayProducts.removeWhere((element) => element == null);
                              } else {
                                nonFeaturedAndDisplayProducts = allProducts.map((prod) {
                                  if (!prod.isFeatured) {
                                    return prod;
                                  }
                                }).toList();
                                nonFeaturedAndDisplayProducts.removeWhere((element) => element == null);
                              }
                            });
                          },
                          child: Categories(cat, selectedCategory == cat)))
                      .toList()),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: const Text(
                "Top Auctions",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
            ),
            GridView.count(
              childAspectRatio: 0.68,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              children: featuredProducts
                  .map(
                    (prod) => ItemsWidget(prod!.name, prod.description, prod.price, prod.image, prod.id, _handleFavourite),
                  )
                  .toList(),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: const Text(
                "All Products",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
            ),
            nonFeaturedAndDisplayProducts.isEmpty
                ? Text("No Products")
                : GridView.count(
                    childAspectRatio: 0.68,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: nonFeaturedAndDisplayProducts
                        .map(
                          (prod) => ItemsWidget(prod!.name, prod.description, prod.price, prod.image, prod.id, _handleFavourite),
                        )
                        .toList(),
                  )
          ],
        ),
      )
    ]);
  }
}
