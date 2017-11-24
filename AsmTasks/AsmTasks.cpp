#include "stdafx.h"

#include "AsmFuncs.h"
#include "io.h"

static constexpr size_t BufferSize = 256U;

bool test();

void cls();

bool runAtoi();
bool runItoa();
bool runBcd();
bool runStrings();

/* int main()
{
    using std::cin;
    using std::cout;
    using asm_funcs::ShortSet;

    assert(test());

    {
        auto l = "1234";
        auto r = "9993";
        char result[64];

        asm_funcs::bcd_add(result, l, r);
        asm_funcs::bcd_add(result, result, r);
        asm_funcs::bcd_add(result, result, r);
        asm_funcs::bcd_add(result, result, r);

        asm_funcs::bcd_sub(result, l, r);
        asm_funcs::bcd_sub(result, l, r);
    }

    ShortSet set1 = ShortSet();

    set1.insert(1);
    set1.insert(5);
    set1.insert(3);
    set1.insert(2);

    ShortSet set2 = ShortSet();

    set2.insert(-5);
    set2.insert(1);
    set2.insert(7);
    set2.insert(9);

    auto un{ set1 };
    un += set2;

    auto dif{ set1 };
    dif -= set2;
    auto inter{ set1 };
    inter *= set2;

    auto found = inter.find(1);

    found = inter.find(5);

    found = inter.find(7);
    found = inter.find(9);

    bool success = true;

    long matrix[] = {
        2, 3, 5, 2,
        2, 4, 6, 2,
        -2, 7, 2, 0
    };

    size_t x, y;

    auto istheresaddleelem = asm_funcs::saddle_element(matrix, 4, 3, &x, &y);

    auto tup = input<std::string>("Input an int, please: ");

    long number;

    auto ok = asm_funcs::atoi(&number, std::get<0>(tup).data());

    char buffer[128];

    auto c = asm_funcs::itoa(buffer, number, 2);
    cout << c << std::endl;
    c = asm_funcs::itoa(buffer, number);
    cout << c << std::endl;

    auto number1 = "15";
    auto number2 = "100015";
    char numberres[64];

    auto resresres = asm_funcs::bcd_add(numberres, number1, number2);

    auto fff = "300";
    auto sss = "400";

    auto fffres = asm_funcs::bcd_cmp(fff, sss);
    fffres = asm_funcs::bcd_cmp(number1, number2);
    
    asm_funcs::bcd_sub(numberres, number1, number2);

    long unscaled[] = { 1, 5, 6, 7, 8, 9, 4, 5 };
    long scaled[32];

    asm_funcs::scale_copy(scaled, unscaled, 8, 4);

    asm_funcs::memset(numberres, '@', 64);

    auto first = "Hello, WoWorld!";
    auto sub = "World";

    auto isFnd = asm_funcs::strstr(first, sub);

    auto lhs = L"Cherry Wine";
    auto rhs = L"Cherry Vino";
    size_t cmpIndex = 0U;

    auto cmpres = asm_funcs::wstrcmp(lhs, rhs, &cmpIndex);

    char unlhs[] = "Hello, World!";

    asm_funcs::encrypt(unlhs);
    asm_funcs::decrypt(unlhs);

    auto prod = asm_funcs::mul_by_2n(1000000000, 128, &success);
    auto res = asm_funcs::div_by_2n(1000000000, 64, &success);

    cout << prod << std::endl;
    cout << res << std::endl;
    cout << (1000000000 / 64);

    return 0;
} */

using std::cin;
using std::cout;

int main(int argc, char** argv)
{
    // runAtoi();
    // runItoa();
    // runBcd();
    runStrings();

    return 0;
}

void cls()
{
#ifdef _WIN32
    std::system("cls");
#else
#error Only WIN32 is supported.
#endif
}

bool runAtoi()
{
    cls();

    auto number = input("Enter a number:");

    long n;

    bool success = asm_funcs::atoi(&n, number.data());

    if (success)
        print("Result:", n);
    else
        print("Not a number");

    return success;
}

bool runItoa()
{
    cls();

    auto number = input<long>("Enter an integer:");

    auto buffer = std::vector<char>(BufferSize, '\0');

    asm_funcs::itoa(buffer.data(), number, 2);
    print("Binary value:", buffer.data());

    asm_funcs::itoa(buffer.data(), number, 8);
    print("Octal value:", buffer.data());

    asm_funcs::itoa(buffer.data(), number);
    print("Decimal value:", buffer.data());

    asm_funcs::itoa(buffer.data(), number, 16);
    print("Hexadecimal value:", buffer.data());

    return true;
}

bool runBcd()
{
    cls();

    auto first = input("Enter a first BCD number:");
    auto second = input("Enter a second BCD number:");

    std::reverse(
        first.begin(),
        first.end()
    );

    std::reverse(
        second.begin(),
        second.end()
    );

    auto buffer = std::vector<char>(
        std::max(first.size(), second.size()) + 4U
    );

    asm_funcs::bcd_add(
        buffer.data(),
        first.data(),
        second.data()
    );

    auto it = std::find(
        buffer.begin(),
        buffer.end(),
        '\0'
    );

    std::reverse(
        buffer.begin(),
        it
    );

    print("Sum of 2 BCD numbers:", buffer.data());

    asm_funcs::bcd_sub(
        buffer.data(),
        first.data(),
        second.data()
    );

    it = std::find(
        buffer.begin(),
        buffer.end(),
        '\0'
    );

    std::reverse(
        buffer.begin(),
        it
    );

    print("Difference of 2 BCD numbers:", buffer.data());

    auto cmp = asm_funcs::bcd_cmp(
        first.data(),
        second.data()
    );

    print(
        "Compare 2 BCD numbers:", 
        (cmp == 0) 
        ?         ("Equal") 
        : ((cmp > 0) 
            ? ("First > Second") 
            : ("First < Second"))
    );

    return true;
}

bool runStrings()
{


    return true;
}

bool test()
{
    auto number = input();

    long num;
    asm_funcs::atoi(&num, number.data());

    char bin[64];
    char oct[64];
    char dec[64];
    char hex[64];

    asm_funcs::itoa(bin, num, 2);
    asm_funcs::itoa(oct, num, 8);
    asm_funcs::itoa(dec, num);
    asm_funcs::itoa(hex, num, 16);

    std::cout << "Binary value: " << bin << std::endl;
    std::cout << "Octal value: " << oct << std::endl;
    std::cout << "Decimal value: " << dec << std::endl;
    std::cout << "Hexadecimal value: " << hex << std::endl;

    return true;
}
