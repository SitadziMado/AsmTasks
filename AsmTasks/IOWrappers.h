#pragma once

#include <iosfwd>
#include <string>
#include <utility>

namespace
{
    template<typename T, typename... Ts> struct InputImpl;

    template<typename T>
    struct InputImpl<T>
    {
        std::tuple<T> operator()(const std::string& repeat)
        {
            using std::cin;
            using std::cout;

            T t;

            while (!(cin >> t))
            {
                cout << repeat << std::endl;
                cin.clear();
                cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            }

            return { t };
        }
    };

    template<typename T, typename... Ts>
    struct InputImpl
    {
        std::tuple<T, Ts...> operator()(const std::string& repeat)
        {
            auto first = InputImpl<T>()(repeat);

            return std::tuple_cat(
                first,
                InputImpl<Ts...>()(repeat)
            );
        }
    };

    template<typename T, typename... Ts> struct OutputImpl;

    template<typename T>
    struct OutputImpl<T>
    {
        void operator()(
            const std::string& delimeter,
            const T& value
        )
        {
            std::cout << value << std::endl;
        }
    };

    template<typename T, typename... Ts>
    struct OutputImpl
    {
        void operator()(
            const std::string& delimeter,
            const T& value,
            const Ts&... args
        )
        {
            std::cout << value << delimeter;
            OutputImpl<Ts...>()(delimeter, args...);
        }
    };
}

template<typename T, typename... Ts>
std::tuple<T, Ts...> input(
    const std::string& prompt,
    const std::string& repeat = "Please enter correct value."
)
{
    std::cout << prompt << std::endl;

    return InputImpl<T, Ts...>()(repeat);
}

template<typename... Ts>
void print(
    const std::string& prompt,
    const std::string& delimeter,
    const Ts&... args
)
{
    if (prompt.size())
        std::cout << prompt;

    OutputImpl<Ts...>()(delimeter, args...);
}

template<typename... Ts>
void print(
    const std::string& delimeter,
    const Ts&... args
)
{
    print("", delimeter, args...);
}

template<typename... Ts>
void print(const Ts&... args)
{
    print("", ", ", args...);
}