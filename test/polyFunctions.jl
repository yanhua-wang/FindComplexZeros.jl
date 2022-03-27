# Basic polynomials 

function poly1(x)
    # 0 (2 times)
    return x^2
end

function poly2(x)
    # 0 (5 times)
    return x^5
end

function poly3(x)
    # -1.222 + i (2 times)
    return (x+1.222-im)^2
end

function poly4(x)
    # 2, -1
    return (x - 2) * (x + 1)
end

function poly5(x)
    # i, -i
    return x^2 + 1
end

function poly6(x)
    # 2i, -3i
    return (x - 2im) * (x + 3im)
end

function poly7(x)
    # i, -i, -10i
    return (x - im) * (x + im) * (x + 10im)
end

function poly8(x)
    # i, -i, -1.5i
    return (x - im) * (x + im) * (x + 1.5im)
end

function poly9(x)
    # 2, -2, 3
    return (x - 2) * (x + 2) * (x - 3)
end

function poly10(x)
    # 2i, -2i, 3
    return (x - 2 * im) * (x + 2 * im) * (x - 3)
end

function poly11(x)
    # 3 roots
    return x^3 - 1
end

# Irrational roots
function poly12(x)
    return x + 3 * (pi / 8 + pi / 8 * im)
end

function poly13(x)
    return x - (pi / 4 + pi / 8 * im)
end

function poly14(x)
    return x - (exp(1) + exp(1) * im)
end

function poly15(x)
    return x - exp(1)
end

function poly16(x)
    return x + pi * im
end

function poly17(x)
    return (x - exp(1))^3
end

function poly18(x)
    return (x - exp(1) * im)^3
end

# Others

function poly19(x)
    return (x - exp(1) * im)^3 * (x - exp(1))^2
end

function poly20(x)
    return (x - 2pi * im) * (x - pi)^3 * (x + 3pi * im -2.1)^2
end

function poly21(x)
    return (x - 0.001 + 0.5*im)^2
end

function poly22(x)
    return (x - 3.4656) * (x + 3.99)^2
end

function poly100(x)
    return x^8
end

function poly101(x)
    return (x^8) * (x - 101) * 9
end

function poly102(x)
    return (x - pi)^21(x + pi * im)^18
end

function poly103(x)
    return x^25
end

function poly104(x)
    return x^17
end

function poly105(x)
    return (x^9) * (x - pi * im)^5
end

function poly106(x)
    return x^10
end

function poly107(x)
    return (x - 2.185935 * im)^10
end


function poly109(x)
    return x^59
end

function poly110(x)
    return x^60
end