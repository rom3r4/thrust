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

#include <thrust/detail/config.h>
#include <thrust/detail/type_traits.h>
#include <thrust/iterator/iterator_traits.h>
#include <thrust/system/cpp/detail/dispatch/sort.h>

namespace thrust
{
namespace system
{
namespace cpp
{
namespace detail
{

template<typename RandomAccessIterator,
         typename StrictWeakOrdering>
void stable_sort(tag,
                 RandomAccessIterator first,
                 RandomAccessIterator last,
                 StrictWeakOrdering comp)
{
  typedef typename thrust::iterator_traits<RandomAccessIterator>::value_type KeyType;
  static const bool use_radix_sort = thrust::detail::is_arithmetic<KeyType>::value &&
                                     (thrust::detail::is_same<StrictWeakOrdering, typename thrust::less<KeyType> >::value ||
                                      thrust::detail::is_same<StrictWeakOrdering, typename thrust::greater<KeyType> >::value);

  // supress unused variable warning
  (void) use_radix_sort;

  thrust::system::cpp::detail::dispatch::stable_sort
    (first, last, comp, 
      thrust::detail::integral_constant<bool, use_radix_sort>());
}

template<typename RandomAccessIterator1,
         typename RandomAccessIterator2,
         typename StrictWeakOrdering>
void stable_sort_by_key(tag,
                        RandomAccessIterator1 first1,
                        RandomAccessIterator1 last1,
                        RandomAccessIterator2 first2,
                        StrictWeakOrdering comp)
{
  typedef typename thrust::iterator_traits<RandomAccessIterator1>::value_type KeyType;
  static const bool use_radix_sort = thrust::detail::is_arithmetic<KeyType>::value &&
                                     (thrust::detail::is_same<StrictWeakOrdering, typename thrust::less<KeyType> >::value ||
                                      thrust::detail::is_same<StrictWeakOrdering, typename thrust::greater<KeyType> >::value);

  // supress unused variable warning
  (void) use_radix_sort;

  thrust::system::cpp::detail::dispatch::stable_sort_by_key
    (first1, last1, first2, comp, 
      thrust::detail::integral_constant<bool, use_radix_sort>());
}

} // end namespace detail
} // end namespace cpp
} // end namespace system
} // end namespace thrust
