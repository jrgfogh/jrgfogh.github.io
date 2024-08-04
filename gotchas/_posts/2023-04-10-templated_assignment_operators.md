# C++ Gotcha: Templated Assignment Operators

Consider the following example:

```c++
#include <iostream>

template <typename T>
class Foo
{
public:
	template <typename U>
	Foo &operator=(Foo<U> const &that)
	{
		std::cout << "Overloaded operator called!" << std::endl;
		return *this;
	}
};

int main(int argc, char **argv)
{
	Foo<int> a;
	Foo<int> b;
	b = a; // Not a call to the overloaded assignment!
}
```

You might expect this program to output `"Overloaded operator called!"`, since `a` is a valid argument for the templated assignment operator.
Alas, the program outputs nothing.

The reason is explained in the C++20 standard, Footnote 108, p. 273:
> Because a template assignment operator or an assignment operator taking an rvalue reference parameter is never a
copy assignment operator, the presence of such an assignment operator does not suppress the implicit declaration of a copy
assignment operator. Such assignment operators participate in overload resolution with that assignment operators, including
copy assignment operators, and, if selected, will be used to assign an object.

In other words, another assignment operator is implicitly defined and it is this operator, which is actually called.

To get the expected behavior, simply delegate the copy assignment to the templated assignment operator:

```c++
Foo &operator=(Foo const &that)
{
	return operator=<T>(that);
}
```

This implementation ensures that both operators are always consistent.