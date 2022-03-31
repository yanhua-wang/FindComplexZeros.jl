# Find complex zeros of a function

This package uses a discretised version of the argument principle to find regions containing zeros of an analytic function.

![an exponential sum](https://user-images.githubusercontent.com/42966414/160807046-31cc6d57-d05d-4e67-80e8-074cdfa4faeb.png)

## Installing the package

```julia
using Pkg
Pkg.add("FindComplexZeros")
```

## Using the package

```julia
using FindComplexZeros
```

### findZerosWithSubdivision

Find zeros of a function within a given rectangular domain.

Each line of result contains the upper left, lower right corner of the rectangular box that contains the zero

An example:

```julia
function an_exp_sum(x)
    return (2+im)*exp((1+im)*x) + (3.5+im)*exp(x) + -im + (2 + 3im)*exp(-x) + (5 - im)*exp((-1+im)*x)
end

findZerosWithSubdivision(-10.2 + 10.22im, 10.1 - 10.1im, an_exp_sum)
```

### countZeros

Count zeros of a function in a given rectangular domain

An example:

```julia
countZeros(-5 + 5im, 5 - 5im, x -> (x - 2)^3*(x-1))
```

## Documentation

Further documentation can be accessed at the REPL or in IJulia by typing ? followed by the name of the function.

```julia-repl
?findZerosWithSubdivision
?countZeros
```

## Related packages

[ComplexPortraits.jl](https://github.com/luchr/ComplexPortraits.jl) Phase portraits for complex functions (helpful for visualising where the zeros are)
