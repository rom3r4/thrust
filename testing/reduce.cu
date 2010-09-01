#include <unittest/unittest.h>
#include <thrust/reduce.h>

template<typename T>
  struct max_functor
{
  __host__ __device__
  T operator()(T rhs, T lhs) const
  {
    return thrust::max(rhs,lhs);
  }
};

template<typename T>
struct is_equal_div_10_reduce
{
    __host__ __device__
    bool operator()(const T x, const T& y) const { return ((int) x / 10) == ((int) y / 10); }
};

template <class Vector>
void TestReduceSimple(void)
{
    typedef typename Vector::value_type T;

    Vector v(3);
    v[0] = 1; v[1] = -2; v[2] = 3;

    // no initializer
    ASSERT_EQUAL(thrust::reduce(v.begin(), v.end()), 2);

    // with initializer
    ASSERT_EQUAL(thrust::reduce(v.begin(), v.end(), (T) 10), 12);
}
DECLARE_VECTOR_UNITTEST(TestReduceSimple);


template <typename T>
void TestReduce(const size_t n)
{
    thrust::host_vector<T>   h_data = unittest::random_integers<T>(n);
    thrust::device_vector<T> d_data = h_data;

    T init = 13;

    T cpu_result = thrust::reduce(h_data.begin(), h_data.end(), init);
    T gpu_result = thrust::reduce(d_data.begin(), d_data.end(), init);

    ASSERT_ALMOST_EQUAL(cpu_result, gpu_result);
}
DECLARE_VARIABLE_UNITTEST(TestReduce);


template <class IntVector, class FloatVector>
void TestReduceMixedTypes(void)
{
    // make sure we get types for default args and operators correct
    IntVector int_input(4);
    int_input[0] = 1;
    int_input[1] = 2;
    int_input[2] = 3;
    int_input[3] = 4;

    FloatVector float_input(4);
    float_input[0] = 1.5;
    float_input[1] = 2.5;
    float_input[2] = 3.5;
    float_input[3] = 4.5;

    // float -> int should use using plus<int> operator by default
    ASSERT_EQUAL(thrust::reduce(float_input.begin(), float_input.end(), (int) 0), 10);
    
    // int -> float should use using plus<float> operator by default
    ASSERT_EQUAL(thrust::reduce(int_input.begin(), int_input.end(), (float) 0.5), 10.5);
}
void TestReduceMixedTypesHost(void)
{
    TestReduceMixedTypes< thrust::host_vector<int>, thrust::host_vector<float> >();
}
DECLARE_UNITTEST(TestReduceMixedTypesHost);
void TestReduceMixedTypesDevice(void)
{
    TestReduceMixedTypes< thrust::device_vector<int>, thrust::device_vector<float> >();
}
DECLARE_UNITTEST(TestReduceMixedTypesDevice);


template <typename T>
void TestReduceWithOperator(const size_t n)
{
    thrust::host_vector<T>   h_data = unittest::random_integers<T>(n);
    thrust::device_vector<T> d_data = h_data;

    T init = 0;

    T cpu_result = thrust::reduce(h_data.begin(), h_data.end(), init, max_functor<T>());
    T gpu_result = thrust::reduce(d_data.begin(), d_data.end(), init, max_functor<T>());

    ASSERT_EQUAL(cpu_result, gpu_result);
}
DECLARE_VARIABLE_UNITTEST(TestReduceWithOperator);


template <typename T>
struct plus_mod3
{
    T * table;

    plus_mod3(T * table) : table(table) {}

    __host__ __device__
    T operator()(T a, T b)
    {
        return table[(int) (a + b)];
    }
};

template <typename Vector>
void TestReduceWithIndirection(void)
{
    // add numbers modulo 3 with external lookup table
    typedef typename Vector::value_type T;

    Vector data(7);
    data[0] = 0;
    data[1] = 1;
    data[2] = 2;
    data[3] = 1;
    data[4] = 2;
    data[5] = 0;
    data[6] = 1;

    Vector table(6);
    table[0] = 0;
    table[1] = 1;
    table[2] = 2;
    table[3] = 0;
    table[4] = 1;
    table[5] = 2;

    T result = thrust::reduce(data.begin(), data.end(), T(0), plus_mod3<T>(thrust::raw_pointer_cast(&table[0])));
    
    ASSERT_EQUAL(result, T(1));
}
DECLARE_VECTOR_UNITTEST(TestReduceWithIndirection);

