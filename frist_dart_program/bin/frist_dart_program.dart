void main() {
  // Variables
  String name = "Ali";
  int age = 20;
  String city = "Lahore";

  // Output
  print("Welcome $name from $city!");
  // Control Flow
  if (age >= 18) {
    print("You are eligible to register.");
  } else {
    print("You must be 18+ to register.");
  }
  // Collections
  List<String> hobbies = ['Reading', 'Coding', 'Music'];
  Set<String> subjects = {'Math', 'Science', 'Math'}; // Set removes duplicates
  // Map for student info
  Map<String, dynamic> student = {
    'name': name,
    'age': age,
    'city': city,
  };
  // Functions
  void greet(String name) {
    print("Hello, $name!");
  }
  int square1(int x){
    return x*x;
  }
  int square(int x) => x * x;
  // Function Calls
  greet(name);
  print("Your age squared is: ${square(age)}");
}




























// void fun( {int num=0, String name=" "}){
//   print("sdfadsfasd $num   name $name");
// }
// void main(){
//
//
//   // fun();
//   //named parameters
//   //Positional parameters
//
//
//   // List <String> fruits = ['Apple', 'Banana', 'Mango'];
//   // Map<int, List> student = {
//   //   // 'name': 'Ali',
//   //   // 'roll': '101',
//   //   1: fruits
//   // };
//   //print(student[1]); // Ali
//
//
//   // List <String> fruits = ['Apple', 'Banana', 'Mango'];
//   // print(fruits); // Apple
// }