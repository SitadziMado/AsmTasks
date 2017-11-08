#include "stdafx.h"

#include "AsmFuncs.h"
#include "IOWrappers.h"

int main()
{
    using std::cin;
    using std::cout;

    bool success = true;

    char numres[32];
    auto num1 = "10";
    auto num2 = "10";

    auto resnum = asm_funcs::bcd_sub(numres, num1, num2);

    auto first = "Hello, WoWorld!";
    auto sub = "World";

    auto isFnd = asm_funcs::strstr(first, sub);

    auto lhs = L"Cherry Wine";
    auto rhs = L"Cherry Wine";
    size_t cmpIndex = 0U;

    auto cmpres = asm_funcs::wstrcmp(lhs, rhs, &cmpIndex);

    auto prod = asm_funcs::mul_by_2n(1000000000, 128, &success);
    auto res = asm_funcs::div_by_2n(1000000000, 64, &success);

    cout << prod << std::endl;
    cout << res << std::endl;
    cout << (1000000000 / 64);
    
    auto [tup] = input<std::string>("Input an int, please: ");

    long number;

    auto ok = asm_funcs::atoi(&number, tup.data());

    char buffer[32];

    auto c = asm_funcs::itoa(buffer, number, 2);

    cout << c;

    return 0;
}