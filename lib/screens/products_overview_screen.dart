import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({
    Key key,
  });

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  var productTitle = '';
  var page = 0;
  var totalPage = 5;
  List<Product> products;
  TextEditingController searchTextEditingController = TextEditingController();

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    var length = Provider.of<Products>(context).items.length;
    var nbPages = length / 6;
    if (length % 6 != 0) nbPages++;
    setState(() {
      totalPage = nbPages.toInt();
    });
    _isInit = false;
    setState(() {
      products = Provider.of<Products>(context).items;
    });
    super.didChangeDependencies();
  }

  controlSearching(String productName, BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: new EdgeInsets.only(bottom: 4.0),
          child: TextFormField(
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            controller: searchTextEditingController,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
                size: 25.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  searchTextEditingController.text = '';
                  setState(() {
                    productTitle = searchTextEditingController.text;
                    products = Provider.of<Products>(context).items;
                    var length = products.length;
                    var nbPages = length / 6;
                    if (length % 6 != 0) nbPages++;
                    totalPage = nbPages.toInt();
                  });
                },
              ),
            ),
            onChanged: (String productName) {
              setState(() {
                productTitle = searchTextEditingController.text;
                products = Provider.of<Products>(context).items;
                products = products
                    .where((element) => element.title
                        .toLowerCase()
                        .contains(productTitle.toLowerCase()))
                    .toList();
                var length = products.length;
                var nbPages = length / 6;
                if (length % 6 != 0) nbPages++;
                totalPage = nbPages.toInt();
              });
            },
          ),
        ),
        actions: [
          PopupMenuButton(
            key: ValueKey('Menu'),
            onSelected: (FilterOptions selectedvalue) {
              setState(() {
                if (selectedvalue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
                var productsData = Provider.of<Products>(context);
                setState(() {
                  products = _showOnlyFavorites
                      ? productsData.favoriteItems
                      : productsData.items;
                  var length = products.length;
                  var nbPages = length / 6;
                  if (length % 6 != 0) nbPages++;
                  totalPage = nbPages.toInt();
                });
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                key: ValueKey('onlyFav'),
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                ProductsGrid(products, _showOnlyFavorites, productTitle, page),
                if (products.length != 0)
                  Column(
                    children: [
                      Text(
                        'Page: ${page + 1}/$totalPage',
                        style: TextStyle(fontSize: 25, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.arrow_left_sharp,
                                size: 50,
                                color: page == 0
                                    ? Colors.grey
                                    : Theme.of(context).accentColor,
                              ),
                              onPressed: () {
                                if (page != 0) {
                                  setState(() {
                                    page--;
                                  });
                                }
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_right_sharp,
                                size: 50,
                                color: totalPage == page + 1
                                    ? Colors.grey
                                    : Theme.of(context).accentColor,
                              ),
                              onPressed: () {
                                if (totalPage != page + 1) {
                                  setState(() {
                                    page++;
                                  });
                                }
                              }),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  )
              ],
              alignment: Alignment.topCenter,
            ),
    );
  }
}
