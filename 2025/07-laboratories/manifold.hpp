#ifndef _MANIFOLD_HPP_
#define _MANIFOGL_HPP_

#include <string>
#include <set>
#include <map>
#include <fstream>
#include <iostream>

#define START_STR "S"
#define SPLITTER_STR "^"

class Manifold
{
public:
    using coord_t = std::tuple<size_t, size_t>;
    using big_int = unsigned long long int;

    Manifold(const std::string filename)
    {
        M_filename = filename;
        reset();
    }

    int run_I()
    {
        reset();
        n_colision = 0;
        ray(M_beam_departure, 0);
        return n_colision;
    }

    big_int run_II()
    {
        reset();
        return timelines(M_beam_departure, 0);
    }


private:

    void reset()
    {
        std::ifstream infile(M_filename);
        std::string line, first_line;
        std::getline(infile, first_line);
        M_beam_departure = first_line.find(START_STR);
        M_depth = 0;
        M_splitters.clear();
        M_rays.clear();

        while (std::getline(infile, line))
        {
            ++M_depth;
            size_t pos = line.find(SPLITTER_STR, 0);
            while (pos != std::string::npos)
            {
                coord_t coord = {pos, M_depth};
                M_splitters.insert(coord);
                // std::cout << M_depth << ", " << pos << std::endl;
                pos = line.find("^", pos+1);
            }
        }
        // std::cout << "Number of splitters " << M_splitters.size() << std::endl;
        // std::cout << "Depth of manifold " << M_depth << std::endl;
    }

    void ray(size_t pos, size_t depth)
    {
        coord_t curr = {pos, depth};
        // we ensure that a beam has not already been accounted for
        if (M_rays.count(curr))
            return;
        M_rays.insert(curr);
        // std::cout << "Beam entering in " << pos << " at depth " << depth << std::endl;
        if (depth == M_depth)
            return;

        coord_t next_pos = {pos, depth+1};
        if (M_splitters.count(next_pos))
        {
            ++n_colision;
            M_splitters.erase(next_pos);    // doing this, we ensure that is another beam arrives here, it won't be coundted again
            ray(pos-1, depth+1);
            ray(pos+1, depth+1);
        }
        else
        {
            ray(pos, depth+1);
        }
    }

    big_int timelines(size_t pos, size_t depth)
    {
        coord_t key = {pos, depth};
        if (M_memo.count(key))
            return M_memo[key];

        if (depth == M_depth)
        {
            return M_memo[key] = 1;
        }

        big_int result;
        coord_t next = {pos, depth+1};
        if (M_splitters.count(next))
        {
            result = timelines(pos-1, depth+1) + timelines(pos+1, depth+1);
        }
        else
        {
            result = timelines(pos, depth+1);
        }
        return M_memo[key] = result;
    }

    std::string M_filename;
    size_t M_depth;
    size_t M_beam_departure;
    std::set<coord_t> M_splitters;
    std::set<coord_t> M_rays;       // set of all rays that were casted
    std::map<coord_t,big_int> M_memo;
    int n_colision;
};


#endif