#include <stdlib.h>
#include <stdio.h>

#define MAXLEN 256

enum direction { UP, DOWN, LEFT, RIGHT };

struct lab {
    int *map;
    int guard_x;
    int guard_y;
    enum direction guard_dir;
    size_t width, height;
};

int access_lab(const struct lab *l, size_t x, size_t y)
{
    return l->map[y * l->width + x];
}

void set_lab(struct lab *l, size_t x, size_t y, int c)
{
    // printf("x: %zu, y: %zu, c: %c\n", x, y, c);
    l->map[y * l->width + x] = c;
}

void reset_lab(struct lab *l, size_t x0, size_t y0)
{
    for (size_t i = 0; i < l->height; ++i)
    {
        for (size_t j = 0; j < l->width; ++j)
        {
            if (access_lab(l, j, i) != '#')
                set_lab(l, j, i, '.');
        }
    }
    l->guard_x = x0;
    l->guard_y = y0;
    l->guard_dir = UP;
    set_lab(l, x0, y0, 'X');
}



void initialize_lab(struct lab *l, const char *path)
{
    FILE *input = fopen(path, "r");
    char *buf = malloc(MAXLEN * sizeof(char));
    if (buf == NULL) {
        perror("Unable to allocate buffer");
        exit(1);
    }

    size_t max_len = MAXLEN;
    ssize_t width = getline(&buf, &max_len, input) - 1;
    size_t height = 1;
    while (getline(&buf, &max_len, input) != -1)
        ++height;
    rewind(input);

    // printf("width: %zu, height: %zu\n", width, height);
    l->map = malloc(height * width * sizeof(int));
    l->width = width;
    l->height = height;

    for (size_t y = 0; y < height; ++y)
    {
        getline(&buf, &max_len, input);
        for (size_t x = 0; x < width; ++x)
        {
            set_lab(l, x, y, buf[x]);
            if (buf[x] == '^')
            {
                // printf("Guard found at %zu, %zu\n", x, y);
                l->guard_x = x;
                l->guard_y = y;
                l->guard_dir = UP;
                set_lab(l, x, y, 'X');
            }
        }
    }

    free(buf);

}


void display_lab(const struct lab *l)
{
    for (size_t i = 0; i < l->height; ++i)
    {
        for (size_t j = 0; j < l->width; ++j)
        {
            printf("%c", access_lab(l, j, i));
        }
        printf("\n");
    }
}

enum direction turn_right(enum direction d)
{
    switch (d)
    {
        case UP:
            return RIGHT;
        case RIGHT:
            return DOWN;
        case DOWN:
            return LEFT;
        case LEFT:
            return UP;
    }
}

int guard_step(struct lab *l)
{
    size_t x = l->guard_x;
    size_t y = l->guard_y;
    enum direction d = l->guard_dir;

    switch (d)
    {
        case UP:
            if (y == 0)
                return -1;
            if (access_lab(l, x, y-1) == '#' || access_lab(l, x, y-1) == 'O')
            {
                l->guard_dir = turn_right(d);
                return 0;
            }
            else
            {
                l->guard_y = y - 1;
                set_lab(l, x, y-1, 'X');
                return 1;
            }

        case RIGHT:
            if (x == l->width - 1)
                return -1;
            if (access_lab(l, x+1, y) == '#' || access_lab(l, x+1, y) == 'O')
            {
                l->guard_dir = turn_right(d);
                return 0;
            }
            else
            {
                l->guard_x = x + 1;
                set_lab(l, x+1, y, 'X');
                return 1;
            }

        case DOWN:
            if (y == l->height - 1)
                return -1;
            if (access_lab(l, x, y+1) == '#' || access_lab(l, x, y+1) == 'O')
            {
                l->guard_dir = turn_right(d);
                return 0;
            }
            else
            {
                l->guard_y = y + 1;
                set_lab(l, x, y+1, 'X');
                return 1;
            }

        case LEFT:
            if (x == 0)
                return -1;
            if (access_lab(l, x-1, y) == '#' || access_lab(l, x-1, y) == 'O')
            {
                l->guard_dir = turn_right(d);
                return 0;
            }
            else
            {
                l->guard_x = x - 1;
                set_lab(l, x-1, y, 'X');
                return 1;
            }

    }

    set_lab(l, l->guard_x, l->guard_y, 'X');
}



void free_lab(struct lab *l)
{
    free(l->map);
}

int count_posision(const struct lab *l)
{
    int count = 0;
    for (size_t i = 0; i < l->height; ++i)
    {
        for (size_t j = 0; j < l->width; ++j)
        {
            if (access_lab(l, j, i) == 'X')
                ++count;
        }
    }
    return count;
}


void partI(const char *path)
{
    struct lab l;
    initialize_lab(&l, path);
    // display_lab(&l);
    // printf("Guard position: %d, %d\n", l.guard_x, l.guard_y);
    int step = 0;
    int update;
    while ((update = guard_step(&l)) != -1)
    {
        step += update;
        // display_lab(&l);
        // printf("Guard position: %d, %d\n", l.guard_x, l.guard_y);
    }
    printf("I\tGuard made %d steps, but that's not the question\n", step);
    printf("\tGuard visited %d positions\n", count_posision(&l));
    free_lab(&l);
}


void partII(const char *path)
{
    struct lab l;
    initialize_lab(&l, path);
    int init_guard_x = l.guard_x,
        init_guard_y = l.guard_y;

    int max_steps = l.width * l.height;

    int nb_loop = 0;

    for (size_t y = 0; y < l.height; ++y)
    {
        for (size_t x = 0; x < l.width; ++x)
        {
            reset_lab(&l, init_guard_x, init_guard_y);
            if (access_lab(&l, x, y) == '#')
                continue;
            set_lab(&l, x, y, 'O');
            // printf("II\tadd obstacle in %zu, %zu\n", x, y);
            // display_lab(&l);
            int step = 0, update;
            while ((update = guard_step(&l)) != -1 && step <= max_steps)
            {
                step += update;
                if (step > max_steps)
                    break;
            }
            if (step > max_steps)
            {
                printf("II\tGuard is in a loop ! %zu, %zu\n", x, y);
                ++nb_loop;
            }
        }
    }

    printf("\tGuard is in a loop %d times\n", nb_loop);

    free_lab(&l);
}



int main(int argc, char *argv[])
{
    partI(argv[1]);
    partII(argv[1]);
    return 0;
}