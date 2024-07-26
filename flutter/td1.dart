
// Exercice 2
void main() {
      int number = 2;
// Compl ́etez le code ici 
  if (number % 2 == 0){
    print("Even");
  }
  else {
    print("old");
  }
  
  number % 2 == 0 ?  print("Even") : print("old");
}


//  Exo 3
void main() {
  List<String> fruits = ["Apple", "Banana", "Orange"];
  
  print(fruits[1]);
}


// exo 4
int calculateArea(int lng, int largeur){
   return lng * largeur;
 }

void main() {
 print(calculateArea(2, 3)); 
}

// exo 5
class Person {
  String name;
  int age;
  Person(this.name, this.age);
  void greet() {
    print("Hello, my name is $name and I am $age years old.");
  }
}

void main() {
  var person = new Person("Alice", 30);
  // var person = Person("Alice", 30);

  person.greet();
}


// Exo 6
void main() {
  for (var i = 0; i <= 10; i++) {
    print(i);
  }
}
