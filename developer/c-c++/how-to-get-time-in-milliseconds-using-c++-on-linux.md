# How to get time in milliseconds using C++ on Linux?

Here we will see how to get time (the elapsed time for the program or any other kind of time).

Here we are using linux library for C++. There is a structure called timeval. This timeval stores the time in seconds, milliseconds. We can create two time for start and end, then find the difference from them.

### Example

```
#include <sys/time.h>
#include <iostream>
#include <unistd.h>
using namespace std;
main() {
   struct timeval start_time, end_time;
   long milli_time, seconds, useconds;
   gettimeofday(&start_time, NULL);
   cout << "Enter something: ";
   char ch;
   cin >> ch;
   gettimeofday(&end_time, NULL);
   seconds = end_time.tv_sec - start_time.tv_sec; //seconds
   useconds = end_time.tv_usec - start_time.tv_usec; //milliseconds
   milli_time = ((seconds) * 1000 + useconds/1000.0);
   cout << "Elapsed time: " << milli_time <<" milliseconds\n";
}
```

### Output

```
Enter something: h
Elapsed time: 2476 milliseconds
```





{% embed url="https://www.tutorialspoint.com/how-to-get-time-in-milliseconds-using-cplusplus-on-linux" %}
