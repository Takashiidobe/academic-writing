== Structured Bindings
<structured-bindings>
C++17 added a feature called structured bindings which allow you to
unpack a tuple or other objects into multiple variables. This might look
like this:

```cpp
int main() {
    std::tuple<int, int> t = {10, 20};
    const auto [first, second] = t;
    std::cout << first << ", " << second << '\n';
}
```

We can also implement them for our own classes by implementing a tuple
specialization and get for each element.

```cpp
#include <string>
#include <tuple>
#include <iostream>

struct Person {
   int a;
   std::string b;
};

namespace std {
   template<>
   struct tuple_size<Person>
    : std::integral_constant<std::size_t, 3> { };

   template<>
   struct tuple_element<0, Person> {
       using type = int;
   };

   template<>
   struct tuple_element<1, Person> {
       using type = std::string;
   };
}

template<std::size_t i>
auto get(const Person& s) {
   if constexpr (i == 0) {
       return s.a;
   } else if constexpr (i == 1) {
       return s.b;
   } else {
       // just panic?
   }
}

int main() {
    Person s{1, "hi"};

    auto [a, b] = s;

    std::cout << "a=" << a << " b=" << b << std::endl;
}
```
