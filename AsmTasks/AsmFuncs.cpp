#include "stdafx.h"
#include "AsmFuncs.h"

namespace asm_funcs
{
    extern "C" {
        extern size_t* _union(
            size_t* dst_set,
            const size_t* src_set
        );

        extern size_t* _difference(
            size_t* dst_set,
            const size_t* src_set
        );

        extern size_t* _intersection(
            size_t* dst_set,
            const size_t* src_set
        );

        extern size_t* _find(
            const size_t* dst_set,
            unsigned short item
        );

        extern void _insert(
            size_t* dst_set,
            unsigned short item
        );

        extern void _remove(
            size_t* dst_set,
            unsigned short item
        );
    }

    ShortSet::ShortSet() :
        data_(Size / (8 * sizeof(decltype(data_)::value_type)))
    {
    }

    ShortSet& ShortSet::operator+=(const ShortSet& rhs)
    {
        _union(
            data_.data(),
            rhs.data_.data()
        );
        return *this;
    }

    ShortSet& ShortSet::operator-=(const ShortSet& rhs)
    {
        _difference(
            data_.data(),
            rhs.data_.data()
        );
        return *this;
    }

    ShortSet& ShortSet::operator*=(const ShortSet& rhs)
    {
        _intersection(
            data_.data(),
            rhs.data_.data()
        );
        return *this;
    }

    bool ShortSet::find(short item) const
    {
        auto result = _find(
            data_.data(),
            static_cast<unsigned short>(item)
        );
        return result;
    }

    void ShortSet::insert(short item)
    {
        _insert(
            data_.data(),
            static_cast<unsigned short>(item)
        );
    }

    void ShortSet::remove(short item)
    {
        _remove(
            data_.data(),
            static_cast<unsigned short>(item)
        );
    }

    const ShortSet& asm_funcs::operator+(const ShortSet& lhs, const ShortSet& rhs)
    {
        return ShortSet(lhs) += rhs;
    }

    const ShortSet& operator-(const ShortSet& lhs, const ShortSet& rhs)
    {
        return ShortSet(lhs) -= rhs;
    }

    const ShortSet& operator*(const ShortSet& lhs, const ShortSet& rhs)
    {
        return ShortSet(lhs) *= rhs;
    }
}