#include <iostream>
#include <string>
#include <list>

#include <pthread.h>

#include <stdlib.h>
#include <string.h>
#include <sys/time.h>


#include <unistd.h>


using namespace std;

float** ocean;

enum run_t {
	r_ocean, r_time, r_all
};

string usage = "usage: ./ep2 {i_size} {j_size} {u} {n_threads} {ocean|time|all}";

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

	// allocate ocean
	ocean = new float*[i_size];
	for (int i=0; i<i_size; i++)
		ocean[i] = new float[j_size];

	// get ocean values
	for (int i=0; i<i_size; i++) {
		for (int j=0; j<j_size; j++) {
			cin >> ocean[i][j];
		}
	}

	struct timeval beginT, endT;
	gettimeofday(&beginT,NULL);

	// ALGORITHM

	gettimeofday(&endT,NULL);

	// print ocean if this was selected
	if (run_type == r_ocean || run_type == r_all) {
		for (int i=0; i<i_size; i++) {
			cout << ocean[i][0];
			for (int j=1; j<j_size; j++) {
				cout << "\t" << ocean[i][j];
			}
			cout << endl;
		}
	}

	// print time if this was selected
	if (run_type == r_time || run_type == r_all) {
		__time_t time = ((endT.tv_sec*1000000+endT.tv_usec)-
			(beginT.tv_sec*1000000+beginT.tv_usec));

		cout << time << endl;
	}

	return 0;
}