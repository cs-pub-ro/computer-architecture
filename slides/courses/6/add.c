#define N 10
int n[N];
int sum;
int main() {
    int i=0;
    for (i=0; i<N; i++) {
        n[i] = i;
    }
    sum=0;
    for (i=0; i<N; i++) {
        sum += n[i];
    }
    return sum;
}