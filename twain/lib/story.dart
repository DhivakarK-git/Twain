import 'package:http/http.dart' as http;
import 'dart:convert';

class Node<T> {
  final String value, description, question;
  Node<T>? left, right;
  Node(this.value, this.description, this.question, {this.left, this.right});
}

class Story {
  var root;
  final _username, _password;

  Future<http.Response> fetch() async {
    var auth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    return await http.get(Uri.http('192.168.2.2:5000', 'api/fetchstories'),
        headers: <String, String>{'authorization': auth});
  }

  Story(this._username, this._password);
  Future<void> constructTree() async {
    final response = await fetch();
    var temp = jsonDecode(response.body)['data'], id = [], node = [];
    List<int> parent = [];
    for (int i = 0; i < temp.length; i++) {
      id.add(temp[i][0] == null ? -1 : temp[i][0]);
      parent.add(temp[i][4] == null ? -1 : temp[i][4]);
    }
    for (int i = 0; i < id.length; i++) {
      node.add(Node(temp[i][1], temp[i][2], temp[i][3]));
    }
    for (int i = 1; i < id.length; i++) {
      if (id[i] % 2 == 0) {
        node[parent[i] - 1].right = node[i];
      } else {
        node[parent[i] - 1].left = node[i];
      }
    }
    root = node[0];
  }

// void insert(var root, var temp, List parent, var id) {
//   // try {
//   if (parent.isEmpty) return;
//   dynamic index = parent.indexOf(id), index1 = parent.lastIndexOf(id);

//   var val1 = temp[index][0], val2 = temp[index1][0];
//   print(val2);
//   print(val1);
//   if (index != -1) {
//     root.left = Node(temp[index][1], temp[index][2], temp[index][3]);
//     temp.remove(index);
//     parent.remove(index);
//   }
//   if (index1 != -1) {
//     root.right = Node(temp[index1][1], temp[index1][2], temp[index1][3]);
//     temp.removeAt(index1);
//     parent.removeAt(index1);
//   }
//   if (index != -1 && parent.contains(val1))
//     insert(root.left, temp, parent, val1);
//   if (index1 != -1 && parent.contains(val2))
//     insert(root.right, temp, parent, val2);
//   // } catch (e) {
//   //   print(e);
//   //   return;
//   // }
// }

  // {
  //   //   root = Node(
  //   //     "",
  //   //     "Your body grows weary as you wake up from the hay stalk you have been sleeping on. Your morning routine starts with you, tending to the horses in the stable.",
  //   //     "You are a ...",
  //   //     left: Node(
  //   //       "Boy",
  //   //       "You go by the name Euron Greyjoy. An adolescent orphan who aspires to be a horse rider. A maverick who particapates in the echelon race that occurs in your city. As you tend to the horses, the ground you starts to tremble. You lose balance and hear somethong crash outside the stable.",
  //   //       "Will you check it out?",
  //   //       left: Node(
  //   //         "Yes",
  //   //         "As you go out you seem to be blinded by the bright light casted onto your eyes. On the eye of the blinding golden light is a staff adorned on gold. A sensation that is almost numbing surges through your body. A feeling as if the staff is synchronising with your hands, and suddenly your body starts moving on its own. Your hands reach out to pick the staff.",
  //   //         "Do you choose to take it?",
  //   //         left: Node(
  //   //           "Yes",
  //   //           "Suddenly you hear growling sounds from your stomach. You come to the realisation that you are hungry and also that the staff in your hands are not as heavy as it seems to be. But that wasn\'t it. Along with the fact that you feel taller, nimbler and also suppringly strong. You enter the stable to fix yourself a uick breakfast, but you tumble over a bucket. Even thought that fall must have brooken your frail body....\n\tYou realise you remain unharmed and that the bucket was in a rather pitigul state. Crushed and mangled under your legs. Four armed men swords enter the stable. The man in a armour distinct from others says,\"I am Going to have to take the staff from you. We can do it the easy way or the hard way.\"",
  //   //           "Do you want to hand him the staff?",
  //   //           left: Node("Yes", "To be Continued ...", "Start Again?"),
  //   //           right: Node("No", "To be Continued ...", "Start Again?"),
  //   //         ),
  //   //         right: Node("No", "The End", "Start Again?"),
  //   //       ),
  //   //       right: Node("No", "The End", "Start Again?"),
  //   //     ),
  //   //     right: Node(
  //   //       "Girl",
  //   //       "You go by the name Emilia Greyjoy. An adolescent orphan who aspires to be a horse raiser. A maverick who raises horses that the riders ride in the echelon race that occurs in your city. As you tend to the horses, the ground you starts to tremble. You lose balance and hear somethong crash outside the stable.",
  //   //       "Will you check it out?",
  //   //       left: Node(
  //   //         "Yes",
  //   //         "As you go out you seem to be blinded by the bright light casted onto your eyes. On the eye of the blinding golden light is a staff adorned on gold. A sensation that is almost numbing surges through your body. A feeling as if the staff is synchronising with your hands, and suddenly your body starts moving on its own. Your hands reach out to pick the staff.",
  //   //         "Do you choose to take it?",
  //   //         left: Node(
  //   //           "Yes",
  //   //           "Suddenly you hear growling sounds from your stomach. You come to the realisation that you are hungry and also that the staff in your hands are not as heavy as it seems to be. But that wasn\'t it. Along with the fact that you feel taller, nimbler and also suppringly strong. You enter the stable to fix yourself a uick breakfast, but you tumble over a bucket. Even thought that fall must have brooken your frail body....\n\tYou realise you remain unharmed and that the bucket was in a rather pitigul state. Crushed and mangled under your legs. Four armed men swords enter the stable. The man in a armour distinct from others says,\"I am Going to have to take the staff from you. We can do it the easy way or the hard way.\"",
  //   //           "Do you want to hand him the staff?",
  //   //           left: Node("Yes", "To be Continued ...", "Start Again?"),
  //   //           right: Node("No", "To be Continued ...", "Start Again?"),
  //   //         ),
  //   //         right: Node("No", "The End", "Start Again?"),
  //   //       ),
  //   //       right: Node("No", "The End", "Start Again?"),
  //   //     ),
  //   // );
  // }
}
