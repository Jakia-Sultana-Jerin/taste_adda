
import 'package:flutter/material.dart';

class RecipeViewModel extends ChangeNotifier {
  final List<Map<String, String>> Recipe = [
    {
      "img":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTP8l2kuZDANQExDsYteLg0NEUEjLkjudABRg&s",
      "title": "Chicken Biriyani",
    },
    {
      "img":
          "https://images.immediate.co.uk/production/volatile/sites/30/2013/05/Puttanesca-fd5810c.jpg?quality=90&resize=556,505",
      "title": "Pasta",
    },
    {
      "img":
          "https://www.allrecipes.com/thmb/iLAfLvIq4cqfEB3pA8AoNCGxrwE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/16354-easy-meatloaf-DDMFS-0036-5186-hero-2x1-36abc71abb0b436b9ce8eebef460f3f8.jpg",
      "title": "Easy Meatloaf",
    },
    {
      "img":
          "https://atanurrannagharrecipe.com/wp-content/uploads/2022/12/Dhaba-Chicken.png",
      "title": "Dhaba Chicken",
    },
    {
      "img":
          "https://www.cookwithmanali.com/wp-content/uploads/2018/05/Best-Pav-Bhaji-Recipe-500x500.jpg",
      "title": "Vhaji",
    },
    {
      "img":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7dki6AkOmfg4c938Q2kvN3zzqd0stn4oPkg&s",
      "title": "Vhuna khichuri",
    },
    {
      "img":
          "https://www.shajgoj.com/wp-content/uploads/2017/04/loitka-sutki-700x431.jpg",
      "title": "loitta shutki",
    },
    {
      "img":
          "https://www.inspiredtaste.net/wp-content/uploads/2023/03/Easy-Sauteed-Vegetables-1200.jpg",
      "title": "Easy Sautted vegetable",
    },

  {

    "img":"https://ourbigescape.com/wp-content/uploads/2023/02/1.-Beef-Kala-Bhuna-Beef-Curry.jpg",
    "title":"Beef Kala Vhuna"
  },
{

"img":"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRO26sDFNP-p7Ucs9UAu_ShO82wjKXWBHhDCg&s",
"title":"Roshogulla"

},
{

"img": "https://veganbangla.com/wp-content/uploads/2024/01/fullsizeoutput_2d5c-1495362385-e1706722786533.jpeg?w=900",
"title":"Chitoi Pitha"


},


  ];
}









// final dio = Dio();

// Future<List<Map<String, dynamic>>> fetchHome() async {
//   try {
//     final response = await dio.get(
//       "https://api.npoint.io/416d7e3a1b58126c480f",
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.data);

//       print(data['data']);
//       // ignore: empty_catches
//     } else {
//       print('error');
//     }
//   } catch (e) {
//     print("Error fetching data");
//   }
// }
