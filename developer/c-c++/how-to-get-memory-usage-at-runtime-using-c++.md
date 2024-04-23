# How to get memory usage at runtime using C++?

We can get the memory usage like virtual memory usage or resident set size etc. at run time. To get them we can use some system libraries. This process depends on operating systems. For this example, we are using Linux operating system.

So here we will see how to get the memory usage statistics under Linux environment using C++. We can get all of the details from “/proc/self/stat” folder. Here we are taking the virtual memory status, and the resident set size.

### Example

{% code overflow="wrap" fullWidth="false" %}
```cpp
#include <unistd.h>
#include <ios>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void mem_usage(double& vm_usage, double& resident_set) {
   vm_usage = 0.0;
   resident_set = 0.0;
   ifstream stat_stream("/proc/self/stat",ios_base::in); //get info from proc directory
   //create some variables to get info
   string pid, comm, state, ppid, pgrp, session, tty_nr;
   string tpgid, flags, minflt, cminflt, majflt, cmajflt;
   string utime, stime, cutime, cstime, priority, nice;
   string O, itrealvalue, starttime;
   unsigned long vsize;
   long rss;
   stat_stream >> pid >> comm >> state >> ppid >> pgrp >> session >> tty_nr
   >> tpgid >> flags >> minflt >> cminflt >> majflt >> cmajflt
   >> utime >> stime >> cutime >> cstime >> priority >> nice
   >> O >> itrealvalue >> starttime >> vsize >> rss; // don't care about the rest
   stat_stream.close();
   long page_size_kb = sysconf(_SC_PAGE_SIZE) / 1024; // for x86-64 is configured to use 2MB pages
   vm_usage = vsize / 1024.0;
   resident_set = rss * page_size_kb;
}

int main() {
   double vm, rss;
   mem_usage(vm, rss);
   cout << "Virtual Memory: " << vm << "\nResident set size: " << rss << endl;
}
```
{% endcode %}

### Output

```
Virtual Memory: 13272
Resident set size: 1548
```



{% embed url="https://www.tutorialspoint.com/how-to-get-memory-usage-at-runtime-using-cplusplus" %}
