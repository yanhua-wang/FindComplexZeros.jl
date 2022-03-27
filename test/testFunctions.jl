include("../src/algorithm.jl")

function unit_test_findZerosWithSubdivision(a, b, f, expected)
    pass = 1 
    box = findZerosWithSubdivision(a, b, f)
    re1 = real.(box[1][1])
    im1 = imag.(box[1][1])
    re2 = real.(box[1][2])
    im2 = imag.(box[1][2])

    if (re1 < real.(expected) < re2) && (im2 < imag.(expected) < im1)
        pass = 0
    end

    return pass 
end 

function test_singlezeros(a, b, f, err=0.01, increment=err/100, dif=0.5)
    pass = 0
    try boxes = findZerosWithSubdivision(a, b, f, err, increment, dif)
        # Ensure every box contains exactly one zero and is within error range
        for b in boxes
            if (countZeros(b[1], b[2], f, increment, dif) != 1 ) || getError(b[1], b[2]) > err
                pass = -1
            end
        end
        return pass
    # When an exception is thrown, ensure that the box returned contains zeros
    catch e
        box = e.biggerBox
        if countZeros(box[1], box[2], f, increment, dif) <= 0
            pass = 1
        end
        return pass
    end

end

function test_multiplezeros(a, b, f, err=0.01, increment=err/100, dif=0.5)
    pass = 0
    try boxes = findZerosWithSubdivision(a, b, f, err, increment, dif)
        # Ensure every box contains at least one zero and is within error range
        for b in boxes
            if (countZeros(b[1], b[2], f, increment, dif) < 1 ) || getError(b[1], b[2]) > err
                pass = -1
            end
        end
        return pass

    # When an exception is thrown, ensure that the box returned contains zeros
    catch e
        box = e.biggerBox
        if countZeros(box[1], box[2], f, increment, dif) <= 0
            pass = 1
        end
        return pass
    end

end


function randomised_countzeros(n)
    pass = 0
    for i in 1:n 
        roots = rand(-9:.1:9,6)
        function generatedPolynomial(x) 
            return (x-roots[1] - roots[2]*im)*(x-roots[3] - roots[4]*im)*(x-roots[5] - roots[6]*im)
        end
        randomPolynomial = generatedPolynomial
        if countZeros(-10 + 10im,  10 - 10im, randomPolynomial, 0.001, 0.5) != 3
            print(roots)
            pass = 1
        end
    end 
    return pass
end 

function randomised_subdivision(n)
    passes = []
    for i in 1:n 
        roots = rand(-5:.001:5,6)
        function generatedPolynomial(x) 
            return (x-roots[1] - roots[2]*im)*(x-roots[3] - roots[4]*im)*(x-roots[5] - roots[6]*im)
        end
        randomPolynomial = generatedPolynomial
        push!(passes, test_singlezeros(-10 + 10im, 10 - 10im, randomPolynomial))
    end 

    return passes
end 



