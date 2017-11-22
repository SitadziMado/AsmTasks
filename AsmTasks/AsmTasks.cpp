#include "stdafx.h"

#include "AsmFuncs.h"
#include "IOWrappers.h"

int main()
{
    using std::cin;
    using std::cout;
    using asm_funcs::ShortSet;

    {
        auto l = "1033";
        auto r = "1234";
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
        1, 2, 3,
        4, 7, 9,
        5, 9, 6,
    };

    size_t x, y;

    auto istheresaddleelem = asm_funcs::saddle_element(matrix, 3, 3, &x, &y);

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

    auto resresres = asm_funcs::bcd_add(numberres, number1, number1);

    auto fff = "300";
    auto sss = "100";

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
}