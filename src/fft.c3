import std::math;
import std::io;
import std::core::mem;

struct Complex
{
    double real;
    double imag;
}

fn Complex complex(double real, double imag)
{
    return {.real = real, .imag = imag};
}

fn Complex complex_add(Complex a, Complex b)
{
    return {.real = a.real + b.real, .imag = a.imag + b.imag};
}

fn Complex complex_sub(Complex a, Complex b)
{
    return {.real = a.real - b.real, .imag = a.imag - b.imag};
}

fn Complex complex_mul(Complex a, Complex b)
{
    return {
        .real = a.real * b.real - a.imag * b.imag,
        .imag = a.real * b.imag + a.imag * b.real
    };
}

fn Complex complex_polar(double magnitude, double phase)
{
    return {
        .real = magnitude * math::cos(phase),
        .imag = magnitude * math::sin(phase)
    };
}

fn bool is_power_of_2(usz n)
{
    return n != 0 && (n & (n - 1)) == 0;
}

fn void bit_reverse(Complex[] x)
{
    usz n = x.len;
    usz j = 0;
    
    for (usz i = 1; i < n; i++)
    {
        usz bit = n >> 1;
        while (j & bit)
        {
            j ^= bit;
            bit >>= 1;
        }
        j ^= bit;
        
        if (i < j)
        {
            Complex temp = x[i];
            x[i] = x[j];
            x[j] = temp;
        }
    }
}

fn void fft_inplace(Complex[] x)
{
    usz n = x.len;
    
    if (!is_power_of_2(n))
    {
        io::printn("Error: Input length must be a power of 2");
        return;
    }
    
    bit_reverse(x);
    
    for (usz length = 2; length <= n; length <<= 1)
    {
        double angle = -2.0 * math::PI / (double)length;
        Complex wlen = complex_polar(1.0, angle);
        
        for (usz i = 0; i < n; i += length)
        {
            Complex w = complex(1.0, 0.0);
            for (usz j = 0; j < length / 2; j++)
            {
                Complex u = x[i + j];
                Complex v = complex_mul(x[i + j + length / 2], w);
                x[i + j] = complex_add(u, v);
                x[i + j + length / 2] = complex_sub(u, v);
                w = complex_mul(w, wlen);
            }
        }
    }
}

fn void ifft_inplace(Complex[] x)
{
    usz n = x.len;

    for (usz i = 0; i < n; i++)
    {
        x[i].imag = -x[i].imag;
    }

    fft_inplace(x);
    
    for (usz i = 0; i < n; i++)
    {
        x[i].imag = -x[i].imag;
        x[i].real /= (double)n;
        x[i].imag /= (double)n;
    }
}

fn void print_complex_array(Complex[] x, String name)
{
    io::printf("%s: [", name);
    for (usz i = 0; i < x.len; i++)
    {
        if (math::abs(x[i].imag) < 1e-10)
        {
            io::printf("%.3f", x[i].real);
        }
        else if (x[i].imag >= 0)
        {
            io::printf("%.3f+%.3fi", x[i].real, x[i].imag);
        }
        else
        {
            io::printf("%.3f%.3fi", x[i].real, x[i].imag);
        }
        
        if (i < x.len - 1) io::print(", ");
    }
    io::printn("]");
}