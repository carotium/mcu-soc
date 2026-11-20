/* Matrix multiplication test:
 *
 *   a   - 1st input matrix of size M x K
 *   b   - 2nd input matrix of size K x N
 *   
 *   res -    output matrix of size M x N
*/
#define M 3
#define K 3
#define N 3

void mmult(int *a, int a_size, int *b, int b_size, int *res) {
    int sum = 0;
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < K; j++) {
            for (int k = 0; k < N; k++) {
                sum += a[k + k*M] * b[k + j*N];
            }
            res[j + i*M] = sum;
            sum = 0;
        }
    }
}

int main(void) {

    int a[M*K];
    int b[K*N];
    int res[M*N];

    for (int i = 0; i < M*K; i++) {
        a[i] = i;
        b[i] = 1;
    }

    mmult(a, M*K, b, K*N, res);

    return 0;
}