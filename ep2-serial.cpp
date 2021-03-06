#include <iostream>
#include <string>
#include <list>

#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

using namespace std;

float** ocean1;
float** ocean2;

enum run_t {
	r_ocean, r_time, r_all
};

string usage = "usage: ./ep2 {i_size} {j_size} {u} {n_threads} {ocean|time|all}";

void print_ocean(float** ocean, int i_size, int j_size) {
	for (int i=0; i<i_size; i++) {
		cout << ocean[i][0];
		for (int j=1; j<j_size; j++) {
			cout << "\t" << ocean[i][j];
		}
		cout << endl;
	}
}

float update_ocean_val(int i, int j, int i_size, int j_size) {
	float max = ocean1[i][j];
	if (i != 0){
		if (j != 0)
			if (ocean1[i-1][j-1] > max)
				max = ocean1[i-1][j-1];

		if (ocean1[i-1][j] > max)
			max = ocean1[i-1][j];

		if (j != j_size-1)
			if (ocean1[i-1][j+1] > max)
				max = ocean1[i-1][j+1];
	}

	if (j != 0)
		if (ocean1[i][j-1] > max)
			max = ocean1[i][j-1];
	if (j != j_size-1)
		if (ocean1[i][j+1] > max)
			max = ocean1[i][j+1];

	if (i != i_size-1){
		if (j != 0)
			if (ocean1[i+1][j-1] > max)
				max = ocean1[i+1][j-1];
		
		if (ocean1[i+1][j] > max)
			max = ocean1[i+1][j];

		if (j != j_size-1)
			if (ocean1[i+1][j+1] > max)
				max = ocean1[i+1][j+1];
	}

	return max-1;
}

int main(int argc, char const *argv[]) {
	
	// get args
	int i_size, j_size;
	int u;
	int n_threads;
	run_t run_type;
	if (argc != 6) {
		cout << usage << endl;
		return 1;
	}

	i_size = stoi(string(argv[1]), nullptr);
	j_size = stoi(string(argv[2]), nullptr);
	u = stoi(string(argv[3]), nullptr);
	n_threads = stoi(string(argv[4]));

	if (strcmp(argv[5], "ocean") == 0)
		run_type = r_ocean;
	else if (strcmp(argv[5], "time") == 0)
		run_type = r_time;
	else if (strcmp(argv[5], "all") == 0)
		run_type = r_all;
	else {
		std::cout << usage << std::endl;
		return 2;	
	}

	// allocate oceans
	ocean1 = new float*[i_size];
	ocean2 = new float*[i_size];
	for (int i=0; i<i_size; i++) {
		ocean1[i] = new float[j_size];
		ocean2[i] = new float[j_size];
	}

	// get ocean values
	for (int i=0; i<i_size; i++) {
		for (int j=0; j<j_size; j++) {
			cin >> ocean1[i][j];
		}
	}

	struct timeval beginT, endT;
	gettimeofday(&beginT,NULL);

	// perform u iterations
	for (int uu=0; uu<u; uu++) {
		for (int i=0; i<i_size; i++) {
			for (int j=0; j<j_size; j++) {
				ocean2[i][j] = update_ocean_val(i, j, i_size, j_size);
			}
		}
		float** temp_ocean = ocean1;
		ocean1 = ocean2;
		ocean2 = temp_ocean;

		// cout << "it " << uu << endl;
		// print_ocean(ocean1, i_size, j_size);
	}

	gettimeofday(&endT,NULL);

	// print ocean if this was selected
	if (run_type == r_ocean || run_type == r_all) {
		print_ocean(ocean1, i_size, j_size);
	}

	// print time if this was selected
	if (run_type == r_time || run_type == r_all) {
		__time_t time = ((endT.tv_sec*1000000+endT.tv_usec)-
			(beginT.tv_sec*1000000+beginT.tv_usec));

		cout << time;
		#ifndef NO_NEW_LINE
		cout << endl;
		#endif
	}

	return 0;
}