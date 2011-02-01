#include <unittest/unittest.h>
#include <thrust/set_operations.h>
#include <thrust/functional.h>
#include <thrust/sort.h>

template<typename Vector>
void TestSetSymmetricDifferenceSimple(void)
{
  typedef typename Vector::iterator Iterator;

  Vector a(4), b(5);

  a[0] = 0; a[1] = 2; a[2] = 4; a[3] = 6;
  b[0] = 0; b[1] = 3; b[2] = 3; b[3] = 4; b[4] = 7;

  Vector ref(5);
  ref[0] = 2; ref[1] = 3; ref[2] = 3; ref[3] = 6; ref[4] = 7;

  Vector result(5);

  Iterator end = thrust::set_symmetric_difference(a.begin(), a.end(),
                                                  b.begin(), b.end(),
                                                  result.begin());

  ASSERT_EQUAL_QUIET(result.end(), end);
  ASSERT_EQUAL(ref, result);
}
DECLARE_VECTOR_UNITTEST(TestSetSymmetricDifferenceSimple);


template<typename T>
void TestSetSymmetricDifference(const size_t n)
{
  thrust::host_vector<T> temp = unittest::random_integers<T>(2 * n);
  thrust::host_vector<T> h_a(temp.begin(), temp.begin() + n);
  thrust::host_vector<T> h_b(temp.begin() + n, temp.end());

  thrust::sort(h_a.begin(), h_a.end());
  thrust::sort(h_b.begin(), h_b.end());

  thrust::device_vector<T> d_a = h_a;
  thrust::device_vector<T> d_b = h_b;

  thrust::host_vector<T> h_result(h_a.size() + h_b.size());
  thrust::device_vector<T> d_result(h_result.size());

  typename thrust::host_vector<T>::iterator h_end;
  typename thrust::device_vector<T>::iterator d_end;
  
  h_end = thrust::set_symmetric_difference(h_a.begin(), h_a.end(),
                                           h_b.begin(), h_b.end(),
                                           h_result.begin());
  h_result.erase(h_end, h_result.end());

  d_end = thrust::set_symmetric_difference(d_a.begin(), d_a.end(),
                                           d_b.begin(), d_b.end(),
                                           d_result.begin());
  d_result.erase(d_end, d_result.end());

  ASSERT_EQUAL(h_result, d_result);
}
DECLARE_VARIABLE_UNITTEST(TestSetSymmetricDifference);


template<typename T>
void TestSetSymmetricDifferenceEquivalentRanges(const size_t n)
{
  thrust::host_vector<T> temp = unittest::random_integers<T>(n);
  thrust::host_vector<T> h_a = temp; thrust::sort(h_a.begin(), h_a.end());
  thrust::host_vector<T> h_b = h_a;

  thrust::device_vector<T> d_a = h_a;
  thrust::device_vector<T> d_b = h_b;

  thrust::host_vector<T>   h_result(h_a.size() + h_b.size());
  thrust::device_vector<T> d_result(h_result.size());

  typename thrust::host_vector<T>::iterator   h_end;
  typename thrust::device_vector<T>::iterator d_end;
  
  h_end = thrust::set_symmetric_difference(h_a.begin(), h_a.end(),
                                           h_b.begin(), h_b.end(),
                                           h_result.begin());
  h_result.erase(h_end, h_result.end());

  d_end = thrust::set_symmetric_difference(d_a.begin(), d_a.end(),
                                           d_b.begin(), d_b.end(),
                                           d_result.begin());
  d_result.erase(d_end, d_result.end());

  ASSERT_EQUAL(h_result, d_result);
}
DECLARE_VARIABLE_UNITTEST(TestSetSymmetricDifferenceEquivalentRanges);


template<typename T>
void TestSetSymmetricDifferenceMultiset(const size_t n)
{
  thrust::host_vector<T> temp = unittest::random_integers<T>(2 * n);

  // restrict elements to [min,13)
  for(typename thrust::host_vector<T>::iterator i = temp.begin();
      i != temp.end();
      ++i)
  {
    int temp = static_cast<int>(*i);
    temp %= 13;
    *i = temp;
  }

  thrust::host_vector<T> h_a(temp.begin(), temp.begin() + n);
  thrust::host_vector<T> h_b(temp.begin() + n, temp.end());

  thrust::sort(h_a.begin(), h_a.end());
  thrust::sort(h_b.begin(), h_b.end());

  thrust::device_vector<T> d_a = h_a;
  thrust::device_vector<T> d_b = h_b;

  thrust::host_vector<T> h_result(h_a.size() + h_b.size());
  thrust::device_vector<T> d_result(h_result.size());

  typename thrust::host_vector<T>::iterator h_end;
  typename thrust::device_vector<T>::iterator d_end;
  
  h_end = thrust::set_difference(h_a.begin(), h_a.end(),
                                 h_b.begin(), h_b.end(),
                                 h_result.begin());
  h_result.erase(h_end, h_result.end());

  d_end = thrust::set_difference(d_a.begin(), d_a.end(),
                                 d_b.begin(), d_b.end(),
                                 d_result.begin());
  d_result.erase(d_end, d_result.end());

  ASSERT_EQUAL(h_result, d_result);
}
DECLARE_VARIABLE_UNITTEST(TestSetSymmetricDifferenceMultiset);


template<typename U>
  void TestSetSymmetricDifferenceKeyValue(size_t n)
{
  typedef key_value<U,U> T;

  thrust::host_vector<U> h_keys_a   = unittest::random_integers<U>(n);
  thrust::host_vector<U> h_values_a = unittest::random_integers<U>(n);

  thrust::host_vector<U> h_keys_b   = unittest::random_integers<U>(n);
  thrust::host_vector<U> h_values_b = unittest::random_integers<U>(n);

  thrust::host_vector<T> h_a(n), h_b(n);
  for(size_t i = 0; i < n; ++i)
  {
    h_a[i] = T(h_keys_a[i], h_values_a[i]);
    h_b[i] = T(h_keys_b[i], h_values_b[i]);
  }

  thrust::stable_sort(h_a.begin(), h_a.end());
  thrust::stable_sort(h_b.begin(), h_b.end());

  thrust::device_vector<T> d_a = h_a;
  thrust::device_vector<T> d_b = h_b;

  thrust::host_vector<T> h_result(h_a.size() + h_b.size());
  thrust::device_vector<T> d_result(h_result.size());

  typename thrust::host_vector<T>::iterator h_end;
  typename thrust::device_vector<T>::iterator d_end;
  
  h_end = thrust::set_symmetric_difference(h_a.begin(), h_a.end(),
                                           h_b.begin(), h_b.end(),
                                           h_result.begin());
  h_result.erase(h_end, h_result.begin());

  d_end = thrust::set_symmetric_difference(d_a.begin(), d_a.end(),
                                           d_b.begin(), d_b.end(),
                                           d_result.begin());

  d_result.erase(d_end, d_result.begin());

  ASSERT_EQUAL_QUIET(h_result, d_result);
}
DECLARE_VARIABLE_UNITTEST(TestSetSymmetricDifferenceKeyValue);

