/*
 *  Copyright 2008-2011 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */


/*! \file binary_search.inl
 *  \brief Inline file for binary_search.h.
 */

#include <thrust/detail/config.h>
#include <thrust/binary_search.h>
#include <thrust/iterator/iterator_traits.h>

#include <thrust/detail/backend/generic/select_system.h>
#include <thrust/detail/backend/generic/binary_search.h>

// XXX make the backend-specific versions available
// XXX try to eliminate the need for these
#include <thrust/system/cpp/detail/binary_search.h>
#include <thrust/system/omp/detail/binary_search.h>

namespace thrust
{

//////////////////////
// Scalar Functions //
//////////////////////

template <class ForwardIterator, class LessThanComparable>
ForwardIterator lower_bound(ForwardIterator first, 
                            ForwardIterator last,
                            const LessThanComparable& value)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::lower_bound;

    typedef typename thrust::iterator_space<ForwardIterator>::type space; 

    return lower_bound(select_system(space()), first, last, value);
}

template <class ForwardIterator, class T, class StrictWeakOrdering>
ForwardIterator lower_bound(ForwardIterator first,
                            ForwardIterator last,
                            const T& value, 
                            StrictWeakOrdering comp)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::lower_bound;

    typedef typename thrust::iterator_space<ForwardIterator>::type space; 

    return lower_bound(select_system(space()), first, last, value, comp);
}

template <class ForwardIterator, class LessThanComparable>
ForwardIterator upper_bound(ForwardIterator first, 
                            ForwardIterator last,
                            const LessThanComparable& value)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::upper_bound;

    typedef typename thrust::iterator_space<ForwardIterator>::type space;

    return upper_bound(select_system(space()), first, last, value);
}

template <class ForwardIterator, class T, class StrictWeakOrdering>
ForwardIterator upper_bound(ForwardIterator first,
                            ForwardIterator last,
                            const T& value, 
                            StrictWeakOrdering comp)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::upper_bound;

    typedef typename thrust::iterator_space<ForwardIterator>::type space;

    return upper_bound(select_system(space()), first, last, value, comp);
}

template <class ForwardIterator, class LessThanComparable>
bool binary_search(ForwardIterator first, 
                   ForwardIterator last,
                   const LessThanComparable& value)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::binary_search;

    typedef typename thrust::iterator_space<ForwardIterator>::type space;

    return binary_search(select_system(space()), first, last, value);
}

template <class ForwardIterator, class T, class StrictWeakOrdering>
bool binary_search(ForwardIterator first,
                   ForwardIterator last,
                   const T& value, 
                   StrictWeakOrdering comp)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::binary_search;

    typedef typename thrust::iterator_space<ForwardIterator>::type space;

    return binary_search(select_system(space()), first, last, value, comp);
}

template <class ForwardIterator, class LessThanComparable>
thrust::pair<ForwardIterator, ForwardIterator>
equal_range(ForwardIterator first,
            ForwardIterator last,
            const LessThanComparable& value)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::equal_range;

    typedef typename thrust::iterator_space<ForwardIterator>::type space;

    return equal_range(select_system(space()), first, last, value);
}

template <class ForwardIterator, class T, class StrictWeakOrdering>
thrust::pair<ForwardIterator, ForwardIterator>
equal_range(ForwardIterator first,
            ForwardIterator last,
            const T& value,
            StrictWeakOrdering comp)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::equal_range;

    typedef typename thrust::iterator_space<ForwardIterator>::type space;

    return equal_range(select_system(space()), first, last, value, comp);
}

//////////////////////
// Vector Functions //
//////////////////////

template <class ForwardIterator, class InputIterator, class OutputIterator>
OutputIterator lower_bound(ForwardIterator first, 
                           ForwardIterator last,
                           InputIterator values_first, 
                           InputIterator values_last,
                           OutputIterator output)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::lower_bound;

    typedef typename thrust::iterator_space<ForwardIterator>::type space1;
    typedef typename thrust::iterator_space<InputIterator>::type   space2;
    typedef typename thrust::iterator_space<OutputIterator>::type  space3;

    return lower_bound(select_system(space1(),space2(),space3()), first, last, values_first, values_last, output);
}

template <class ForwardIterator, class InputIterator, class OutputIterator, class StrictWeakOrdering>
OutputIterator lower_bound(ForwardIterator first, 
                           ForwardIterator last,
                           InputIterator values_first, 
                           InputIterator values_last,
                           OutputIterator output,
                           StrictWeakOrdering comp)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::lower_bound;

    typedef typename thrust::iterator_space<ForwardIterator>::type space1;
    typedef typename thrust::iterator_space<InputIterator>::type   space2;
    typedef typename thrust::iterator_space<OutputIterator>::type  space3;

    return lower_bound(select_system(space1(),space2(),space3()), first, last, values_first, values_last, output, comp);
}
    
template <class ForwardIterator, class InputIterator, class OutputIterator>
OutputIterator upper_bound(ForwardIterator first, 
                           ForwardIterator last,
                           InputIterator values_first, 
                           InputIterator values_last,
                           OutputIterator output)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::upper_bound;

    typedef typename thrust::iterator_space<ForwardIterator>::type space1;
    typedef typename thrust::iterator_space<InputIterator>::type   space2;
    typedef typename thrust::iterator_space<OutputIterator>::type  space3;

    return upper_bound(select_system(space1(),space2(),space3()), first, last, values_first, values_last, output);
}

template <class ForwardIterator, class InputIterator, class OutputIterator, class StrictWeakOrdering>
OutputIterator upper_bound(ForwardIterator first, 
                           ForwardIterator last,
                           InputIterator values_first, 
                           InputIterator values_last,
                           OutputIterator output,
                           StrictWeakOrdering comp)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::upper_bound;

    typedef typename thrust::iterator_space<ForwardIterator>::type space1;
    typedef typename thrust::iterator_space<InputIterator>::type   space2;
    typedef typename thrust::iterator_space<OutputIterator>::type  space3;

    return upper_bound(select_system(space1(),space2(),space3()), first, last, values_first, values_last, output, comp);
}

template <class ForwardIterator, class InputIterator, class OutputIterator>
OutputIterator binary_search(ForwardIterator first, 
                             ForwardIterator last,
                             InputIterator values_first, 
                             InputIterator values_last,
                             OutputIterator output)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::binary_search;

    typedef typename thrust::iterator_space<ForwardIterator>::type space1;
    typedef typename thrust::iterator_space<InputIterator>::type   space2;
    typedef typename thrust::iterator_space<OutputIterator>::type  space3;

    return binary_search(select_system(space1(),space2(),space3()), first, last, values_first, values_last, output);
}

template <class ForwardIterator, class InputIterator, class OutputIterator, class StrictWeakOrdering>
OutputIterator binary_search(ForwardIterator first, 
                             ForwardIterator last,
                             InputIterator values_first, 
                             InputIterator values_last,
                             OutputIterator output,
                             StrictWeakOrdering comp)
{
    using thrust::detail::backend::generic::select_system;
    using thrust::detail::backend::generic::binary_search;

    typedef typename thrust::iterator_space<ForwardIterator>::type space1;
    typedef typename thrust::iterator_space<InputIterator>::type   space2;
    typedef typename thrust::iterator_space<OutputIterator>::type  space3;

    return binary_search(select_system(space1(),space2(),space3()), first, last, values_first, values_last, output, comp);
}

} // end namespace thrust

