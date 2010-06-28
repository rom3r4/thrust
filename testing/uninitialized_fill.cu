#include <thrusttest/unittest.h>
#include <thrust/uninitialized_fill.h>
#include <thrust/device_malloc_allocator.h>

template <class Vector>
void TestUninitializedFillPOD(void)
{
    typedef typename Vector::value_type T;

    Vector v(5);
    v[0] = 0; v[1] = 1; v[2] = 2; v[3] = 3; v[4] = 4;

    T exemplar(7);

    thrust::uninitialized_fill(v.begin() + 1, v.begin() + 4, exemplar);

    ASSERT_EQUAL(v[0], 0);
    ASSERT_EQUAL(v[1], exemplar);
    ASSERT_EQUAL(v[2], exemplar);
    ASSERT_EQUAL(v[3], exemplar);
    ASSERT_EQUAL(v[4], 4);

    exemplar = 8;
    
    thrust::uninitialized_fill(v.begin() + 0, v.begin() + 3, exemplar);
    
    ASSERT_EQUAL(v[0], exemplar);
    ASSERT_EQUAL(v[1], exemplar);
    ASSERT_EQUAL(v[2], exemplar);
    ASSERT_EQUAL(v[3], 7);
    ASSERT_EQUAL(v[4], 4);

    exemplar = 9;
    
    thrust::uninitialized_fill(v.begin() + 2, v.end(), exemplar);
    
    ASSERT_EQUAL(v[0], 8);
    ASSERT_EQUAL(v[1], 8);
    ASSERT_EQUAL(v[2], exemplar);
    ASSERT_EQUAL(v[3], exemplar);
    ASSERT_EQUAL(v[4], 9);

    exemplar = 1;

    thrust::uninitialized_fill(v.begin(), v.end(), exemplar);
    
    ASSERT_EQUAL(v[0], exemplar);
    ASSERT_EQUAL(v[1], exemplar);
    ASSERT_EQUAL(v[2], exemplar);
    ASSERT_EQUAL(v[3], exemplar);
    ASSERT_EQUAL(v[4], exemplar);
}
DECLARE_VECTOR_UNITTEST(TestUninitializedFillPOD);


struct CopyConstructTest
{
  CopyConstructTest(void)
    :copy_constructed_on_host(false),
     copy_constructed_on_device(false)
  {}

  __host__ __device__
  CopyConstructTest(const CopyConstructTest &exemplar)
  {
#if __CUDA_ARCH__
    copy_constructed_on_device = true;
    copy_constructed_on_host   = false;
#else
    copy_constructed_on_device = false;
    copy_constructed_on_host   = true;
#endif
  }

  CopyConstructTest &operator=(const CopyConstructTest &x)
  {
    copy_constructed_on_host   = x.copy_constructed_on_host;
    copy_constructed_on_device = x.copy_constructed_on_device;
    return *this;
  }

  bool copy_constructed_on_host;
  bool copy_constructed_on_device;
};


struct TestUninitializedFillNonPOD
{
  void operator()(const size_t dummy)
  {
    // XXX nvcc 3.0b can generate this code correctly,
    //     but leave this as a known fail for now
    KNOWN_FAILURE
    typedef CopyConstructTest T;
    thrust::device_ptr<T> v = thrust::device_malloc<T>(5);

    T exemplar;
    ASSERT_EQUAL(false, exemplar.copy_constructed_on_device);
    ASSERT_EQUAL(false, exemplar.copy_constructed_on_host);

    T host_copy_of_exemplar(exemplar);
    ASSERT_EQUAL(false, exemplar.copy_constructed_on_device);
    ASSERT_EQUAL(true,  exemplar.copy_constructed_on_host);

    // copy construct v from the exemplar
    thrust::uninitialized_fill(v, v + 1, exemplar);

    T x;
    ASSERT_EQUAL(false,  x.copy_constructed_on_device);
    ASSERT_EQUAL(false,  x.copy_constructed_on_host);

    x = v[0];
    ASSERT_EQUAL(true,   x.copy_constructed_on_device);
    ASSERT_EQUAL(false,  x.copy_constructed_on_host);

    thrust::device_free(v);
  }
};
DECLARE_UNITTEST(TestUninitializedFillNonPOD);

