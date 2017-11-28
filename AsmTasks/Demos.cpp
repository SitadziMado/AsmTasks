#include "stdafx.h"
#include "Demos.h"

#include "AsmFuncs.h"
#include "Io.h"

using std::cin;
using std::cout;

static constexpr size_t BufferSize = 256U;

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
        ? ("Equal")
        : ((cmp > 0)
            ? ("First > Second")
            : ("First < Second"))
    );

    return true;
}

bool runStrings()
{
    cls();

    auto size = input<int>("Enter array size:", 1);
    char fillWith = input<char>("Enter a character to fill with:");
    auto factor = input<int>("Enter scale factor:", 1);
    auto toFind = input<int>("Enter an element to find:");
    auto firstString = input("Enter a string 1:");
    auto secondString = input("Enter a string 2:");
    auto substring = input("Enter a substring:");

    std::vector<int> initial;

    auto engine = std::mt19937{ std::random_device()() };
    std::uniform_int_distribution<int> rnd{};

    initial.resize(size);

    std::for_each(
        initial.begin(),
        initial.end(),
        [&rnd, &engine](int& x) { x = rnd(engine); }
    );

    print("Initial array:", initial);
    print();

    asm_funcs::memset(initial.data(), fillWith, initial.size() * sizeof(int));

    print("After filling with the character:", initial);
    print();

    auto scaled = std::vector<int>(initial.size() * factor, 0);

    asm_funcs::scale_copy(scaled.data(), initial.data(), initial.size(), factor);

    print("After scaling:", scaled);
    print();

    size_t first, last;

    if (asm_funcs::first_last_of(toFind, initial.data(), initial.size(), &first, &last))
    {
        print("Indices of first & last occurences:", first, " ", last);
    }

    auto ptr = asm_funcs::strstr(firstString.data(), substring.data());

    if (ptr != nullptr)
        print("Index of substring beginning in the string 1:", ptr - firstString.data());

    std::wstring wFirstString{ firstString.cbegin(), firstString.cend() };
    std::wstring wSecondString{ secondString.cbegin(), secondString.cend() };
    size_t index;

    switch (asm_funcs::wstrcmp(wFirstString.data(), wSecondString.data(), &index))
    {
    case -1:
        print("String 1 < string 2");
        print("Mismatch index:", index);
        break;

    case 0:
        print("String 1 == string 2");
        break;

    case 1:
        print("String 1 > string 2");
        print("Mismatch index:", index);
        break;

    default:
        break;
    }

    return true;
}

bool runCrypt()
{
    cls();

    auto string = input("Enter a string (ASCII-only):");

    asm_funcs::encrypt(string.data());
    print("Encrypted string:", string);

    asm_funcs::decrypt(string.data());
    print("Decrypted string:", string);

    return true;
}

bool runSets()
{
    using asm_funcs::ShortSet;

    cls();

    auto fst = input("Input elements of a set 1:");
    auto snd = input("Input elements of a set 2:");

    std::stringstream ss{ fst };

    ShortSet fstSet;

    while (!ss.eof())
    {
        short t;
        ss >> t;
        fstSet.insert(t);
    }

    ss = std::stringstream(snd);
    ShortSet sndSet;

    while (!ss.eof())
    {
        short t;
        ss >> t;
        sndSet.insert(t);
    }

    ShortSet un{ fstSet };
    un += sndSet;

    ShortSet diff{ fstSet };
    diff -= sndSet;

    ShortSet inter{ fstSet };
    inter *= sndSet;

    auto toFind = input<short>("Enter an element to find in set 1:");

    bool found = fstSet.find(toFind);

    print("Is found:", found);

    print("Union:", un);
    print();

    print("Difference:", diff);
    print();

    print("Intersection:", inter);

    return true;
}

bool runMulDiv()
{
    cls();

    auto first = input<long>("Enter a number:");
    auto second = input<long>("Enter a power of 2:");

    bool mulSuccess;

    auto mulResult = asm_funcs::mul_by_2n(first, second, &mulSuccess);

    bool divSuccess;

    auto divResult = asm_funcs::div_by_2n(first, second, &divSuccess);

    if (mulSuccess && divSuccess)
    {
        print("Result of multiplication:", mulResult);
        print("Result of division:", divResult);
        return true;
    }

    return false;
}