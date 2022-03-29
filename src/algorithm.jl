using DataStructures

struct ZerosNearContourException <: Exception
    biggerBox::Tuple
    count:: Int
    potentialLocations::Queue{Tuple{Tuple{Any,Any},Any}}
end

Base.showerror(io::IO, e::ZerosNearContourException) = print(io, "The algorithm has terminated at the box", e.biggerBox, ", containing ", e.count,  " zeros. The remaining list of boxes that have yet to be examined, and the number of zeros they contain is: ", e.potentialLocations, "This is because there are zeros too near the contour during subdivision for the algorithm to work properly at higher precision levels. You can try using different values of arguments (eg. upper_left, lower_right, err, increment) for better results.")

"""
    countZeros(upper_left, lower_right, f::Function, increment=0.01, dif=0.5)::Int

Count zeros of a function in a given rectangular domain

# Example
```julia-repl
julia> countZeros(-5 + 5im, 5 - 5im, x->(x - exp(1) * im)^3 * (x - exp(1))^2)
5
```
"""
function countZeros(a, b, f::Function, increment=0.01, dif=0.5)::Int
    realB = real.(b)
    imagB = imag.(b)

    # Throw exception for invalid input
    if ((imagB >= imag.(a)) || (realB <= real.(a)))
        throw(ErrorException("invalid parameters, please ensure the first parameter is the upper left corner, and the second parameter is the lower right corner"))
    end
    
    count = 0

    # bottom right to top right
    while imag.(b) < imag.(a)
        angle1 = angle(f(b))
        b += increment * im
        angle2 = angle(f(b))

        if (angle1 - angle2 > 2 * pi - dif)
            count += 1
        elseif (angle1 - angle2 < -2 * pi + dif)
            count -= 1
        end 
    
    end


    # top right to top left
    b = realB + (imag.(a)) * im
    
    while real.(b) > real.(a)
        angle1 = angle(f(b))
        b -= increment
        angle2 = angle(f(b))

        if (angle1 - angle2 > 2 * pi - dif)
            count += 1
        elseif (angle1 - angle2 < -2 * pi + dif)
            count -= 1
        end 

    end

    # top left to bottom left
    while imag.(a) > imagB
        angle1 = angle(f(a))
        a -= increment * im
        angle2 = angle(f(a))

        if (angle1 - angle2 > 2 * pi - dif)
            # println("border, angle1, angle2: ", border, " ", angle1, " ", angle2)
            # println("a, b", a, " ", b)
            count += 1
        elseif (angle1 - angle2 < -2 * pi + dif)
            count -= 1
        end 
    
    end


    # bottom left to bottom right
    a = real.(a) + imagB * im
    
    while real.(a) < realB
        angle1 = angle(f(a))
        a += increment
        angle2 = angle(f(a))

        if (angle1 - angle2 > 2 * pi - dif)
            count += 1
        elseif (angle1 - angle2 < -2 * pi + dif)
            count -= 1
        end

    end
    
    return count
end

function getError(a, b)
    (abs(imag.(a) - imag.(b)) + abs(real.(b) - real.(a))) / 2
end

function findZerosWithSubdivisionAux(a, b, f::Function, dif, q::Queue{Tuple{Tuple{Any,Any},Any}}, locations::Array{Tuple{Any,Any}}, err, increment)
    # Check the number of zeros in the initial box. Check whether the sum of sub boxes matches it. 

    totalZeros = countZeros(a, b, f, increment, dif)

    if (totalZeros == 0)
        return locations
    end

    realA = real.(a)
    imagA = imag.(a)
    realB = real.(b)
    imagB = imag.(b)
    centerRe = (real.(a) + real.(b)) / 2
    centerIm = (imag.(a) + imag.(b)) / 2
    center = centerRe + centerIm * im
    
    lowerRightBox = (center, b)
    upperRightBox = (centerRe + imagA * im, realB + centerIm * im)
    upperLeftBox = (a, center)
    lowerLeftBox = (realA + centerIm * im, centerRe + imagB * im)

    count1 = countZeros(lowerRightBox[1], lowerRightBox[2], f, increment, dif)
    count2 = countZeros(upperRightBox[1], upperRightBox[2], f, increment, dif)
    count3 = countZeros(upperLeftBox[1], upperLeftBox[2], f, increment, dif)
    count4 = countZeros(lowerLeftBox[1], lowerLeftBox[2], f, increment, dif)
    
    if totalZeros != count1 + count2 + count3 + count4
        # this means that a zero is near the contour, stop and just return the existing locations
        throw(ZerosNearContourException((a,b), totalZeros, q))
    end 
    
    # Only enqueue boxes with zeros inside them

    if (count1 != 0)
        enqueue!(q, (lowerRightBox, count1))
    end

    if (count2 != 0) 
        enqueue!(q, (upperRightBox, count2))
    end

    if (count3 != 0)
        enqueue!(q, (upperLeftBox, count3)) 
    end

    if (count4 != 0) 
        enqueue!(q, (lowerLeftBox, count4))
    end

    while !isempty(q)
        (x, _) = dequeue!(q)

        if (getError(x[1], x[2]) < err)
            # Error is sufficiently small, this box joins the finalised list of locations
            push!(locations, x)
        elseif (getError(x[1], x[2]) >= err)
            # Further subdivision
            findZerosWithSubdivisionAux(x[1], x[2], f, dif, q, locations, err, increment)
        end
    
    end

    return locations
   
end

"""
    findZerosWithSubdivision(upper_left, lower_right, f::Function, err=0.01, increment = err/100, dif=0.5)

Find locations of zeros of a function within a given rectangular domain

Each line of result contains the upper left, lower right corner of the rectangular box that contains the zero

# Arguments
- `upper_left`: a complex number that is the upper left corner of rectangular domain 
- `lower_right`: a complex number that is the lower right corner of rectangular domain 
- `f::Function`: the function
- `err=0.001`: error of the location of each zero 
- `increment=err/100`: step size of the `countZeros` function
- `dif=0.5`: when the difference between ``arg(f(z))`` at 2 consecutive points of
evaluation by the `countZeros` function is greater than `2pi-dif`, a jump point is registered


# Example
```julia-repl
julia> function exp_sum(x)
    return (1+im)*exp(x) + (3.5+2*im) + (3-im)*exp(-x)
end
exp_sum (generic function with 1 method)

julia> findZerosWithSubdivision(-10 + 10im, 10 - 10im, exp_sum, 0.01)
7-element Vector{Tuple{Any, Any}}:
 (0.859375 - 3.0859375im, 0.869140625 - 3.095703125im)
 (0.859375 - 9.375im, 0.869140625 - 9.384765]625im)
 (0.859375 + 9.47265625im, 0.869140625 + 9.462890625im)
 (0.859375 + 3.193359375im, 0.869140625 + 3.18359375im)
 (-0.068359375 + 1.9921875im, -0.05859375 + 1.982421875im)
 (-0.068359375 + 8.271484375im, -0.05859375 + 8.26171875im)
 (-0.068359375 - 4.287109375im, -0.05859375 - 4.296875im)
```
"""
function findZerosWithSubdivision(upper_left, lower_right, f::Function, err=0.001, increment = err/100, dif=0.5)
    q = Queue{Tuple{Tuple{Any,Any},Any}}()
    init = Array{Tuple{Any,Any}}(undef, 0)
    locations = findZerosWithSubdivisionAux(upper_left, lower_right, f::Function, dif, q, init, err, increment)
    return locations
end

