#include <iostream>
#include <string>
#include <list>

#include <pthread.h>

#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <math.h>

using namespace std;

float** ocean1;
float** ocean2;

enum run_t {
	r_ocean, r_time, r_all
};

typedef struct ocean_block_t {
	int i_start;
	int j_start;
	int i_end;
	int j_end;
} ocean_block_t;

int i_max;
int j_max;

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

float update_ocean_val(int i, int j) {
	float max = ocean1[i][j];
	if (i != 0){
		if (j != 0)
			if (ocean1[i-1][j-1] > max)
				max = ocean1[i-1][j-1];

		if (ocean1[i-1][j] > max)
			max = ocean1[i-1][j];

		if (j != j_max-1)
			if (ocean1[i-1][j+1] > max)
				max = ocean1[i-1][j+1];
	}

	if (j != 0)
		if (ocean1[i][j-1] > max)
			max = ocean1[i][j-1];
	if (j != j_max-1)
		if (ocean1[i][j+1] > max)
			max = ocean1[i][j+1];

	if (i != i_max-1){
		if (j != 0)
			if (ocean1[i+1][j-1] > max)
				max = ocean1[i+1][j-1];
		
		if (ocean1[i+1][j] > max)
			max = ocean1[i+1][j];

		if (j != j_max-1)
			if (ocean1[i+1][j+1] > max)
				max = ocean1[i+1][j+1];
	}

	return max-1;
}

void update_ocean_block(int i_start, int j_start, int i_size, int j_size) {
	for (int i=i_start; i<i_size; i++) {
		for (int j=j_start; j<j_size; j++) {
			ocean2[i][j] = update_ocean_val(i, j);
		}
	}
}

void* thread_update_ocean_block(void* block) {
	update_ocean_block(((ocean_block_t*)block)->i_start,
					   ((ocean_block_t*)block)->j_start,
					   ((ocean_block_t*)block)->i_end,
					   ((ocean_block_t*)block)->j_end);
	return NULL;
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

	// generate threads' structure
	long thread;
	pthread_t* thread_handles = new pthread_t[n_threads];

	// set matrix limits
	i_max = i_size;
	j_max = j_size;

	// generate lines args for threads
	ocean_block_t* lines = new ocean_block_t[n_threads];
	int rem = i_size%n_threads;
	int i=0;
	for (int t=0; t<n_threads; t++, rem--) {
		if (rem > 0) {
			lines[t].i_start = i;
			lines[t].j_start = 0;
			i+=floor(i_size/n_threads);
			lines[t].i_end = ++i;
			lines[t].j_end = j_size;
		} else {
			lines[t].i_start = i;
			lines[t].j_start = 0;
			i+=floor(i_size/n_threads);
			lines[t].i_end = i;
			lines[t].j_end = j_size;
		}
	}

	// perform u iterations
	for (int uu=0; uu<u; uu++) {
		// create a job for each thread
		for (int t=0; t<n_threads; t++) {
			pthread_create(&thread_handles[t], NULL,
				thread_update_ocean_block, (void*) &lines[t]);
		}

		// join finished jobs
		for (int t=0; t<n_threads; t++) {
			void* ret;
			pthread_join(thread_handles[t], &ret);
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

		cout << time << endl;
	}

	return 0;
}