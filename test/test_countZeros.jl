include("testFunctions.jl")
include("polyFunctions.jl")
include("../src/algorithm.jl")

@testset "countZeros counts zeros" begin
    @test_throws ErrorException countZeros(-2 - 5im, 2 - 3im, poly10, 0.01, 0.3)
    @test countZeros(-2 + 2im, 2 - 2im, poly1, 0.1, 0.5) == 2
    @test countZeros(-2 + 2im, 2 - 2im, poly2, 0.1, 0.5) == 5
    @test countZeros(-2 + 2im, 2 - 2im, poly3, 0.01, 0.5) == 2
    @test countZeros(-2 + 2im, 3 - 2im, poly4, 0.01, 0.5) == 2
    @test countZeros(-2 + 2im, 2 - 2im, poly5, 0.01, 0.5) == 2
    @test countZeros(-2 + 5im, 2 - 2im, poly6, 0.01, 0.6) == 1
    @test countZeros(-2 + 2im, 2 - 2im, poly7, 0.01, 0.5) == 2
    @test countZeros(-2 + 2im, 2 - 2im, poly8, 0.01, 0.8) == 3
    @test countZeros(-4 + 5im, 4 - 2im, poly9, 0.01, 0.3) == 3
    @test countZeros(-2 + 4im, 2 - 3im, poly10, 0.01, 0.1) == 2
    @test countZeros(-2 + 4im, 5 - 3im, poly10, 0.01, 0.1) == 3
    @test countZeros(-2 + 5im, 3 - 3im, poly11, 0.01, 0.1) == 3
end;

# Randomised testing

pass = randomised_countzeros(100)
@testset "Randomised testing for countZeros" begin @test pass == 0 end

