#pragma once

static_assert(
    sizeof(size_t) == 4U, 
    "Программа может компилироваться только на 32-битные системы."
);

using std::size_t;

namespace asm_funcs
{
    class ShortSet
    {
    public:
        static constexpr size_t Size = 65536U;

        ShortSet();

        ShortSet& operator+=(const ShortSet& rhs);
        ShortSet& operator-=(const ShortSet& rhs);
        ShortSet& operator*=(const ShortSet& rhs);

        bool find(short item) const;
        void insert(short item);
        void remove(short item);

    private:
        std::vector<size_t> data_;
    };

    const ShortSet& operator+(const ShortSet& lhs, const ShortSet& rhs);
    const ShortSet& operator-(const ShortSet& lhs, const ShortSet& rhs);
    const ShortSet& operator*(const ShortSet& lhs, const ShortSet& rhs);

    extern "C"
    {
        // #1

        extern bool saddle_element(
            const long* data,
            size_t width,
            size_t height,
            size_t* x,
            size_t* y
        );

        // #2

        extern bool atoi(
            long* number,
            const char* src
        );

        // #3

        extern const char* itoa(
            char* dst,
            long number,
            long base = 10
        );

        // #4

        extern const char* bcd_add(
            char* result_buffer,
            const char* first,
            const char* second
        );

        // #5

        extern const char* bcd_sub(
            char* result_buffer,
            const char* first,
            const char* second
        );

        // #6

        extern int bcd_cmp(
            const char* first,
            const char* second
        );

        // #7

        extern const void* memset(
            void* dst,
            int value,
            size_t size
        );

        extern const long* scale_copy(
            long* dst,
            const long* src,
            size_t size,
            size_t scale_factor
        );

        extern const char* strstr(
            const char* string,
            const char* substring
        );

        extern int wstrcmp(
            const wchar_t* lhs,
            const wchar_t* rhs,
            size_t* index
        );

        // #8

        extern const char* encrypt(
            char* string
        );

        extern const char* decrypt(
            char* string
        );

        // #9



        // #10
        extern long long mul_by_2n(
            long lhs,
            long two_pow_n,
            bool* success
        );

        extern long div_by_2n(
            long lhs,
            long two_pow_n,
            bool* success
        );
    }
}