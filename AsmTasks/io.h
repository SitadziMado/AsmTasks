#pragma once

#include <iostream>
#include <limits>
#include <string>
#include <utility>
#include <vector>

template<typename T = std::string>
T input(
    const std::string& prompt = "", 
    const std::string& failed = "Error occured while parsing. Try again...."
)
{
    if (prompt.size())
        std::cout << prompt << " ";

    T result;

    while (!(std::cin >> result))
    {
        std::cout << failed << std::endl;

        std::cin.clear();
        std::cin.ignore(std::numeric_limits<size_t>::max(), '\n');
    }

    std::cin.ignore(std::numeric_limits<size_t>::max(), '\n');

    return result;
}

template<typename T, typename... Ts> struct Printer;

template<typename T>
struct Printer<T>
{
    void operator()(T&& arg)
    {
        std::cout << std::forward<T>(arg) << " ";
    }
};

template<typename T, typename... Ts>
struct Printer
{
    void operator()(T&& first, Ts&&... rest)
    {
        Printer<T>()(std::forward<T>(first));
        Printer<Ts...>()(std::forward<Ts>(rest)...);
    }
};

void print()
{
    std::cout << std::endl;
}

template<typename... Ts>
void print(Ts&&... args)
{
    Printer<Ts...>()(std::forward<Ts>(args)...);
    print();
}

template<typename T>
std::ostream& operator<<(std::ostream& stream, const std::vector<T>& vec)
{
    stream << "[ ";

    for (auto a : vec)
        stream << a << "; ";

    stream << "]";

    return stream;
}