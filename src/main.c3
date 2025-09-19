import std::io;
import std::core::mem;
import fft;

fn int main()
{
    fft::Complex[4] impulse = {
        fft::complex(1.0, 0.0),
        fft::complex(0.0, 0.0),
        fft::complex(0.0, 0.0),
        fft::complex(0.0, 0.0)
    };
    
    fft::print_complex_array(impulse[0..3], "Input");
    fft::fft_inplace(impulse[0..3]);
    fft::print_complex_array(impulse[0..3], "FFT");
    fft::ifft_inplace(impulse[0..3]);
    fft::print_complex_array(impulse[0..3], "IFFT");
    
    io::printn("");
    
    fft::Complex[4] sine = {
        fft::complex(0.0, 0.0),
        fft::complex(1.0, 0.0),
        fft::complex(0.0, 0.0),
        fft::complex(-1.0, 0.0)
    };
    
    fft::print_complex_array(sine[0..3], "Input");
    fft::fft_inplace(sine[0..3]);
    fft::print_complex_array(sine[0..3], "FFT");
    fft::ifft_inplace(sine[0..3]);
    fft::print_complex_array(sine[0..3], "IFFT");
    
    io::printn("");
    
    fft::Complex[8] larger = {
        fft::complex(1.0, 0.0),
        fft::complex(2.0, 0.0),
        fft::complex(3.0, 0.0),
        fft::complex(4.0, 0.0),
        fft::complex(0.0, 0.0),
        fft::complex(0.0, 0.0),
        fft::complex(0.0, 0.0),
        fft::complex(0.0, 0.0)
    };
    
    fft::print_complex_array(larger[0..7], "Input");
    fft::fft_inplace(larger[0..7]);
    fft::print_complex_array(larger[0..7], "FFT");
    fft::ifft_inplace(larger[0..7]);
    fft::print_complex_array(larger[0..7], "IFFT");
    
    return 0;
}