include("testFunctions.jl")
include("polyFunctions.jl")


@testset "findZerosWithSubdivision returns boxes containing zeros, and falling within error" begin
    @test unit_test_findZerosWithSubdivision(-20 + 20.2im, 10 - 9.8im, poly3, -1.222+im) == 0
    @test unit_test_findZerosWithSubdivision(-20 + 20.2im, 10 - 9.8im, poly13, (pi / 4 + pi / 8 * im)) == 0
    

    @test test_singlezeros(-20 + 20.2im, 20 - 20im, poly4, 0.01) >= 0
    @test test_singlezeros(-20 + 20.2im, 20 - 20im, poly5, 0.01) >= 0
    @test test_singlezeros(-20 + 20.2im, 20 - 20im, poly6, 0.01) >= 0
    @test test_singlezeros(-20 + 20.2im, 20 - 20im, poly7, 0.01) >= 0
    @test test_singlezeros(-20 + 20.2im, 20 - 20im, poly8, 0.01) >= 0
    @test test_singlezeros(-20 + 20.2im, 15 - 20im, poly9, 0.01) >= 0
    @test test_singlezeros(-20 + 20.2im, 20 - 20im, poly10, 0.01) >= 0
    @test test_singlezeros(-2 + 2im, 2 - 2im, poly12, 0.01) >= 0
    @test test_singlezeros(-5 + 5im, 5 - 5im, poly14, 0.01) >= 0 
    @test test_singlezeros(-9 + 4.3im, 6 - 8.8im, poly14, 0.001) >= 0
    @test test_singlezeros(-5.6 + 5.6im, 6.5 - 5.2im, poly15, 0.01) >= 0
    @test test_singlezeros(-6.6 + 5.1im, 8 - 5.3im, poly16, 0.01) >= 0
    @test test_singlezeros(-5 + 5im, 5 - 5im, poly17, 0.01) >= 0

    @test test_multiplezeros(-5.3 + 5.2im, 5 - 5im, poly18, 0.01) >= 0
    @test test_multiplezeros(-5 + 5im, 5 - 5im, poly19, 0.01) >= 0
    @test test_multiplezeros(-5 + 5im, 5 - 5im, poly20, 0.01) >= 0
    @test test_multiplezeros(-5 + 5im, 5 - 5im, poly21, 0.01) >= 0
    @test test_multiplezeros(-5 + 5im, 5 - 5im, poly22, 0.01) >= 0
end;


# Randomised testing

passes = randomised_subdivision(100)
@testset "Randomised testing for findZerosWithSubdivision" begin @test !(-1 in passes) && (count(j -> (j == 0), passes) > 75) end
