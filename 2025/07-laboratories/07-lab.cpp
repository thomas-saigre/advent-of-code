#include <iostream>
#include "manifold.hpp"


int main(int argc, char **argv)
{
    std::string filename;
    if (argc > 1)
        filename = argv[1];
    else
        return 1;

    Manifold manifold = Manifold(filename);

    int I = manifold.run_I();
    std::cout << I << std::endl;

    Manifold::big_int II = manifold.run_II();
    std::cout << II << std::endl;

    // 108924003331749

    return 0;
}