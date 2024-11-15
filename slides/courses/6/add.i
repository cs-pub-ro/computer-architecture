# 1 "add.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 361 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "add.c" 2

int n[10];
int sum;
int main() {
    int i=0;
    for (i=0; i<10; i++) {
        n[i] = i;
    }
    sum=0;
    for (i=0; i<10; i++) {
        sum += n[i];
    }
    return sum;
}
