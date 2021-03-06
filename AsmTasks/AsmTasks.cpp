#include "stdafx.h"

#include "AsmFuncs.h"
#include "Demos.h"
#include "Io.h"

bool test();

using std::cin;
using std::cout;

int main(int argc, char** argv)
{
    std::vector<std::pair<std::string, std::function<bool()>>> procs{
        { "1. Run [Char] -> Int conversion", runAtoi },
        { "2. Run Int -> [Char] conversion", runItoa },
        { "3. Run BCD number demo", runBcd },
        { "4. Run strings procedures demo", runStrings },
        { "5. Run cryptography demo", runCrypt },
        { "6. Run sets demo", runSets },
        { "7. Run mul & div by power of 2 demo", runMulDiv },
    };

    auto help = [&procs] {
        print("0. Exit");

        for (const auto& a : procs)
            print(a.first);        
        print("***************");
    };

    help();

    int command;

    while ((command = input<int>("Enter a command:", 0, 7, "Enter a valid command")) != 0)
    {
        if (!procs[command - 1].second())
        {
            cls();
            print("Something went wrong, try once more...");         
            std::system("pause");
        }
        else
        {
            std::system("pause");
            cls();
        }

        help();
    }

    print("\nThank you for using the program! Good luck!");

    return 0;
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
